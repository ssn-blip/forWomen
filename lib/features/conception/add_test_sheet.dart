import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../core/db/database.dart';
import '../../core/db/database_provider.dart';
import '../../core/utils/image_storage.dart';
import '../../core/widgets/sheet_header.dart';
import 'strip_analyzer.dart';

/// 임테기/배란테스트 기록 입력 시트. 사진 첨부 가능.
class AddTestSheet extends ConsumerStatefulWidget {
  const AddTestSheet({super.key, required this.kind});

  /// 'pregnancy' | 'ovulation'
  final String kind;

  static Future<void> show(BuildContext context, {required String kind}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => AddTestSheet(kind: kind),
    );
  }

  @override
  ConsumerState<AddTestSheet> createState() => _State();
}

class _State extends ConsumerState<AddTestSheet> {
  DateTime _date = DateTime.now();
  String _result = 'unknown';
  String? _photoPath;
  double? _ratio; // 자동 분석 T/C 비율
  bool _autoAnalyzed = false;
  final _noteCtrl = TextEditingController();
  final _picker = ImagePicker();

  @override
  void dispose() {
    _noteCtrl.dispose();
    super.dispose();
  }

  bool get _isPregnancy => widget.kind == 'pregnancy';

  Future<void> _pickPhoto(ImageSource source) async {
    final picked = await _picker.pickImage(source: source, maxWidth: 1600);
    if (picked == null || !mounted) return;

    // 크롭·자동 분석 화면으로 이동.
    final analysis = await Navigator.of(context).push<StripAnalysis>(
      MaterialPageRoute(
        builder: (_) => TestStripCropScreen(srcPath: picked.path),
      ),
    );

    if (analysis != null) {
      setState(() {
        _photoPath = analysis.croppedPath;
        _ratio = analysis.ratio;
        _result = analysis.suggested;
        _autoAnalyzed = true;
      });
    } else {
      // 분석을 건너뛰면 원본 사진만 첨부.
      final saved = await ImageStorage.persist(picked.path, subdir: 'tests');
      if (mounted) {
        setState(() {
          _photoPath = saved;
          _autoAnalyzed = false;
        });
      }
    }
  }

  Future<void> _save() async {
    // 사진·결과·메모가 모두 비어 있으면(=판독 불가 기본값 그대로) 저장하지 않는다.
    final hasNote = _noteCtrl.text.trim().isNotEmpty;
    if (_photoPath == null && _result == 'unknown' && !hasNote) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('사진을 첨부하거나 결과를 선택해 주세요')),
      );
      return;
    }
    await ref.read(databaseProvider).insertTestLog(TestLogsCompanion(
          date: Value(_date),
          kind: Value(widget.kind),
          result: Value(_result),
          photoPath: Value(_photoPath),
          ratio: Value(_ratio),
          note: Value(
              _noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim()),
        ));
    if (mounted) Navigator.pop(context);
  }

  String _resultLabel(String key) => switch (key) {
        'positive' => '양성',
        'faint' => '희미한 양성',
        'negative' => '음성',
        _ => '판독 불가',
      };

  /// 결과를 직접 수정(오판 보정).
  Future<void> _pickResult(Map<String, String> results) async {
    final picked = await showModalBottomSheet<String>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(12),
              child: Text('결과 직접 선택',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            ...results.entries.map((e) => ListTile(
                  title: Text(e.value),
                  trailing: _result == e.key
                      ? const Icon(Icons.check, color: Colors.purple)
                      : null,
                  onTap: () => Navigator.pop(context, e.key),
                )),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
    if (picked != null) setState(() => _result = picked);
  }

  @override
  Widget build(BuildContext context) {
    final results = _isPregnancy
        ? const {
            'positive': '양성 (임신 가능성)',
            'faint': '희미한 양성',
            'negative': '음성',
            'unknown': '판독 불가',
          }
        : const {
            'positive': '양성 (배란 임박)',
            'faint': '희미함',
            'negative': '음성',
            'unknown': '판독 불가',
          };

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SheetHeader(title: _isPregnancy ? '임신테스트 기록' : '배란테스트 기록'),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today),
              title: const Text('검사일'),
              trailing: Text(DateFormat('yyyy.MM.dd', 'ko').format(_date)),
              onTap: () async {
                final p = await showDatePicker(
                  context: context,
                  initialDate: _date,
                  firstDate: DateTime(2015),
                  lastDate: DateTime.now(),
                );
                if (p != null) setState(() => _date = p);
              },
            ),
            const SizedBox(height: 8),
            if (_autoAnalyzed)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.purple.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.auto_awesome,
                            size: 18, color: Colors.purple),
                        const SizedBox(width: 6),
                        Text('자동 추정: ${_resultLabel(_result)}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold)),
                        const Spacer(),
                        if ((_ratio ?? 0) > 0)
                          Text('수치 ${scoreFromRatio(_ratio ?? 0).toStringAsFixed(1)}/10',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purple)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text('참고용 추정입니다. 결과가 자동 설정됐어요(필요 시 수정).',
                        style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
            // 결과(사진 분석으로 자동 설정, 필요 시 수정)
            Row(
              children: [
                const Text('결과', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.purple.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(results[_result] ?? _resultLabel(_result),
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () => _pickResult(results),
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text('수정'),
                ),
              ],
            ),
            if (!_autoAnalyzed)
              const Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Text('사진을 첨부하면 결과가 자동 분석돼요.',
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
              ),
            const SizedBox(height: 8),
            // 사진 첨부
            if (_photoPath != null)
              Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.file(File(_photoPath!), fit: BoxFit.contain),
              ),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _pickPhoto(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('촬영'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _pickPhoto(ImageSource.gallery),
                    icon: const Icon(Icons.photo),
                    label: const Text('갤러리'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _noteCtrl,
              decoration: const InputDecoration(labelText: '메모 (선택)'),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                '⚠️ 테스트 결과는 참고용입니다. 정확한 진단은 의료기관 검사를 받으세요.',
                style: TextStyle(fontSize: 12),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(onPressed: _save, child: const Text('저장')),
            ),
          ],
        ),
      ),
    );
  }
}
