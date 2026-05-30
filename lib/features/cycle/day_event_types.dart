import 'package:flutter/material.dart';

/// 캘린더에 표시되는 기록 종류 메타데이터.
class EventTypeMeta {
  const EventTypeMeta({
    required this.key,
    required this.label,
    required this.icon,
    required this.color,
    this.titleHint,
  });

  final String key;
  final String label;
  final IconData icon;
  final Color color;
  final String? titleHint;
}

/// DayEvents 테이블에 저장되는 종류들. (생리는 CycleLogs로 별도 관리)
/// 배란은 주기로 자동 계산·표시되므로 수동 기록 종류에서 제외한다.
const Map<String, EventTypeMeta> kEventTypes = {
  'love': EventTypeMeta(
    key: 'love',
    label: '사랑',
    icon: Icons.favorite,
    color: Color(0xFFF06292),
    titleHint: '메모 (선택)',
  ),
  'medication': EventTypeMeta(
    key: 'medication',
    label: '약 복용',
    icon: Icons.medication,
    color: Color(0xFFBA68C8),
    titleHint: '약 이름 (예: 엽산)',
  ),
  'injection': EventTypeMeta(
    key: 'injection',
    label: '주사',
    icon: Icons.vaccines,
    color: Color(0xFF4DB6AC),
    titleHint: '주사 종류 (예: 배란유도주사)',
  ),
  'hospital': EventTypeMeta(
    key: 'hospital',
    label: '병원',
    icon: Icons.local_hospital,
    color: Color(0xFF7986CB),
    titleHint: '진료 내용 (예: 산부인과 진료)',
  ),
  'pregnancy': EventTypeMeta(
    key: 'pregnancy',
    label: '임신',
    icon: Icons.pregnant_woman,
    color: Color(0xFFF06292),
    titleHint: '임신 관련 메모 (예: 임신 확인)',
  ),
};

/// 피임약(한 판) 종류. + 메뉴/범례에서는 별도로 다루므로 kEventTypes에 넣지 않고
/// 렌더링용으로만 제공한다. 캘린더에는 정 번호(1,2,…)로 표시한다.
const EventTypeMeta pillMeta = EventTypeMeta(
  key: 'pill',
  label: '피임약',
  icon: Icons.medication_liquid,
  color: Color(0xFF9575CD),
);

/// 시간 입력이 의미 있는 종류 (약 복용·주사).
bool typeUsesTime(String key) => key == 'medication' || key == 'injection';

EventTypeMeta? eventMeta(String key) =>
    kEventTypes[key] ?? (key == 'pill' ? pillMeta : null);
