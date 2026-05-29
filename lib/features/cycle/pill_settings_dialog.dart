import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/db/database.dart';
import '../../core/db/database_provider.dart';
import '../../core/utils/date_calc.dart';
import 'day_event_types.dart';
import 'pill_settings.dart';

/// 피임약 통합 모달.
/// - [자동 계산]: 시작일·정 수·휴약 기간 → 한 판 자동 생성/재계산
/// - [1정 추가]: 특정 날짜에 1정 추가(2알 복용 등)
/// - 전체 삭제로 한 번에 정리
class PillSettingsDialog extends ConsumerStatefulWidget {
  const PillSettingsDialog({super.key, this.initialDate});

  final DateTime? initialDate;

  static Future<void> show(BuildContext context, {DateTime? initialDate}) {
    return showDialog(
      context: context,
      builder: (_) => PillSettingsDialog(initialDate: initialDate),
    );
  }

  @override
  ConsumerState<PillSettingsDialog> createState() => _State();
}

class _State extends ConsumerState<PillSettingsDialog> {
  String _mode = 'auto'; // 'auto' | 'single'
  late DateTime _date;
  late int _count;
  late int _break;

  @override
  void initState() {
    super.initState();
    final s = ref.read(pillSettingsProvider);
    _date = widget.initialDate ?? s.startDate ?? DateTime.now();
    _count = s.pillCount;
    _break = s.breakDays;
  }

  DateTime get _restStart =>
      DateCalc.dateOnly(_date).add(Duration(days: _count));
  DateTime get _nextPack =>
      DateCalc.dateOnly(_date).add(Duration(days: _count + _break));

  Future<void> _save() async {
    final db = ref.read(databaseProvider);
    if (_mode == 'single') {
      // 1정 추가 (같은 날 두 번이면 2알도 가능).
      await db.insertDayEvent(DayEventsCompanion(
        date: Value(DateCalc.dateOnly(_date)),
        type: const Value('pill'),
      ));
    } else {
      // 자동 계산: 설정 저장 + 한 판 재생성.
      await ref.read(pillSettingsProvider.notifier).save(PillSettings(
            enabled: true,
            startDate: _date,
            pillCount: _count,
            breakDays: _break,
          ));
      await db.deleteEventsOfType('pill');
      for (var i = 0; i < _count; i++) {
        final d = DateCalc.dateOnly(_date).add(Duration(days: i));
        await db.insertDayEvent(DayEventsCompanion(
          date: Value(d),
          type: const Value('pill'),
        ));
      }
    }
    if (mounted) Navigator.pop(context);
  }

  Future<bool> _confirm(String title, String body) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red.shade400),
            child: const Text('삭제'),
          ),
        ],
      ),
    );
    return ok ?? false;
  }

  /// 이번 판(시작일부터 정 수만큼)만 삭제.
  Future<void> _deletePack() async {
    final start = DateCalc.dateOnly(_date);
    final end = start.add(Duration(days: _count - 1));
    if (!await _confirm('이번 판 삭제',
        '${DateFormat('M월 d일', 'ko').format(start)}부터 $_count정만 삭제할까요?')) {
      return;
    }
    await ref.read(databaseProvider).deleteEventsOfTypeInRange('pill', start, end);
    if (mounted) Navigator.pop(context);
  }

  /// 등록된 모든 피임약 기록 삭제.
  Future<void> _deleteAll() async {
    if (!await _confirm('전체 삭제', '등록된 모든 피임약 기록을 삭제할까요?')) return;
    await ref.read(databaseProvider).deleteEventsOfType('pill');
    await ref
        .read(pillSettingsProvider.notifier)
        .save(ref.read(pillSettingsProvider).copyWith(enabled: false));
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('yyyy.MM.dd (E)', 'ko');
    final isAuto = _mode == 'auto';

    return AlertDialog(
      title: Row(
        children: [
          Icon(pillMeta.icon, color: pillMeta.color),
          const SizedBox(width: 8),
          const Text('피임약'),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 모드 선택: 자동 계산 / 1정 추가
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'auto', label: Text('자동 계산')),
                ButtonSegment(value: 'single', label: Text('1정 추가')),
              ],
              selected: {_mode},
              onSelectionChanged: (s) => setState(() => _mode = s.first),
            ),
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.calendar_today, color: pillMeta.color),
              title: Text(isAuto ? '시작일' : '날짜'),
              trailing: Text(fmt.format(_date)),
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
            if (isAuto) ...[
              _Stepper(
                label: '정 수',
                value: _count,
                unit: '정',
                min: 1,
                max: 35,
                onChanged: (v) => setState(() => _count = v),
              ),
              _Stepper(
                label: '휴약 기간',
                value: _break,
                unit: '일',
                min: 0,
                max: 14,
                onChanged: (v) => setState(() => _break = v),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: pillMeta.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '복용: ${fmt.format(_date)}\n'
                  '휴약 시작: ${DateFormat('M월 d일', 'ko').format(_restStart)}'
                  ' ($_break일)\n'
                  '다음 판 시작: ${DateFormat('M월 d일', 'ko').format(_nextPack)}',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                '※ 저장하면 기존 피임약 표시를 지우고 다시 계산합니다.',
                style: TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ] else
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  '선택한 날짜에 피임약 1정을 추가합니다.\n같은 날 두 번 추가하면 2알로 기록돼요.',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            const Divider(height: 16),
            const Text('삭제',
                style: TextStyle(fontSize: 12, color: Colors.grey)),
            Row(
              children: [
                TextButton.icon(
                  onPressed: _deletePack,
                  icon: Icon(Icons.delete_outline, color: Colors.red.shade400),
                  label: Text('이번 판만',
                      style: TextStyle(color: Colors.red.shade400)),
                ),
                TextButton.icon(
                  onPressed: _deleteAll,
                  icon: Icon(Icons.delete_sweep, color: Colors.red.shade700),
                  label: Text('전체 삭제',
                      style: TextStyle(color: Colors.red.shade700)),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('취소'),
        ),
        FilledButton(
          onPressed: _save,
          style: FilledButton.styleFrom(backgroundColor: pillMeta.color),
          child: Text(isAuto ? '저장' : '1정 추가'),
        ),
      ],
    );
  }
}

class _Stepper extends StatelessWidget {
  const _Stepper({
    required this.label,
    required this.value,
    required this.unit,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  final String label;
  final int value;
  final String unit;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(label)),
        IconButton(
          icon: const Icon(Icons.remove_circle_outline),
          onPressed: value > min ? () => onChanged(value - 1) : null,
        ),
        SizedBox(
          width: 52,
          child: Text('$value$unit', textAlign: TextAlign.center),
        ),
        IconButton(
          icon: const Icon(Icons.add_circle_outline),
          onPressed: value < max ? () => onChanged(value + 1) : null,
        ),
      ],
    );
  }
}
