import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/date_calc.dart';
import '../auth/auth_controller.dart';

/// 피임약 복용 설정. 시작일 + 정 수 + 휴약 기간으로 자동 계산한다.
class PillSettings {
  const PillSettings({
    this.enabled = false,
    this.startDate,
    this.pillCount = 21,
    this.breakDays = 7,
  });

  /// 자동 계산(달력 자동 표시) 사용 여부.
  final bool enabled;

  /// 현재 판 복용 시작일.
  final DateTime? startDate;

  /// 한 판 정 수 (보통 21).
  final int pillCount;

  /// 휴약 기간 (보통 7일).
  final int breakDays;

  /// 휴약 시작일 (= 시작일 + 정 수).
  DateTime? get restStart => startDate == null
      ? null
      : DateCalc.dateOnly(startDate!).add(Duration(days: pillCount));

  /// 다음 판 시작일 (= 시작일 + 정 수 + 휴약 기간).
  DateTime? get nextPackStart => startDate == null
      ? null
      : DateCalc.dateOnly(startDate!)
          .add(Duration(days: pillCount + breakDays));

  PillSettings copyWith({
    bool? enabled,
    DateTime? startDate,
    int? pillCount,
    int? breakDays,
  }) =>
      PillSettings(
        enabled: enabled ?? this.enabled,
        startDate: startDate ?? this.startDate,
        pillCount: pillCount ?? this.pillCount,
        breakDays: breakDays ?? this.breakDays,
      );
}

class PillSettingsNotifier extends Notifier<PillSettings> {
  static const _enabledKey = 'pill_enabled';
  static const _startKey = 'pill_start'; // millisSinceEpoch, 없으면 미저장
  static const _countKey = 'pill_count';
  static const _breakKey = 'pill_break';

  @override
  PillSettings build() {
    final prefs = ref.watch(sharedPrefsProvider);
    final startMs = prefs.getInt(_startKey);
    return PillSettings(
      enabled: prefs.getBool(_enabledKey) ?? false,
      startDate:
          startMs == null ? null : DateTime.fromMillisecondsSinceEpoch(startMs),
      pillCount: prefs.getInt(_countKey) ?? 21,
      breakDays: prefs.getInt(_breakKey) ?? 7,
    );
  }

  Future<void> save(PillSettings s) async {
    final prefs = ref.read(sharedPrefsProvider);
    await prefs.setBool(_enabledKey, s.enabled);
    await prefs.setInt(_countKey, s.pillCount);
    await prefs.setInt(_breakKey, s.breakDays);
    if (s.startDate != null) {
      await prefs.setInt(_startKey, s.startDate!.millisecondsSinceEpoch);
    }
    state = s;
  }
}

final pillSettingsProvider =
    NotifierProvider<PillSettingsNotifier, PillSettings>(
        PillSettingsNotifier.new);
