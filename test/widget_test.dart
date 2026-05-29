import 'package:flutter_test/flutter_test.dart';

import 'package:forwomen/core/utils/date_calc.dart';

void main() {
  group('DateCalc', () {
    final lmp = DateTime(2026, 1, 1); // 마지막 생리 시작일

    test('다음 생리 예정일 = LMP + 주기', () {
      expect(DateCalc.nextPeriod(lmp, 28), DateTime(2026, 1, 29));
    });

    test('배란일 = 다음 생리 - 14일', () {
      expect(DateCalc.ovulationDay(lmp, 28), DateTime(2026, 1, 15));
    });

    test('가임기는 배란 -5 ~ +1일', () {
      final w = DateCalc.fertileWindow(lmp, 28);
      expect(w.start, DateTime(2026, 1, 10));
      expect(w.end, DateTime(2026, 1, 16));
    });

    test('출산 예정일 = LMP + 280일', () {
      expect(DateCalc.dueDate(lmp), DateTime(2026, 10, 8));
    });

    test('임신 주차 계산', () {
      final age = DateCalc.gestationalAge(lmp, DateTime(2026, 2, 26));
      expect(age.week, 8);
      expect(age.day, 0);
    });

    test('평균 주기 계산', () {
      final starts = [
        DateTime(2026, 1, 1),
        DateTime(2026, 1, 29),
        DateTime(2026, 2, 26),
      ];
      expect(DateCalc.averageCycleLength(starts), 28);
    });
  });
}
