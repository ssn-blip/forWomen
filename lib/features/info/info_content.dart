/// 시기별 정보 콘텐츠 (참고용). 의료 자문을 대체하지 않는다.
class InfoArticle {
  const InfoArticle({
    required this.category,
    required this.title,
    required this.body,
  });

  /// 'conception'(임신준비) | 'pregnancy'(임신) | 'parenting'(육아)
  final String category;
  final String title;
  final String body;
}

const List<InfoArticle> kInfoArticles = [
  // ── 임신 준비 ──────────────────────────────────────────────────────
  InfoArticle(
    category: 'conception',
    title: '엽산, 임신 전부터 챙기기',
    body: '임신 계획이 있다면 최소 1개월 전부터 엽산(하루 400~600μg)을 복용하는 것이 '
        '태아의 신경관 결손 예방에 도움이 됩니다. 알림 기능으로 매일 복용을 챙겨보세요.',
  ),
  InfoArticle(
    category: 'conception',
    title: '가임기와 배란일 이해하기',
    body: '배란일은 다음 생리 예정일 약 14일 전입니다. 정자 생존 기간을 고려하면 '
        '배란일 5일 전부터 배란 당일까지가 임신 가능성이 높은 시기예요. '
        '주기 기록과 기초체온, 배란테스트를 함께 활용하면 더 정확합니다.',
  ),
  InfoArticle(
    category: 'conception',
    title: '기초체온으로 배란 확인',
    body: '매일 같은 시간(기상 직후, 활동 전)에 체온을 측정하세요. 배란 후에는 체온이 '
        '약 0.3~0.5℃ 상승해 고온기가 유지됩니다. 2주기 이상 기록하면 패턴이 보입니다.',
  ),

  // ── 임신 ───────────────────────────────────────────────────────────
  InfoArticle(
    category: 'pregnancy',
    title: '1분기(1~13주): 안정이 중요한 시기',
    body: '입덧과 피로가 흔합니다. 무리하지 말고 충분히 쉬세요. 초기 산전검사와 '
        '엽산 복용을 이어가고, 카페인·음주·흡연은 피합니다.',
  ),
  InfoArticle(
    category: 'pregnancy',
    title: '2분기(14~27주): 안정기',
    body: '입덧이 줄고 태동을 느끼기 시작합니다. 정밀 초음파(20주 전후)로 태아 상태를 '
        '확인하세요. 적절한 체중 증가와 균형 잡힌 식사가 중요합니다.',
  ),
  InfoArticle(
    category: 'pregnancy',
    title: '3분기(28주~): 출산 준비',
    body: '배가 커지며 요통·부종이 생길 수 있어요. 태동 횟수를 체크하고, '
        '진통의 징후(규칙적 수축, 이슬, 양수)를 알아두세요. 출산 가방을 미리 준비합니다.',
  ),
  InfoArticle(
    category: 'pregnancy',
    title: '산전 검진 일정 챙기기',
    body: '임신 주수에 따라 검진 간격이 달라집니다(초기 4주 → 후기 1~2주). '
        '알림 기능으로 검진 일정을 등록해 놓치지 마세요.',
  ),

  // ── 육아 ───────────────────────────────────────────────────────────
  InfoArticle(
    category: 'parenting',
    title: '신생아 수유 리듬',
    body: '신생아는 보통 2~3시간 간격으로 하루 8~12회 수유합니다. 수유 기록으로 '
        '간격과 양을 파악하면 아기의 리듬을 이해하는 데 도움이 됩니다.',
  ),
  InfoArticle(
    category: 'parenting',
    title: '기저귀와 건강 신호',
    body: '하루 소변 6회 이상이면 수분 섭취가 충분하다는 신호입니다. '
        '대변 색·횟수의 급격한 변화는 기록해 두고 필요시 진료를 받으세요.',
  ),
  InfoArticle(
    category: 'parenting',
    title: '예방접종, 일정대로',
    body: '국가예방접종 일정에 맞춰 접종하면 감염병을 예방할 수 있어요. '
        '육아 화면의 예방접종 체크리스트로 완료 여부를 관리하세요.',
  ),
];

List<InfoArticle> articlesByCategory(String category) =>
    kInfoArticles.where((a) => a.category == category).toList();
