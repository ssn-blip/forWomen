import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/auth_controller.dart';
import 'record_kinds.dart';

/// 기록 패널에 "표시할 항목"을 "표시 순서대로" 담은 키 목록.
/// 목록에 없는 종류는 숨김 상태(= 추가 가능). 로컬에 저장한다.
class RecordPanelOrderNotifier extends Notifier<List<String>> {
  static const _key = 'record_panel_order';

  @override
  List<String> build() {
    final prefs = ref.watch(sharedPrefsProvider);
    final saved = prefs.getStringList(_key);
    if (saved == null) return List.of(kDefaultRecordOrder);
    // 저장본 중 유효한 키만 사용(앱 업데이트로 사라진 종류 방어).
    final valid = saved.where((k) => recordKindByKey(k) != null).toList();
    return valid.isEmpty && saved.isEmpty
        ? List.of(kDefaultRecordOrder)
        : valid;
  }

  Future<void> _persist() async {
    await ref.read(sharedPrefsProvider).setStringList(_key, state);
  }

  /// 드래그 재정렬.
  Future<void> reorder(int oldIndex, int newIndex) async {
    final list = List.of(state);
    if (newIndex > oldIndex) newIndex -= 1;
    final item = list.removeAt(oldIndex);
    list.insert(newIndex, item);
    state = list;
    await _persist();
  }

  /// 항목 숨기기(목록에서 제거). 기록 데이터는 지우지 않는다.
  Future<void> hide(String key) async {
    state = state.where((k) => k != key).toList();
    await _persist();
  }

  /// 숨겨진 항목을 다시 추가(맨 끝).
  Future<void> add(String key) async {
    if (state.contains(key) || recordKindByKey(key) == null) return;
    state = [...state, key];
    await _persist();
  }

  /// 기본 순서로 초기화.
  Future<void> reset() async {
    state = List.of(kDefaultRecordOrder);
    await _persist();
  }
}

final recordPanelOrderProvider =
    NotifierProvider<RecordPanelOrderNotifier, List<String>>(
        RecordPanelOrderNotifier.new);
