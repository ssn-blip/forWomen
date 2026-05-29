import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// 스트립 분석 결과.
class StripAnalysis {
  StripAnalysis({
    required this.croppedPath,
    required this.ratio,
    required this.suggested,
  });

  /// 크롭된 라인 이미지 경로 (목록/타임라인 표시용)
  final String croppedPath;

  /// T/C 진하기 비율 (0~ , 1에 가까울수록 진한 양성)
  final double ratio;

  /// 추정 결과: positive | faint | negative | unknown
  final String suggested;
}

/// 크롭 영역(이미지 비율 0~1)을 분석해 C/T 라인 진하기로 결과를 추정한다.
/// 참고용 보조 — C선이 항상 더 진하다는 가정(C=더 진한 선, T=나머지)으로
/// 좌우 방향에 무관하게 동작한다.
Future<StripAnalysis> analyzeStrip(String srcPath, Rect cropFrac) async {
  final bytes = await File(srcPath).readAsBytes();
  var im = img.decodeImage(bytes);
  if (im == null) throw Exception('이미지를 읽을 수 없습니다.');
  im = img.bakeOrientation(im);

  final x = (cropFrac.left * im.width).round().clamp(0, im.width - 1);
  final y = (cropFrac.top * im.height).round().clamp(0, im.height - 1);
  final w = (cropFrac.width * im.width).round().clamp(1, im.width - x);
  final h = (cropFrac.height * im.height).round().clamp(1, im.height - y);
  final crop = img.copyCrop(im, x: x, y: y, width: w, height: h);

  // 크롭 이미지 저장(표시용).
  final docs = await getApplicationDocumentsDirectory();
  final dir = Directory(p.join(docs.path, 'tests'));
  if (!await dir.exists()) await dir.create(recursive: true);
  final outPath =
      p.join(dir.path, 'strip_${DateTime.now().millisecondsSinceEpoch}.png');
  await File(outPath).writeAsBytes(img.encodePng(crop));

  // 분석은 가로 축소본으로(속도).
  final small = crop.width > 400 ? img.copyResize(crop, width: 400) : crop;
  final sw = small.width, sh = small.height;

  // 열별 어두움(255-휘도) 평균 프로파일.
  final colDark = List<double>.filled(sw, 0);
  for (var cx = 0; cx < sw; cx++) {
    double sum = 0;
    for (var cy = 0; cy < sh; cy++) {
      final px = small.getPixel(cx, cy);
      final lum = 0.299 * px.r + 0.587 * px.g + 0.114 * px.b;
      sum += 255 - lum;
    }
    colDark[cx] = sum / sh;
  }

  // 배경(멤브레인) 기준선 = 하위 25퍼센타일.
  final sorted = [...colDark]..sort();
  final baseline = sorted[(sorted.length * 0.25).floor()];
  final rel = colDark.map((d) => (d - baseline).clamp(0.0, 1e9)).toList();

  // 가장 진한 선 두 개 찾기(서로 떨어진).
  ({int x, double v}) peakIn(int from, int to) {
    var bx = from;
    var bv = -1.0;
    for (var i = from; i < to; i++) {
      if (rel[i] > bv) {
        bv = rel[i];
        bx = i;
      }
    }
    return (x: bx, v: bv);
  }

  final p1 = peakIn(0, sw);
  final gap = (sw * 0.08).round().clamp(3, sw);
  var bestX2 = -1;
  var bestV2 = -1.0;
  for (var i = 0; i < sw; i++) {
    if ((i - p1.x).abs() < gap) continue;
    if (rel[i] > bestV2) {
      bestV2 = rel[i];
      bestX2 = i;
    }
  }

  // C = 더 진한 선, T = 나머지.
  final cVal = p1.v;
  final tVal = bestX2 >= 0 ? bestV2 : 0.0;

  const minControl = 8.0; // 컨트롤선 최소 진하기
  String suggested;
  double ratio = 0;
  if (cVal < minControl) {
    suggested = 'unknown'; // 선이 거의 안 보임 → 판독 불가
  } else {
    final minSecond = (0.1 * cVal).clamp(4.0, 1e9);
    if (tVal < minSecond) {
      suggested = 'negative'; // 컨트롤선만 → 음성
    } else {
      ratio = (tVal / cVal).clamp(0, 2).toDouble();
      if (ratio >= 0.7) {
        suggested = 'positive';
      } else if (ratio >= 0.15) {
        suggested = 'faint';
      } else {
        suggested = 'negative';
      }
    }
  }

  return StripAnalysis(croppedPath: outPath, ratio: ratio, suggested: suggested);
}

