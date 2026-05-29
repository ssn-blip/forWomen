import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/notifications/notification_service.dart';
import 'features/auth/auth_controller.dart';
import 'features/reminders/reminders_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 한국어 날짜 포맷/캘린더 로케일 데이터 초기화.
  // 'ko'와 'ko_KR' 둘 다 로드해 DateFormat(..., 'ko') 호출에서 예외가 없도록 한다.
  await initializeDateFormatting('ko', null);
  await initializeDateFormatting('ko_KR', null);
  Intl.defaultLocale = 'ko_KR';

  final prefs = await SharedPreferences.getInstance();

  final container = ProviderContainer(
    overrides: [
      sharedPrefsProvider.overrideWithValue(prefs),
    ],
  );

  // 알림 채널 초기화 (권한 요청은 알림 등록 시점에 수행).
  final notifications = container.read(notificationServiceProvider);
  // 앱 실행 중 "복용/미복용" 버튼을 누르면 즉시 주기에 반영.
  notifications.onForegroundAction = (response) {
    if (response.actionId == kTakenActionId) {
      container
          .read(reminderServiceProvider)
          .recordTaken(response.payload);
    }
  };
  await notifications.init();

  // 백그라운드에서 눌렀던 "복용" 액션들을 주기에 반영.
  await container.read(reminderServiceProvider).processPendingTaken();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MomCareApp(),
    ),
  );
}
