import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/database.dart';
import '../../core/notifications/notification_service.dart';
import '../../core/utils/date_calc.dart';
import '../auth/auth_controller.dart';
import '../cycle/cycle_providers.dart';

/// 주기 기반 자동 알림 프리셋 종류.
enum CycleAlarm {
  periodDue,
  periodLate,
  ovulation,
  fertileStart,
  fertileEnd,
  bbt,
  weight,
  testTiming,
}

/// 알림 계산 방식.
enum _Sched { cycleBefore, cycleAfter, daily, lovePlus }

extension CycleAlarmMeta on CycleAlarm {
  String get label => switch (this) {
        CycleAlarm.periodDue => '생리 예정일',
        CycleAlarm.periodLate => '생리 예정일 지남',
        CycleAlarm.ovulation => '배란 예정일',
        CycleAlarm.fertileStart => '가임기 시작',
        CycleAlarm.fertileEnd => '가임기 종료',
        CycleAlarm.bbt => '기초체온 측정',
        CycleAlarm.weight => '체중 측정',
        CycleAlarm.testTiming => '임신테스트 시기',
      };

  IconData get icon => switch (this) {
        CycleAlarm.periodDue || CycleAlarm.periodLate => Icons.water_drop,
        CycleAlarm.ovulation => Icons.brightness_5,
        CycleAlarm.fertileStart || CycleAlarm.fertileEnd => Icons.eco,
        CycleAlarm.bbt => Icons.thermostat,
        CycleAlarm.weight => Icons.monitor_weight,
        CycleAlarm.testTiming => Icons.science,
      };

  String get body => switch (this) {
        CycleAlarm.periodDue => '곧 생리 예정일이에요.',
        CycleAlarm.periodLate => '생리 예정일이 지났어요. 기록을 확인해 보세요.',
        CycleAlarm.ovulation => '배란 예정일이 다가와요.',
        CycleAlarm.fertileStart => '가임기가 시작돼요.',
        CycleAlarm.fertileEnd => '가임기가 곧 끝나요.',
        CycleAlarm.bbt => '기초체온을 측정해 기록하세요.',
        CycleAlarm.weight => '체중을 측정해 기록하세요.',
        CycleAlarm.testTiming => '임신테스트를 해볼 시기예요(관계일+14일).',
      };

  _Sched get _sched => switch (this) {
        CycleAlarm.periodDue ||
        CycleAlarm.ovulation ||
        CycleAlarm.fertileStart ||
        CycleAlarm.fertileEnd =>
          _Sched.cycleBefore,
        CycleAlarm.periodLate => _Sched.cycleAfter,
        CycleAlarm.bbt || CycleAlarm.weight => _Sched.daily,
        CycleAlarm.testTiming => _Sched.lovePlus,
      };

  /// 매일 측정형이면 일수 조절 없음.
  bool get usesOffset => _sched != _Sched.daily;

  int get defaultDays => switch (this) {
        CycleAlarm.periodDue ||
        CycleAlarm.ovulation ||
        CycleAlarm.fertileStart ||
        CycleAlarm.fertileEnd ||
        CycleAlarm.periodLate =>
          3,
        CycleAlarm.testTiming => 14,
        _ => 0,
      };

  ({int h, int m}) get defaultTime => switch (this) {
        CycleAlarm.ovulation ||
        CycleAlarm.fertileStart ||
        CycleAlarm.fertileEnd =>
          (h: 10, m: 0),
        _ => (h: 9, m: 0),
      };

  int get notifId => 810000 + index;
}

/// 한 알림의 설정값.
class AlarmConfig {
  const AlarmConfig({
    required this.enabled,
    required this.days,
    required this.hour,
    required this.minute,
  });

  final bool enabled;
  final int days;
  final int hour;
  final int minute;

  AlarmConfig copyWith({bool? enabled, int? days, int? hour, int? minute}) =>
      AlarmConfig(
        enabled: enabled ?? this.enabled,
        days: days ?? this.days,
        hour: hour ?? this.hour,
        minute: minute ?? this.minute,
      );
}

