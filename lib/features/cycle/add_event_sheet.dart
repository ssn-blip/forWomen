import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/db/database.dart';
import '../../core/db/database_provider.dart';
import 'day_event_types.dart';

/// 배란·약복용·주사·병원·임신 등 범용 일자 기록 입력/편집 시트.
/// [existing]이 주어지면 편집 모드.
class AddEventSheet extends ConsumerStatefulWidget {
  const AddEventSheet(
      {super.key, required this.type, this.initialDate, this.existing});

  final String type;
  final DateTime? initialDate;
  final DayEvent? existing;

  static Future<void> show(BuildContext context,
      {required String type, DateTime? initialDate, DayEvent? existing}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => AddEventSheet(
          type: type, initialDate: initialDate, existing: existing),
    );
  }

  @override
  ConsumerState<AddEventSheet> createState() => _State();
}

class _State extends ConsumerState<AddEventSheet> {
  late DateTime _date;
  late TimeOfDay _time;
  final _titleCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();

  bool get _isEditing => widget.existing != null;
  bool get _usesTime => typeUsesTime(widget.type);

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    if (e != null) {
      _date = e.date;
      _time = TimeOfDay.fromDateTime(e.date);
      _titleCtrl.text = e.title ?? '';
      _noteCtrl.text = e.note ?? '';
    } else {
      final base = widget.initialDate ?? DateTime.now();
      _date = base;
      _time = TimeOfDay.now();
    }
  }

  /// 날짜 + (시간 사용 시) 시간을 합친 값.
  DateTime get _combined => _usesTime
      ? DateTime(_date.year, _date.month, _date.day, _time.hour, _time.minute)
      : DateTime(_date.year, _date.month, _date.day);

  @override
  void dispose() {
    _titleCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final db = ref.read(databaseProvider);
    final title = _titleCtrl.text.trim().isEmpty ? null : _titleCtrl.text.trim();
    final note = _noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim();
    final e = widget.existing;
    if (e != null) {
      await db.updateDayEvent(
          e.copyWith(date: _combined, title: Value(title), note: Value(note)));
    } else {
      await db.insertDayEvent(DayEventsCompanion(
        date: Value(_combined),
        type: Value(widget.type),
        title: Value(title),
        note: Value(note),
      ));
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final meta = eventMeta(widget.type)!;
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
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(meta.icon, color: meta.color),
                const SizedBox(width: 8),
                Text('${meta.label} 기록${_isEditing ? ' 수정' : ''}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.calendar_today, color: meta.color),
            title: const Text('날짜'),
            trailing: Text(DateFormat('yyyy.MM.dd (E)', 'ko').format(_date)),
            onTap: () async {
              final p = await showDatePicker(
                context: context,
                initialDate: _date,
                firstDate: DateTime(2015),
                lastDate: DateTime(2100),
              );
              if (p != null) setState(() => _date = p);
            },
          ),
          if (_usesTime)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.access_time, color: meta.color),
              title: const Text('시간'),
              trailing: Text(_time.format(context)),
              onTap: () async {
                final p =
                    await showTimePicker(context: context, initialTime: _time);
                if (p != null) setState(() => _time = p);
              },
            ),
          const SizedBox(height: 8),
          TextField(
            controller: _titleCtrl,
            decoration: InputDecoration(labelText: meta.titleHint ?? '제목'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _noteCtrl,
            decoration: const InputDecoration(labelText: '메모 (선택)'),
            maxLines: 2,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _save,
              style: FilledButton.styleFrom(backgroundColor: meta.color),
              child: const Text('저장'),
            ),
          ),
        ],
      ),
    );
  }
}
