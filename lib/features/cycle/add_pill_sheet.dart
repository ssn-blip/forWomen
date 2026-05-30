import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/db/database.dart';
import '../../core/db/database_provider.dart';
import '../../core/widgets/sheet_header.dart';
import 'day_event_types.dart';

/// 피임약 기록 시트.
/// - 한 판: 시작일 + 정 수(기본 21) → 매일 1정씩 일괄 등록
/// - 1정: 특정 날짜에 1정 추가(같은 날 두 번 누르면 2알도 가능)
/// - [existing]이 주어지면 그 1정의 날짜를 수정/삭제.
class AddPillSheet extends ConsumerStatefulWidget {
  const AddPillSheet({super.key, this.initialDate, this.existing});

  final DateTime? initialDate;
  final DayEvent? existing;

  static Future<void> show(BuildContext context,
      {DateTime? initialDate, DayEvent? existing}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) =>
          AddPillSheet(initialDate: initialDate, existing: existing),
    );
  }

  @override
  ConsumerState<AddPillSheet> createState() => _State();
}

class _State extends ConsumerState<AddPillSheet> {
  bool _pack = true; // true: 한 판, false: 1정
  late DateTime _start;
  int _count = 21;

  bool get _isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    if (widget.existing != null) {
      _pack = false;
      _start = widget.existing!.date;
    } else {
      _start = widget.initialDate ?? DateTime.now();
    }
  }

  DateTime get _end => _start.add(Duration(days: _count - 1));

  Future<void> _save() async {
    final db = ref.read(databaseProvider);
    final e = widget.existing;
    if (e != null) {
      // 기존 1정의 날짜 수정.
      await db.updateDayEvent(
          e.copyWith(date: DateTime(_start.year, _start.month, _start.day)));
    } else if (_pack) {
      // 시작일부터 _count일간 매일 1정씩 등록.
      for (var i = 0; i < _count; i++) {
        final d = _start.add(Duration(days: i));
        await db.insertDayEvent(DayEventsCompanion(
          date: Value(DateTime(d.year, d.month, d.day)),
          type: const Value('pill'),
        ));
      }
    } else {
      await db.insertDayEvent(DayEventsCompanion(
        date: Value(DateTime(_start.year, _start.month, _start.day)),
        type: const Value('pill'),
      ));
    }
    if (mounted) Navigator.pop(context);
  }

  Future<void> _delete() async {
    final e = widget.existing;
    if (e != null) {
      await ref.read(databaseProvider).deleteDayEvent(e.id);
    }
    if (mounted) Navigator.pop(context);
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SheetHeader(
            title: _isEditing ? '피임약 수정' : '피임약 기록',
            icon: pillMeta.icon,
            iconColor: pillMeta.color,
          ),
          const SizedBox(height: 16),
          // 편집 모드에서는 한 판/1정 선택을 숨긴다.
          if (!_isEditing) ...[
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: true, label: Text('한 판 (여러 정)')),
                ButtonSegment(value: false, label: Text('1정 추가')),
              ],
              selected: {_pack},
              onSelectionChanged: (s) => setState(() => _pack = s.first),
            ),
            const SizedBox(height: 8),
          ],
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.calendar_today, color: pillMeta.color),
            title: Text(_pack ? '시작일' : '날짜'),
            trailing: Text(fmt.format(_start)),
            onTap: () async {
              final p = await showDatePicker(
                context: context,
                initialDate: _start,
                firstDate: DateTime(2015),
                lastDate: DateTime(2100),
              );
              if (p != null) setState(() => _start = p);
            },
          ),
          if (_pack) ...[
            Row(
              children: [
                const Expanded(child: Text('정 수')),
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed:
                      _count > 1 ? () => setState(() => _count--) : null,
                ),
                SizedBox(
                  width: 52,
                  child: Text('$_count정', textAlign: TextAlign.center),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed:
                      _count < 35 ? () => setState(() => _count++) : null,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text('종료일: ${fmt.format(_end)} 까지 매일 1정',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
            const SizedBox(height: 4),
            const Text(
              '건너뛴 날은 그 날 기록을 삭제하고, 2알 먹은 날은 "1정 추가"로 더하면 '
              '번호가 자동으로 다시 매겨집니다.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
          const SizedBox(height: 20),
          Row(
            children: [
              if (_isEditing) ...[
                OutlinedButton.icon(
                  onPressed: _delete,
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('삭제'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red.shade400,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: FilledButton(
                  onPressed: _save,
                  style:
                      FilledButton.styleFrom(backgroundColor: pillMeta.color),
                  child: Text(_isEditing
                      ? '날짜 변경'
                      : (_pack ? '$_count정 등록' : '1정 등록')),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
