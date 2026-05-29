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

  // 분석용 축소본(속도). 가로/세로 모두 처리하기 위해 긴 변 기준 축소.
  final small = (crop.width > 400 || crop.height > 400)
      ? img.copyResize(crop,
          width: crop.width >= crop.height ? 400 : null,
          height: crop.height > crop.width ? 400 : null)
      : crop;
  final sw = small.width, sh = small.height;

  // 1차원 어두움 프로파일에서 (왼쪽선=C, 오른쪽선=T) 값을 찾는다.
  ({double cVal, double tVal, double maxV}) twoLines(List<double> dark) {
    final sorted = [...dark]..sort();
    final baseline = sorted[(sorted.length * 0.25).floor()];
    final rel = dark.map((d) => (d - baseline).clamp(0.0, 1e9)).toList();
    final n = rel.length;
    var x1 = 0;
    var v1 = -1.0;
    for (var i = 0; i < n; i++) {
      if (rel[i] > v1) {
        v1 = rel[i];
        x1 = i;
      }
    }
    final gap = (n * 0.08).round().clamp(3, n);
    var x2 = -1;
    var v2 = -1.0;
    for (var i = 0; i < n; i++) {
      if ((i - x1).abs() < gap) continue;
      if (rel[i] > v2) {
        v2 = rel[i];
        x2 = i;
      }
    }
    final has2 = x2 >= 0 && v2 > 0;
    final leftV = has2 ? (x1 < x2 ? v1 : v2) : v1;
    final rightV = has2 ? (x1 < x2 ? v2 : v1) : 0.0;
    return (cVal: leftV, tVal: rightV, maxV: v1);
  }

  // 가로 스트립(세로선) → 열 프로파일 / 세로 스트립(가로선) → 행 프로파일.
  final colDark = List<double>.filled(sw, 0);
  final rowDark = List<double>.filled(sh, 0);
  for (var cy = 0; cy < sh; cy++) {
    for (var cx = 0; cx < sw; cx++) {
      final px = small.getPixel(cx, cy);
      final dark = 255 - (0.299 * px.r + 0.587 * px.g + 0.114 * px.b);
      colDark[cx] += dark / sh;
      rowDark[cy] += dark / sw;
    }
  }
  final byCol = twoLines(colDark);
  final byRow = twoLines(rowDark);
  // 두 번째 선이 더 뚜렷한 축(스트립 방향)을 선택.
  final r = byCol.tVal >= byRow.tVal ? byCol : byRow;
  final cVal = r.cVal; // 컨트롤(첫 선)
  final tVal = r.tVal; // 테스트(둘째 선)

  const minControl = 8.0; // 컨트롤선 최소 진하기
  String suggested;
  double ratio = 0; // T/C
  if (cVal < minControl) {
    suggested = 'unknown'; // 선이 거의 안 보임 → 판독 불가
  } else {
    final minSecond = (0.1 * cVal).clamp(4.0, 1e9);
    if (tVal < minSecond) {
      suggested = 'negative'; // 컨트롤선만 → 음성
      ratio = 0;
    } else {
      ratio = (tVal / cVal).toDouble();
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

/// T/C 비율을 0~10 점수로 변환 (LH 진하기 지표).
double scoreFromRatio(double ratio) => (ratio.clamp(0.0, 1.0) * 10);

/// 점수 구간별 색 (참고 앱과 동일한 의미).
Color scoreColor(double score) {
  if (score >= 9.0) return const Color(0xFF43A047); // 진한 초록
  if (score >= 5.0) return const Color(0xFFA5D6A7); // 연한 초록
  return const Color(0xFF90CAF9); // 연한 파랑
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
