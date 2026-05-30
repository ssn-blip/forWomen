import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/widgets/sheet_header.dart';
import 'reminders_providers.dart';

/// 알림 등록 바텀시트.
class AddReminderSheet extends ConsumerStatefulWidget {
  const AddReminderSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const AddReminderSheet(),
    );
  }

  @override
  ConsumerState<AddReminderSheet> createState() => _State();
}

class _State extends ConsumerState<AddReminderSheet> {
  String _kind = 'medication';
  final _titleCtrl = TextEditingController();
  final _bodyCtrl = TextEditingController();
  DateTime _date = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();
  String _repeat = 'daily';

  static const _kinds = {
    'medication': ('약 복용', Icons.medication),
    'checkup': ('검진', Icons.local_hospital),
    'custom': ('일정', Icons.event),
  };

  @override
  void dispose() {
    _titleCtrl.dispose();
    _bodyCtrl.dispose();
    super.dispose();
  }

  DateTime get _trigger =>
      DateTime(_date.year, _date.month, _date.day, _time.hour, _time.minute);

  Future<void> _save() async {
    if (_titleCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('제목을 입력해 주세요')));
      return;
    }
    var trigger = _trigger;
    // 1회 알림인데 과거 시각이면 다음 날로 보정.
    if (_repeat == 'none' && trigger.isBefore(DateTime.now())) {
      trigger = trigger.add(const Duration(days: 1));
    }
    await ref.read(reminderServiceProvider).add(
          kind: _kind,
          title: _titleCtrl.text.trim(),
          body: _bodyCtrl.text.trim().isEmpty ? null : _bodyCtrl.text.trim(),
          nextTrigger: trigger,
          repeat: _repeat,
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
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SheetHeader(title: '알림 등록'),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: _kinds.entries.map((e) {
                return ChoiceChip(
                  avatar: Icon(e.value.$2, size: 18),
                  label: Text(e.value.$1),
                  selected: _kind == e.key,
                  onSelected: (_) => setState(() => _kind = e.key),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _titleCtrl,
              decoration: const InputDecoration(
                  labelText: '제목', hintText: '예: 엽산 복용, 산부인과 검진'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _bodyCtrl,
              decoration: const InputDecoration(labelText: '메모 (선택)'),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.calendar_today),
                    title: Text(DateFormat('M월 d일', 'ko').format(_date)),
                    onTap: () async {
                      final p = await showDatePicker(
                        context: context,
                        initialDate: _date,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 730)),
                      );
                      if (p != null) setState(() => _date = p);
                    },
                  ),
                ),
                Expanded(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.access_time),
                    title: Text(_time.format(context)),
                    onTap: () async {
                      final p = await showTimePicker(
                          context: context, initialTime: _time);
                      if (p != null) setState(() => _time = p);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text('반복', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'none', label: Text('안함')),
                ButtonSegment(value: 'daily', label: Text('매일')),
                ButtonSegment(value: 'weekly', label: Text('매주')),
              ],
              selected: {_repeat},
              onSelectionChanged: (s) => setState(() => _repeat = s.first),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton(onPressed: _save, child: const Text('알림 등록')),
            ),
          ],
        ),
      ),
    );
  }
}
