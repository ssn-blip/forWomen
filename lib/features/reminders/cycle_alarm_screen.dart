import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_theme.dart';
import 'cycle_alarm_settings.dart';

/// 주기 기반 자동 알림 설정 화면 (생리예정·배란·가임기·측정 등).
class CycleAlarmScreen extends ConsumerStatefulWidget {
  const CycleAlarmScreen({super.key});

  @override
  ConsumerState<CycleAlarmScreen> createState() => _State();
}

class _State extends ConsumerState<CycleAlarmScreen> {
  @override
  void initState() {
    super.initState();
    // 화면 진입 시 현재 예측 기준으로 재예약.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(cycleAlarmsProvider.notifier).rescheduleAll();
    });
  }

  String _timeLabel(AlarmConfig c) {
    final dt = DateTime(2000, 1, 1, c.hour, c.minute);
    return DateFormat('a h:mm', 'ko').format(dt);
  }

  String _trailing(CycleAlarm a, AlarmConfig c) {
    if (!c.enabled) return 'OFF';
    final time = _timeLabel(c);
    if (!a.usesOffset) return time; // 매일 측정형
    if (a == CycleAlarm.testTiming) return '관계일 +${c.days}일';
    if (a == CycleAlarm.periodLate) return '${c.days}일 후 $time';
    return '${c.days}일 전 $time';
  }

  @override
  Widget build(BuildContext context) {
    final alarms = ref.watch(cycleAlarmsProvider);
    final notifier = ref.read(cycleAlarmsProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('주기 알림 설정')),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Text('캘린더',
                style: TextStyle(
                    color: Colors.grey, fontWeight: FontWeight.bold)),
          ),
          for (final a in CycleAlarm.values)
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppTheme.primary.withValues(alpha: 0.15),
                  child: Icon(a.icon, color: AppTheme.primary, size: 20),
                ),
                title: Text(a.label),
                subtitle: Text(_trailing(a, alarms[a]!),
                    style: TextStyle(
                        color: alarms[a]!.enabled
                            ? AppTheme.primary
                            : Colors.grey)),
                trailing: Switch(
                  value: alarms[a]!.enabled,
                  onChanged: (v) =>
                      notifier.update(a, alarms[a]!.copyWith(enabled: v)),
                ),
                onTap: () => _editDialog(a, alarms[a]!),
              ),
            ),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              '• 생리·배란·가임기 알림은 현재 예측 주기를 기준으로 예약됩니다.\n'
              '• 임신테스트 알림은 가장 최근 사랑(관계) 기록 +N일에 울립니다.\n'
              '• 예측이 없거나 관계 기록이 없으면 해당 알림은 대기합니다.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _editDialog(CycleAlarm a, AlarmConfig c) async {
    int days = c.days;
    TimeOfDay time = TimeOfDay(hour: c.hour, minute: c.minute);

    await showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          title: Text(a.label),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (a.usesOffset)
                Row(
                  children: [
                    Text(a == CycleAlarm.testTiming
                        ? '관계일로부터'
                        : (a == CycleAlarm.periodLate ? '지난 후' : '며칠 전')),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: days > 0
                          ? () => setLocal(() => days--)
                          : null,
                    ),
                    Text('$days일',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () => setLocal(() => days++),
                    ),
                  ],
                ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.access_time),
                title: const Text('시간'),
                trailing: Text(time.format(ctx)),
                onTap: () async {
                  final picked =
                      await showTimePicker(context: ctx, initialTime: time);
                  if (picked != null) setLocal(() => time = picked);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('취소')),
            FilledButton(
              onPressed: () {
                ref.read(cycleAlarmsProvider.notifier).update(
                      a,
                      c.copyWith(
                        enabled: true,
                        days: days,
                        hour: time.hour,
                        minute: time.minute,
                      ),
                    );
                Navigator.pop(ctx);
              },
              child: const Text('저장'),
            ),
          ],
        ),
      ),
    );
  }
}