class CycleAlarmsNotifier extends Notifier<Map<CycleAlarm, AlarmConfig>> {
  @override
  Map<CycleAlarm, AlarmConfig> build() {
    final prefs = ref.watch(sharedPrefsProvider);
    return {
      for (final a in CycleAlarm.values)
        a: AlarmConfig(
          enabled: prefs.getBool('${_k(a)}_on') ?? false,
          days: prefs.getInt('${_k(a)}_d') ?? a.defaultDays,
          hour: prefs.getInt('${_k(a)}_h') ?? a.defaultTime.h,
          minute: prefs.getInt('${_k(a)}_m') ?? a.defaultTime.m,
        ),
    };
  }

  String _k(CycleAlarm a) => 'cyclealarm_${a.name}';

  Future<void> update(CycleAlarm a, AlarmConfig cfg) async {
    final prefs = ref.read(sharedPrefsProvider);
    await prefs.setBool('${_k(a)}_on', cfg.enabled);
    await prefs.setInt('${_k(a)}_d', cfg.days);
    await prefs.setInt('${_k(a)}_h', cfg.hour);
    await prefs.setInt('${_k(a)}_m', cfg.minute);
    state = {...state, a: cfg};
    await _reschedule(a, cfg);
  }

  /// 현재 예측/기록 기준으로 모든 알림을 다시 예약(화면 진입 시 호출).
  Future<void> rescheduleAll() async {
    for (final entry in state.entries) {
      await _reschedule(entry.key, entry.value);
    }
  }

  Future<void> _reschedule(CycleAlarm a, AlarmConfig cfg) async {
    final notif = ref.read(notificationServiceProvider);
    await notif.cancel(a.notifId);
    if (!cfg.enabled) return;

    final at = _nextTime(a, cfg);
    if (at == null) return;

    await notif.requestPermissions();
    await notif.schedule(
      id: a.notifId,
      title: '⏰ ${a.label}',
      body: a.body,
      at: at,
      repeat: a._sched == _Sched.daily ? 'daily' : 'none',
    );
  }

  /// 다음 알림 시각 계산. 계산 불가(예측/기록 없음)면 null.
  DateTime? _nextTime(CycleAlarm a, AlarmConfig cfg) {
    final now = DateTime.now();
    DateTime atTime(DateTime day) =>
        DateTime(day.year, day.month, day.day, cfg.hour, cfg.minute);

    switch (a._sched) {
      case _Sched.daily:
        var t = atTime(now);
        if (!t.isAfter(now)) t = t.add(const Duration(days: 1));
        return t;

      case _Sched.lovePlus:
        final events =
            ref.read(dayEventsProvider).value ?? const <DayEvent>[];
        final loves = events.where((e) => e.type == 'love').toList()
          ..sort((x, y) => y.date.compareTo(x.date));
        if (loves.isEmpty) return null;
        final t = atTime(loves.first.date.add(Duration(days: cfg.days)));
        return t.isAfter(now) ? t : null;

      case _Sched.cycleBefore:
      case _Sched.cycleAfter:
        final pred = ref.read(cyclePredictionProvider);
        if (pred == null) return null;
        DateTime base = switch (a) {
          CycleAlarm.periodDue || CycleAlarm.periodLate => pred.nextPeriod,
          CycleAlarm.ovulation => pred.ovulation,
          CycleAlarm.fertileStart => pred.fertileStart,
          CycleAlarm.fertileEnd => pred.fertileEnd,
          _ => pred.nextPeriod,
        };
        final sign = a._sched == _Sched.cycleAfter ? 1 : -1;
        var t = atTime(base.add(Duration(days: sign * cfg.days)));
        // 이미 지난 시각이면 다음 주기로 한 번 미룬다.
        if (!t.isAfter(now)) {
          t = atTime(DateCalc.dateOnly(base)
              .add(Duration(days: pred.cycleLength + sign * cfg.days)));
        }
        return t.isAfter(now) ? t : null;
    }
  }
}

final cycleAlarmsProvider =
    NotifierProvider<CycleAlarmsNotifier, Map<CycleAlarm, AlarmConfig>>(
        CycleAlarmsNotifier.new);
