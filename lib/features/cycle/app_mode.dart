import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/auth_controller.dart';

/// 앱 사용 모드. 홈·강조점이 모드에 맞춰 달라진다.
enum AppMode {
  period('period', '생리·피임', Icons.water_drop,
      '생리·피임 중심 모드예요.\n\n· 홈에서 「다음 생리까지 D-day」와 생리 예정일을 먼저 보여줘요.\n· 배란·가임기보다 생리 주기에 초점을 맞춰요.'),
  conception('conception', '임신준비', Icons.calendar_today,
      '임신 준비 중심 모드예요.\n\n· 홈에서 「배란·가임기」를 강조해서 보여줘요.\n· 바로가기에서 「테스트(임신·배란)」를 앞쪽에 배치해요.'),
  pregnancy('pregnancy', '임신', Icons.pregnant_woman,
      '임신 중심 모드예요.\n\n· 홈에서 「임신 N주 · 출산까지 D-day」를 보여줘요.\n· 바로가기에서 「임신·초음파」를 앞쪽에 배치해요.\n· 임신 등록이 안 돼 있으면 등록을 안내해요.');

  const AppMode(this.key, this.label, this.icon, this.description);
  final String key;
  final String label;
  final IconData icon;

  /// 모드 변경 시 보여줄 설명.
  final String description;

  static AppMode fromKey(String? k) =>
      AppMode.values.firstWhere((m) => m.key == k,
          orElse: () => AppMode.conception);
}

class AppModeNotifier extends Notifier<AppMode> {
  static const _key = 'app_mode';

  @override
  AppMode build() {
    final prefs = ref.watch(sharedPrefsProvider);
    return AppMode.fromKey(prefs.getString(_key));
  }

  Future<void> set(AppMode mode) async {
    final prefs = ref.read(sharedPrefsProvider);
    await prefs.setString(_key, mode.key);
    state = mode;
  }
}

final appModeProvider =
    NotifierProvider<AppModeNotifier, AppMode>(AppModeNotifier.new);
