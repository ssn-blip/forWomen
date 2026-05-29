import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// 약 복용 알림의 액션 ID.
const String kTakenActionId = 'taken';
const String kSkipActionId = 'skip';

/// 백그라운드(앱 종료/백그라운드)에서 "복용/미복용"을 눌렀을 때 처리되는 핸들러.
/// DB 대신 SharedPreferences 큐에 적재 → 앱 실행 시 일괄 반영한다.
@pragma('vm:entry-point')
void notificationActionBackground(NotificationResponse response) {
  // 백그라운드 아이솔레이트: 플러그인 재등록 후 prefs 접근.
  _queueTakenAction(response);
}

Future<void> _queueTakenAction(NotificationResponse r) async {
  if (r.actionId != kTakenActionId) return;
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final list = prefs.getStringList('pending_taken') ?? <String>[];
  list.add(jsonEncode({
    'title': r.payload,
    'ts': DateTime.now().toIso8601String(),
  }));
  await prefs.setStringList('pending_taken', list);
}

/// 로컬 예약 알림(약 복용·검진·일정)을 담당한다.
class NotificationService {
  NotificationService(this._plugin);

  final FlutterLocalNotificationsPlugin _plugin;
  bool _initialized = false;

  /// 앱이 실행 중일 때 알림 액션을 처리하는 콜백 (main에서 주입).
  void Function(NotificationResponse response)? onForegroundAction;

  static const _channel = AndroidNotificationChannel(
    'reminders',
    '알림',
    description: '약 복용, 검진, 일정 알림',
    importance: Importance.high,
  );

  Future<void> init() async {
    if (_initialized) return;
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Seoul'));

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    await _plugin.initialize(
      settings: const InitializationSettings(android: android, iOS: ios),
      onDidReceiveNotificationResponse: (response) async {
        await _queueTakenAction(response);
        onForegroundAction?.call(response);
      },
      onDidReceiveBackgroundNotificationResponse: notificationActionBackground,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    _initialized = true;
  }

  /// 권한 요청 (Android 13+ / iOS).
  Future<void> requestPermissions() async {
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    await _plugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  /// 약 복용 알림에 붙는 복용/미복용 액션.
  static const List<AndroidNotificationAction> _medActions = [
    AndroidNotificationAction(kTakenActionId, '복용',
        showsUserInterface: false, cancelNotification: true),
    AndroidNotificationAction(kSkipActionId, '미복용',
        showsUserInterface: false, cancelNotification: true),
  ];

  NotificationDetails _details({bool withMedActions = false}) =>
      NotificationDetails(
        android: AndroidNotificationDetails(
          'reminders',
          '알림',
          channelDescription: '약 복용, 검진, 일정 알림',
          importance: Importance.high,
          priority: Priority.high,
          actions: withMedActions ? _medActions : null,
        ),
        iOS: const DarwinNotificationDetails(
          categoryIdentifier: 'medication',
        ),
      );

  /// 특정 시각에 1회 또는 반복 예약.
  /// [repeat]: 'none' | 'daily' | 'weekly'
  /// [withMedActions]가 true면 복용/미복용 버튼을 단다(약 복용 알림).
  /// [payload]는 액션 처리 시 사용할 식별값(약 이름 등).
  Future<void> schedule({
    required int id,
    required String title,
    String? body,
    required DateTime at,
    String repeat = 'none',
    bool withMedActions = false,
    String? payload,
  }) async {
    await init();
    final scheduled = tz.TZDateTime.from(at, tz.local);

    DateTimeComponents? match;
    switch (repeat) {
      case 'daily':
        match = DateTimeComponents.time;
        break;
      case 'weekly':
        match = DateTimeComponents.dayOfWeekAndTime;
        break;
      default:
        match = null;
    }

    await _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduled,
      notificationDetails: _details(withMedActions: withMedActions),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: match,
      payload: payload,
    );
  }

  Future<void> cancel(int id) => _plugin.cancel(id: id);
  Future<void> cancelAll() => _plugin.cancelAll();
}

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService(FlutterLocalNotificationsPlugin());
});
