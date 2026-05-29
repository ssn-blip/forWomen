/// 표준 영유아 예방접종 항목 (대한민국 국가예방접종 기준, 참고용).
class Vaccine {
  const Vaccine({required this.name, required this.ageLabel});

  final String name;

  /// 권장 접종 시기 라벨
  final String ageLabel;
}

const List<Vaccine> kVaccineSchedule = [
  Vaccine(name: 'B형간염 1차', ageLabel: '출생 직후'),
  Vaccine(name: 'BCG (결핵)', ageLabel: '생후 4주 이내'),
  Vaccine(name: 'B형간염 2차', ageLabel: '생후 1개월'),
  Vaccine(name: 'DTaP 1차', ageLabel: '생후 2개월'),
  Vaccine(name: '폴리오 1차', ageLabel: '생후 2개월'),
  Vaccine(name: 'Hib 1차', ageLabel: '생후 2개월'),
  Vaccine(name: '폐렴구균 1차', ageLabel: '생후 2개월'),
  Vaccine(name: '로타바이러스 1차', ageLabel: '생후 2개월'),
  Vaccine(name: 'DTaP 2차', ageLabel: '생후 4개월'),
  Vaccine(name: '폴리오 2차', ageLabel: '생후 4개월'),
  Vaccine(name: 'DTaP 3차', ageLabel: '생후 6개월'),
  Vaccine(name: 'B형간염 3차', ageLabel: '생후 6개월'),
  Vaccine(name: '인플루엔자', ageLabel: '생후 6개월~'),
  Vaccine(name: 'MMR 1차', ageLabel: '생후 12~15개월'),
  Vaccine(name: '수두', ageLabel: '생후 12~15개월'),
  Vaccine(name: '일본뇌염 1차', ageLabel: '생후 12~23개월'),
  Vaccine(name: 'A형간염 1차', ageLabel: '생후 12~23개월'),
];
