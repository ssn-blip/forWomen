/// 증상 칩 선택용 카탈로그. 카테고리별 증상 태그 목록.
/// (참고 앱의 복부/냉상태/피부/몸상태 구성과 유사하게 구성)
class SymptomCategory {
  const SymptomCategory(this.title, this.items);
  final String title;
  final List<String> items;
}

const List<SymptomCategory> kSymptomCatalog = [
  SymptomCategory('복부', [
    '변비',
    '소화불량',
    '속쓰림',
    '설사',
    '경련',
    '복통',
    '식욕상승',
    '식욕감소',
    '아랫배통증',
    '더부룩함',
    '메스꺼움',
    '복부팽만',
    '가스참',
    '배란통',
  ]),
  SymptomCategory('분비물', [
    '맑음',
    '크림같음',
    '계란흰자',
    '치즈',
    '출혈동반',
    '악취',
    '다량의냉',
    '갈색냉',
  ]),
  SymptomCategory('피부', [
    '건조',
    '여드름',
    '각질',
    '가려움',
    '안면홍조',
    '식은땀',
  ]),
  SymptomCategory('몸 상태', [
    'PMS',
    '가슴통증',
    '가슴붓기',
    '골반통',
    '관절통',
    '어깨결림',
    '근육통',
    '감기',
    '오한',
    '손발저림',
    '허리통증',
    '부종',
    '부정출혈',
    '배란혈',
    '착상혈',
    '두통',
    '어지러움',
    '피로',
    '불면',
  ]),
  SymptomCategory('감정', [
    '우울',
    '예민',
    '불안',
    '의욕저하',
    '눈물',
    '행복',
    '평온',
  ]),
];

/// CSV 문자열 → 태그 목록.
List<String> parseSymptoms(String? csv) =>
    (csv == null || csv.trim().isEmpty)
        ? const []
        : csv.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

/// 태그 목록 → CSV 문자열.
String joinSymptoms(Iterable<String> tags) => tags.join(',');
