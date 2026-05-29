import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/db/database.dart';
import '../../core/db/database_provider.dart';
import '../../core/notifications/notification_service.dart';

/// 등록된 모든 알림 (다음 알림 시각 오름차순).
final remindersProvider = StreamProvider<List<Reminder>>((ref) {
  return ref.watch(databaseProvider).watchReminders();
});

/// 알림 등록/수정/삭제와 OS 예약, 그리고 "복용" 액션의 주기 반영을 처리한다.
class ReminderService {
  ReminderService(this._db, this._notifications);

  final AppDatabase _db;
  final NotificationService _notifications;

  Future<void> add({
    required String kind,
    required String title,
    String? body,
    required DateTime nextTrigger,
    String repeat = 'none',
  }) async {
    await _notifications.requestPermissions();
    final id = await _db.insertReminder(RemindersCompanion(
      kind: Value(kind),
      title: Value(title),
      body: Value(body),
      nextTrigger: Value(nextTrigger),
      repeat: Value(repeat),
    ));
    await _schedule(id, kind, title, body, nextTrigger, repeat);
  }

  Future<void> setEnabled(Reminder reminder, bool enabled) async {
    await _db.updateReminder(reminder.copyWith(enabled: enabled));
    if (enabled) {
      await _notifications.requestPermissions();
      await _schedule(reminder.id, reminder.kind, reminder.title,
          reminder.body, reminder.nextTrigger, reminder.repeat);
    } else {
      await _notifications.cancel(reminder.id);
    }
  }

  Future<void> _schedule(int id, String kind, String title, String? body,
      DateTime at, String repeat) {
    final isMed = kind == 'medication';
    return _notifications.schedule(
      id: id,
      title: title,
      body: body,
      at: at,
      repeat: repeat,
      // 약 복용 알림에는 복용/미복용 버튼을 단다.
      withMedActions: isMed,
      payload: isMed ? title : null,
    );
  }

  Future<void> delete(Reminder reminder) async {
    await _notifications.cancel(reminder.id);
    await _db.deleteReminder(reminder.id);
  }

  /// "복용" 버튼이 눌렸을 때 약 복용 기록을 주기(캘린더)에 즉시 추가한다.
  Future<void> recordTaken(String? medName, {DateTime? at}) async {
    await _db.insertDayEvent(DayEventsCompanion(
      date: Value(at ?? DateTime.now()),
      type: const Value('medication'),
      title: Value(medName),
    ));
  }

  /// 백그라운드에서 적재된 "복용" 액션들을 읽어 주기에 반영하고 큐를 비운다.
  Future<void> processPendingTaken() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('pending_taken') ?? const [];
    if (list.isEmpty) return;
    for (final raw in list) {
      try {
        final m = jsonDecode(raw) as Map<String, dynamic>;
        final ts = DateTime.tryParse(m['ts'] as String? ?? '');
        await recordTaken(m['title'] as String?, at: ts);
      } catch (_) {
        // 손상된 항목은 무시.
      }
    }
    await prefs.remove('pending_taken');
  }
}

final reminderServiceProvider = Provider<ReminderService>((ref) {
  return ReminderService(
    ref.watch(databaseProvider),
    ref.watch(notificationServiceProvider),
  );
});