/// 스트립 사진에서 결과창을 크롭하고 분석하는 화면.
/// 분석 결과([StripAnalysis])를 Navigator.pop으로 돌려준다.
class TestStripCropScreen extends StatefulWidget {
  const TestStripCropScreen({super.key, required this.srcPath});

  final String srcPath;

  @override
  State<TestStripCropScreen> createState() => _TestStripCropScreenState();
}

class _TestStripCropScreenState extends State<TestStripCropScreen> {
  ui.Image? _img;
  Rect? _crop; // 표시 좌표계 기준
  Size _disp = Size.zero;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final bytes = await File(widget.srcPath).readAsBytes();
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    setState(() => _img = frame.image);
  }

  Future<void> _analyze() async {
    if (_crop == null || _disp == Size.zero) return;
    setState(() => _busy = true);
    try {
      final frac = Rect.fromLTWH(
        (_crop!.left / _disp.width).clamp(0.0, 1.0),
        (_crop!.top / _disp.height).clamp(0.0, 1.0),
        (_crop!.width / _disp.width).clamp(0.0, 1.0),
        (_crop!.height / _disp.height).clamp(0.0, 1.0),
      );
      final result = await analyzeStrip(widget.srcPath, frac);
      if (mounted) Navigator.pop(context, result);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('분석 실패: $e')));
        setState(() => _busy = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final image = _img;
    return Scaffold(
      appBar: AppBar(title: const Text('결과창 선택')),
      body: image == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                    'C/T 라인이 보이는 결과창에 박스를 맞춰주세요.\n'
                    '(스트립을 가로로 두면 인식이 잘 됩니다)',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ),
                Expanded(
                  child: LayoutBuilder(builder: (context, c) {
                    final aspect = image.width / image.height;
                    var dw = c.maxWidth;
                    var dh = dw / aspect;
                    if (dh > c.maxHeight) {
                      dh = c.maxHeight;
                      dw = dh * aspect;
                    }
                    _disp = Size(dw, dh);
                    _crop ??= Rect.fromLTWH(dw * 0.1, dh * 0.3, dw * 0.8, dh * 0.4);
                    return Center(
                      child: SizedBox(
                        width: dw,
                        height: dh,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Image.file(File(widget.srcPath),
                                  fit: BoxFit.fill),
                            ),
                            _CropOverlay(
                              crop: _crop!,
                              bounds: Size(dw, dh),
                              onChanged: (r) => setState(() => _crop = r),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _busy ? null : _analyze,
                      icon: _busy
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2))
                          : const Icon(Icons.search),
                      label: Text(_busy ? '분석 중...' : '이 영역 분석'),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

/// 이동·크기조절 가능한 크롭 박스 오버레이.
class _CropOverlay extends StatelessWidget {
  const _CropOverlay({
    required this.crop,
    required this.bounds,
    required this.onChanged,
  });

  final Rect crop;
  final Size bounds;
  final ValueChanged<Rect> onChanged;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: crop.left,
          top: crop.top,
          width: crop.width,
          height: crop.height,
          child: GestureDetector(
            onPanUpdate: (d) {
              var l = (crop.left + d.delta.dx)
                  .clamp(0.0, bounds.width - crop.width);
              var t = (crop.top + d.delta.dy)
                  .clamp(0.0, bounds.height - crop.height);
              onChanged(Rect.fromLTWH(l, t, crop.width, crop.height));
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.pinkAccent, width: 2),
                color: Colors.pinkAccent.withValues(alpha: 0.12),
              ),
            ),
          ),
        ),
        // 우하단 크기 조절 핸들
        Positioned(
          left: crop.right - 22,
          top: crop.bottom - 22,
          width: 44,
          height: 44,
          child: GestureDetector(
            onPanUpdate: (d) {
              final w = (crop.width + d.delta.dx)
                  .clamp(40.0, bounds.width - crop.left);
              final h = (crop.height + d.delta.dy)
                  .clamp(30.0, bounds.height - crop.top);
              onChanged(Rect.fromLTWH(crop.left, crop.top, w, h));
            },
            child: Center(
              child: Container(
                width: 22,
                height: 22,
                decoration: const BoxDecoration(
                  color: Colors.pinkAccent,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.open_in_full,
                    size: 13, color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
