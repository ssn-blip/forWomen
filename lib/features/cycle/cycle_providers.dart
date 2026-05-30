import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/database.dart';
import '../../core/db/database_provider.dart';
import '../../core/utils/date_calc.dart';
import 'cycle_settings.dart';

/// 모든 생리 기록 (최신순).
final cycleLogsProvider = StreamProvider<List<CycleLog>>((ref) {
  return ref.watch(databaseProvider).watchCycleLogs();
});

/// 캘린더 이벤트(약/주사/병원/임신/피임약) 전체.
final dayEventsProvider = StreamProvider<List<DayEvent>>((ref) {
  return ref.watch(databaseProvider).watchDayEvents();
});

/// 날짜별 증상 태그 기록 전체.
final daySymptomsProvider = StreamProvider<List<DaySymptom>>((ref) {
  return ref.watch(databaseProvider).watchDaySymptoms();
});

/// 날짜별 하루 노트 전체.
final dayNotesProvider = StreamProvider<List<DayNote>>((ref) {
  return ref.watch(databaseProvider).watchDayNotes();
});

/// 피임약(type 'pill') 이벤트에 복용 순서 번호(1,2,…)를 매긴다.
/// 날짜 오름차순(같은 날은 id 순)으로 누적 번호 → eventId : 번호.
/// 건너뛰거나 2알 먹어도 자동으로 다시 번호가 매겨진다.
final pillSequenceProvider = Provider<Map<int, int>>((ref) {
  final events = ref.watch(dayEventsProvider).value ?? const [];
  final pills = events.where((e) => e.type == 'pill').toList()
    ..sort((a, b) {
      final c = a.date.compareTo(b.date);
      return c != 0 ? c : a.id.compareTo(b.id);
    });
  final map = <int, int>{};
  for (var i = 0; i < pills.length; i++) {
    map[pills[i].id] = i + 1;
  }
  return map;
});

/// 주기 예측 결과.
class CyclePrediction {
  const CyclePrediction({
    required this.lastPeriodStart,
    required this.cycleLength,
    required this.nextPeriod,
    required this.ovulation,
    required this.fertileStart,
    required this.fertileEnd,
    required this.isAuto,
  });

  final DateTime lastPeriodStart;
  final int cycleLength;
  final DateTime nextPeriod;
  final DateTime ovulation;
  final DateTime fertileStart;
  final DateTime fertileEnd;

  /// 주기 길이가 기록 기반 자동 계산이면 true, 직접 설정값이면 false.
  final bool isAuto;

  /// 오늘 기준 다음 생리까지 남은 일수.
  int daysUntilNextPeriod(DateTime today) =>
      DateCalc.daysBetween(today, nextPeriod);
}

/// 기록된 생리 시작일들과 설정으로 다음 주기를 예측한다.
/// 기록이 없으면 null.
final cyclePredictionProvider = Provider<CyclePrediction?>((ref) {
  final logs = ref.watch(cycleLogsProvider).value ?? const [];
  if (logs.isEmpty) return null;

  final settings = ref.watch(cycleSettingsProvider);
  final starts = logs.map((e) => e.startDate).toList();

  // 자동 학습이 켜져 있고 기록이 충분하면 자동 평균을, 아니면 직접 설정값을 사용.
  final learned =
      settings.autoLearn ? DateCalc.averageCycleLength(starts) : null;
  final cycleLength = learned ?? settings.avgCycleLength;
  final isAuto = learned != null;

  final lastStart = starts.first; // 최신순 정렬되어 있음
  final fertile = DateCalc.fertileWindow(lastStart, cycleLength);

  return CyclePrediction(
    lastPeriodStart: lastStart,
    cycleLength: cycleLength,
    nextPeriod: DateCalc.nextPeriod(lastStart, cycleLength),
    ovulation: DateCalc.ovulationDay(lastStart, cycleLength),
    fertileStart: fertile.start,
    fertileEnd: fertile.end,
    isAuto: isAuto,
  );
});
