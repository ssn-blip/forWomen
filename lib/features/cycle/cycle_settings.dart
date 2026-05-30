import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/auth_controller.dart';

/// 사용자 주기 설정(평균 주기·생리 기간·자동 학습 여부). 로컬에 저장한다.
class CycleSettings {
  const CycleSettings({
    this.avgCycleLength = 28,
    this.periodLength = 5,
    this.autoLearn = true,
    this.weekStartsMonday = false,
  });

  final int avgCycleLength;
  final int periodLength;

  /// true면 기록(2회 이상)으로 평균 주기를 자동 계산해 사용,
  /// false면 사용자가 지정한 [avgCycleLength]를 그대로 사용(직접 설정).
  final bool autoLearn;

  /// 달력 주 시작 요일. true면 월요일 시작, false면 일요일 시작.
  final bool weekStartsMonday;

  CycleSettings copyWith({
    int? avgCycleLength,
    int? periodLength,
    bool? autoLearn,
    bool? weekStartsMonday,
  }) =>
      CycleSettings(
        avgCycleLength: avgCycleLength ?? this.avgCycleLength,
        periodLength: periodLength ?? this.periodLength,
        autoLearn: autoLearn ?? this.autoLearn,
        weekStartsMonday: weekStartsMonday ?? this.weekStartsMonday,
      );
}

class CycleSettingsNotifier extends Notifier<CycleSettings> {
  static const _avgKey = 'cycle_avg_length';
  static const _periodKey = 'cycle_period_length';
  static const _autoKey = 'cycle_auto_learn';
  static const _weekKey = 'week_starts_monday';

  @override
  CycleSettings build() {
    final prefs = ref.watch(sharedPrefsProvider);
    return CycleSettings(
      avgCycleLength: prefs.getInt(_avgKey) ?? 28,
      periodLength: prefs.getInt(_periodKey) ?? 5,
      autoLearn: prefs.getBool(_autoKey) ?? true,
      weekStartsMonday: prefs.getBool(_weekKey) ?? false,
    );
  }

  Future<void> update({
    int? avgCycleLength,
    int? periodLength,
    bool? autoLearn,
    bool? weekStartsMonday,
  }) async {
    final prefs = ref.read(sharedPrefsProvider);
    if (avgCycleLength != null) await prefs.setInt(_avgKey, avgCycleLength);
    if (periodLength != null) await prefs.setInt(_periodKey, periodLength);
    if (autoLearn != null) await prefs.setBool(_autoKey, autoLearn);
    if (weekStartsMonday != null) {
      await prefs.setBool(_weekKey, weekStartsMonday);
    }
    state = state.copyWith(
      avgCycleLength: avgCycleLength,
      periodLength: periodLength,
      autoLearn: autoLearn,
      weekStartsMonday: weekStartsMonday,
    );
  }
}

final cycleSettingsProvider =
    NotifierProvider<CycleSettingsNotifier, CycleSettings>(
        CycleSettingsNotifier.new);
