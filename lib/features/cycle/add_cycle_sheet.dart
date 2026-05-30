import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/db/database.dart';
import '../../core/db/database_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/sheet_header.dart';

/// 생리 기록 입력/편집 바텀시트.
/// [existing]이 주어지면 편집 모드(업데이트), 아니면 추가 모드.
/// [initialDate]는 추가 모드의 시작일 기본값.
class AddCycleSheet extends ConsumerStatefulWidget {
  const AddCycleSheet({super.key, this.initialDate, this.existing});

  final DateTime? initialDate;
  final CycleLog? existing;

  static Future<void> show(BuildContext context,
      {DateTime? initialDate, CycleLog? existing}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) =>
          AddCycleSheet(initialDate: initialDate, existing: existing),
    );
  }

  @override
  ConsumerState<AddCycleSheet> createState() => _AddCycleSheetState();
}

class _AddCycleSheetState extends ConsumerState<AddCycleSheet> {
  late DateTime _start;
  DateTime? _end;
  int _flow = 2;
  final _symptoms = <String>{};
  final _noteCtrl = TextEditingController();

  static const _symptomOptions = [
    '복통',
    '두통',
    '요통',
    '유방통',
    '피로',
    '여드름',
    '식욕변화',
    '감정기복',
  ];

  bool get _isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    if (e != null) {
      _start = e.startDate;
      _end = e.endDate;
      _flow = e.flow ?? 2;
      _noteCtrl.text = e.note ?? '';
      if (e.symptoms != null && e.symptoms!.isNotEmpty) {
        _symptoms.addAll(e.symptoms!.split(','));
      }
    } else {
      _start = widget.initialDate ?? DateTime.now();
    }
  }

  @override
  void dispose() {
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool isStart}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _start : (_end ?? _start),
      firstDate: DateTime(2015),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (picked == null) return;
    setState(() {
      if (isStart) {
        _start = picked;
      } else {
        _end = picked;
      }
    });
  }

  Future<void> _save() async {
    final db = ref.read(databaseProvider);
    final symptoms = _symptoms.isEmpty ? null : _symptoms.join(',');
    final note = _noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim();
    final e = widget.existing;
    if (e != null) {
      await db.updateCycleLog(e.copyWith(
        startDate: _start,
        endDate: Value(_end),
        flow: Value(_flow),
        symptoms: Value(symptoms),
        note: Value(note),
      ));
    } else {
      await db.insertCycleLog(CycleLogsCompanion(
        startDate: Value(_start),
        endDate: Value(_end),
        flow: Value(_flow),
        symptoms: Value(symptoms),
        note: Value(note),
      ));
    }
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('yyyy.MM.dd (E)', 'ko');
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
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SheetHeader(title: _isEditing ? '생리 기록 수정' : '생리 기록'),
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.play_arrow, color: AppTheme.period),
              title: const Text('시작일'),
              trailing: Text(fmt.format(_start)),
              onTap: () => _pickDate(isStart: true),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.stop, color: Colors.grey),
              title: const Text('종료일 (선택사항)'),
              trailing: Text(_end == null ? '미입력' : fmt.format(_end!)),
              onTap: () => _pickDate(isStart: false),
            ),
            const SizedBox(height: 12),
            const Text('출혈량', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 1, label: Text('적음')),
                ButtonSegment(value: 2, label: Text('보통')),
                ButtonSegment(value: 3, label: Text('많음')),
              ],
              selected: {_flow},
              onSelectionChanged: (s) => setState(() => _flow = s.first),
            ),
            const SizedBox(height: 16),
            const Text('증상', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: _symptomOptions.map((s) {
                final selected = _symptoms.contains(s);
                return FilterChip(
                  label: Text(s),
                  selected: selected,
                  onSelected: (v) => setState(() {
                    v ? _symptoms.add(s) : _symptoms.remove(s);
                  }),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _noteCtrl,
              decoration: const InputDecoration(
                labelText: '메모 (선택사항)',
                hintText: '컨디션, 특이사항 등',
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 20),
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
