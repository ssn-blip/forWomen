import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/auth_controller.dart';

/// 앱 사용 모드. 홈·강조점이 모드에 맞춰 달라진다.
enum AppMode {
  period('period', '생리·피임', Icons.water_drop),
  conception('conception', '임신준비', Icons.calendar_today),
  pregnancy('pregnancy', '임신', Icons.pregnant_woman);

  const AppMode(this.key, this.label, this.icon);
  final String key;
  final String label;
  final IconData icon;

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
