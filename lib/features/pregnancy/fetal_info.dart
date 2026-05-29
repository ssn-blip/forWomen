/// 임신 주차별 태아 발달 정보 (참고용).
class FetalInfo {
  const FetalInfo({
    required this.week,
    required this.size,
    required this.summary,
  });

  final int week;

  /// 크기 비유 (예: '블루베리')
  final String size;
  final String summary;
}

/// 주차 → 정보. 정의된 주차 중 입력 주차 이하의 가장 가까운 값을 반환한다.
FetalInfo fetalInfoForWeek(int week) {
  FetalInfo best = _data.first;
  for (final info in _data) {
    if (week >= info.week) {
      best = info;
    } else {
      break;
    }
  }
  return best;
}

const List<FetalInfo> _data = [
  FetalInfo(week: 4, size: '양귀비씨', summary: '착상이 일어나는 시기예요. 태반이 형성되기 시작합니다.'),
  FetalInfo(week: 6, size: '완두콩', summary: '심장이 뛰기 시작하고 신경관이 형성돼요.'),
  FetalInfo(week: 8, size: '강낭콩', summary: '팔과 다리가 자라고 주요 장기가 만들어지기 시작합니다.'),
  FetalInfo(week: 10, size: '딸기', summary: '손가락·발가락이 분리되고 태아의 형태를 갖춰가요.'),
  FetalInfo(week: 12, size: '자두', summary: '대부분의 장기가 형성되었고, 안정기에 접어듭니다.'),
  FetalInfo(week: 16, size: '아보카도', summary: '성별 구분이 가능해지고 움직임이 활발해져요.'),
  FetalInfo(week: 20, size: '바나나', summary: '태동을 느낄 수 있고, 정밀 초음파 시기예요.'),
  FetalInfo(week: 24, size: '옥수수', summary: '청각이 발달해 엄마 목소리에 반응해요. 생존 가능 시기에 진입합니다.'),
  FetalInfo(week: 28, size: '가지', summary: '눈을 뜨고 감을 수 있어요. 3분기(후기)가 시작됩니다.'),
  FetalInfo(week: 32, size: '호박', summary: '폐가 성숙해가고 체중이 빠르게 늘어요.'),
  FetalInfo(week: 36, size: '로메인 양상추', summary: '대부분의 발달이 완료되어 출산을 준비합니다.'),
  FetalInfo(week: 40, size: '수박', summary: '출산 예정 시기예요. 언제든 만날 준비가 되었습니다!'),
];
