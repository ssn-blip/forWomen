import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

/// 기록 패널에 표시되는 항목(행) 종류의 메타데이터.
/// 사용자가 순서를 바꾸거나 숨기거나 추가할 수 있는 단위.
class RecordKind {
  const RecordKind(this.key, this.label, this.icon, this.color);

  final String key;
  final String label;
  final IconData icon;
  final Color color;
}

/// 패널에 넣을 수 있는 전체 항목 목록.
const List<RecordKind> kAllRecordKinds = [
  RecordKind('period_start', '생리 시작', Icons.water_drop, AppTheme.period),
  RecordKind(
      'period_end', '생리 종료', Icons.water_drop_outlined, AppTheme.period),
  RecordKind('love', '사랑', Icons.favorite, Color(0xFFF06292)),
  RecordKind('symptom', '증상', Icons.healing, Color(0xFFEF9A9A)),
  RecordKind('preg_test', '임신테스트', Icons.science, Color(0xFFBA68C8)),
  RecordKind('ovu_test', '배란테스트', Icons.science_outlined, Color(0xFF4DB6AC)),
  RecordKind('bbt', '기초체온', Icons.thermostat, Color(0xFFFF8A65)),
  RecordKind('medication', '약 복용', Icons.medication, Color(0xFFBA68C8)),
  RecordKind('injection', '주사', Icons.vaccines, Color(0xFF4DB6AC)),
  RecordKind('hospital', '병원', Icons.local_hospital, Color(0xFF7986CB)),
  RecordKind('pregnancy', '임신', Icons.pregnant_woman, Color(0xFFF06292)),
  RecordKind('pill', '피임약', Icons.medication_liquid, Color(0xFF9575CD)),
  RecordKind('note', '노트', Icons.edit_note, Color(0xFF7E57C2)),
];

RecordKind? recordKindByKey(String key) {
  for (final k in kAllRecordKinds) {
    if (k.key == key) return k;
  }
  return null;
}

/// 기본 표시 순서(사용자가 바꾸기 전).
const List<String> kDefaultRecordOrder = [
  'period_start',
  'period_end',
  'love',
  'medication',
  'bbt',
  'injection',
  'hospital',
  'preg_test',
  'ovu_test',
  'symptom',
  'pill',
  'pregnancy',
  'note',
];
