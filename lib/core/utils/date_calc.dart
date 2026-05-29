/// 주기·임신 관련 날짜 계산을 한곳에 모은 순수 함수 모음.
///
/// 모든 함수는 부수효과가 없어 단위 테스트가 쉽다. UI/DB에 의존하지 않는다.
class DateCalc {
  DateCalc._();

  /// 평균 황체기(배란 후 다음 생리까지) 일수. 통상 14일로 본다.
  static const int lutealPhase = 14;

  /// 표준 임신 기간(일). 마지막 생리 시작일 기준 280일(40주).
  static const int gestationDays = 280;

  /// 시각 정보를 버리고 날짜만 남긴다(자정 기준).
  static DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  /// 두 날짜 사이의 일수(b - a). 시각은 무시한다.
  static int daysBetween(DateTime a, DateTime b) {
    return dateOnly(b).difference(dateOnly(a)).inDays;
  }

  /// 마지막 생리 시작일과 평균 주기로 다음 생리 예정일을 계산.
  static DateTime nextPeriod(DateTime lastPeriodStart, int cycleLength) {
    return dateOnly(lastPeriodStart).add(Duration(days: cycleLength));
  }

  /// 배란 예정일 = 다음 생리 예정일 - 황체기(14일).
  static DateTime ovulationDay(DateTime lastPeriodStart, int cycleLength) {
    return nextPeriod(lastPeriodStart, cycleLength)
        .subtract(const Duration(days: lutealPhase));
  }

  /// 가임기: 배란일 기준 -5일 ~ +1일 (정자 생존·난자 수명 고려).
  static ({DateTime start, DateTime end}) fertileWindow(
      DateTime lastPeriodStart, int cycleLength) {
    final ov = ovulationDay(lastPeriodStart, cycleLength);
    return (
      start: ov.subtract(const Duration(days: 5)),
      end: ov.add(const Duration(days: 1)),
    );
  }

  /// 출산 예정일(EDD) = 마지막 생리 시작일 + 280일 (네겔레 법칙).
  static DateTime dueDate(DateTime lastPeriodStart) {
    return dateOnly(lastPeriodStart).add(const Duration(days: gestationDays));
  }

  /// 특정 날짜 기준 임신 주차/일수. (week, dayOfWeek 0~6)
  /// 예: 8주 3일 → (week: 8, day: 3)
  static ({int week, int day}) gestationalAge(
      DateTime lastPeriodStart, DateTime on) {
    final total = daysBetween(lastPeriodStart, on).clamp(0, 320);
    return (week: total ~/ 7, day: total % 7);
  }

  /// 출산 예정일까지 남은 D-day (양수=남음, 음수=초과).
  static int dDayToDue(DateTime lastPeriodStart, DateTime on) {
    return daysBetween(on, dueDate(lastPeriodStart));
  }

  /// 평균 주기 길이 계산: 연속된 생리 시작일들의 간격 평균.
  /// 기록이 2개 미만이면 null.
  static int? averageCycleLength(List<DateTime> periodStartsDesc) {
    final starts = [...periodStartsDesc]..sort((a, b) => b.compareTo(a));
    if (starts.length < 2) return null;
    var sum = 0;
    var count = 0;
    for (var i = 0; i < starts.length - 1; i++) {
      final gap = daysBetween(starts[i + 1], starts[i]);
      // 비정상적으로 짧거나 긴 간격은 평균에서 제외(15~60일만 사용).
      if (gap >= 15 && gap <= 60) {
        sum += gap;
        count++;
      }
    }
    if (count == 0) return null;
    return (sum / count).round();
  }
}
