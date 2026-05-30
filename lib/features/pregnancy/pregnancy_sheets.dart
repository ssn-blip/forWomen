import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/db/database.dart';
import '../../core/db/database_provider.dart';
import '../../core/widgets/sheet_header.dart';

/// 체중 기록 시트.
class AddWeightSheet extends ConsumerStatefulWidget {
  const AddWeightSheet({super.key});

  static Future<void> show(BuildContext context) => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) => const AddWeightSheet(),
      );

  @override
  ConsumerState<AddWeightSheet> createState() => _WeightState();
}

class _WeightState extends ConsumerState<AddWeightSheet> {
  DateTime _date = DateTime.now();
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final w = double.tryParse(_ctrl.text.trim());
    if (w == null || w < 30 || w > 200) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('올바른 체중을 입력해 주세요')));
      return;
    }
    await ref.read(databaseProvider).insertWeightLog(
          WeightLogsCompanion(date: Value(_date), weightKg: Value(w)),
        );
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SheetHeader(title: '체중 기록'),
          const SizedBox(height: 16),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.calendar_today),
            title: const Text('날짜'),
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
          TextField(
            controller: _ctrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
            ],
            decoration:
                const InputDecoration(labelText: '체중 (kg)', suffixText: 'kg'),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton(onPressed: _save, child: const Text('저장')),
          ),
        ],
      ),
    );
  }
}

/// 증상 기록 시트.
class AddSymptomSheet extends ConsumerStatefulWidget {
  const AddSymptomSheet({super.key});

  static Future<void> show(BuildContext context) => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) => const AddSymptomSheet(),
      );

  @override
  ConsumerState<AddSymptomSheet> createState() => _SymptomState();
}

class _SymptomState extends ConsumerState<AddSymptomSheet> {
  final DateTime _date = DateTime.now();
  final _symptoms = <String>{};
  int _severity = 1;
  final _noteCtrl = TextEditingController();

  static const _options = [
    '입덧',
    '메스꺼움',
    '피로',
    '허리통증',
    '부종',
    '속쓰림',
    '변비',
    '두통',
    '어지러움',
    '가슴통증',
  ];

  @override
  void dispose() {
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_symptoms.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('증상을 하나 이상 선택해 주세요')));
      return;
    }
    await ref.read(databaseProvider).insertSymptomLog(SymptomLogsCompanion(
          date: Value(_date),
          symptoms: Value(_symptoms.join(',')),
          severity: Value(_severity),
          note: Value(
              _noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim()),
        ));
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
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
            const SheetHeader(title: '증상 기록'),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: _options.map((s) {
                return FilterChip(
                  label: Text(s),
                  selected: _symptoms.contains(s),
                  onSelected: (v) => setState(() {
                    v ? _symptoms.add(s) : _symptoms.remove(s);
                  }),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            const Text('강도', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 1, label: Text('약함')),
                ButtonSegment(value: 2, label: Text('보통')),
                ButtonSegment(value: 3, label: Text('심함')),
              ],
              selected: {_severity},
              onSelectionChanged: (s) => setState(() => _severity = s.first),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _noteCtrl,
              decoration: const InputDecoration(labelText: '메모 (선택사항)'),
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
