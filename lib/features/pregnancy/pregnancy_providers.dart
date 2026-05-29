import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/database.dart';
import '../../core/db/database_provider.dart';
import '../../core/utils/date_calc.dart';

/// 현재 진행 중인 임신 (없으면 null).
final activePregnancyProvider = StreamProvider<Pregnancy?>((ref) {
  return ref.watch(databaseProvider).watchActivePregnancy();
});

/// 체중 기록 (날짜 오름차순 — 그래프용).
final weightLogsProvider = StreamProvider<List<WeightLog>>((ref) {
  return ref.watch(databaseProvider).watchWeightLogs();
});

/// 증상 기록 (최신순).
final symptomLogsProvider = StreamProvider<List<SymptomLog>>((ref) {
  return ref.watch(databaseProvider).watchSymptomLogs();
});

/// 임신 진행 상태 요약 (주차·D-day·출산예정일).
class PregnancyStatus {
  const PregnancyStatus({
    required this.week,
    required this.dayOfWeek,
    required this.dueDate,
    required this.dDay,
    required this.trimester,
  });

  final int week;
  final int dayOfWeek;
  final DateTime dueDate;
  final int dDay; // 출산예정일까지 남은 일수
  final int trimester; // 1,2,3 분기

  static PregnancyStatus from(Pregnancy p, DateTime today) {
    final age = DateCalc.gestationalAge(p.lastPeriodStart, today);
    final due = p.dueDateOverride ?? DateCalc.dueDate(p.lastPeriodStart);
    final trimester = age.week < 14 ? 1 : (age.week < 28 ? 2 : 3);
    return PregnancyStatus(
      week: age.week,
      dayOfWeek: age.day,
      dueDate: due,
      dDay: DateCalc.daysBetween(today, due),
      trimester: trimester,
    );
  }
}
