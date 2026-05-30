import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_mode.dart';

/// 현재 앱 모드가 [target]이 아니면 모드 변경 안내 팝업을 띄우고,
/// 사용자가 동의하면 모드를 [target]으로 바꾼다.
///
/// 임신 등록·초음파 추가처럼 "기록이 특정 모드를 가리키는데 모드는 아직
/// 그대로일 때" 자연스럽게 모드 전환을 권유하는 용도.
Future<void> promptSwitchMode(
  BuildContext context,
  WidgetRef ref,
  AppMode target, {
  required String message,
}) async {
  if (ref.read(appModeProvider) == target) return;
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text('${target.label} 모드로 변경할까요?'),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('나중에'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text('변경'),
        ),
      ],
    ),
  );
  if (ok == true) {
    await ref.read(appModeProvider.notifier).set(target);
  }
}
