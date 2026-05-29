import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/db/database.dart';
import '../../core/theme/app_theme.dart';
import 'add_reminder_sheet.dart';
import 'reminders_providers.dart';

class RemindersScreen extends ConsumerWidget {
  const RemindersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final remindersAsync = ref.watch(remindersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('알림')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => AddReminderSheet.show(context),
        icon: const Icon(Icons.add_alert),
        label: const Text('알림 추가'),
      ),
      body: remindersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('오류: $e')),
        data: (reminders) {
          if (reminders.isEmpty) return const _Empty();
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 96),
            itemCount: reminders.length,
            separatorBuilder: (_, i) => const SizedBox(height: 4),
            itemBuilder: (context, i) => _ReminderTile(reminder: reminders[i]),
          );
        },
      ),
    );
  }
}

class _ReminderTile extends ConsumerWidget {
  const _ReminderTile({required this.reminder});

  final Reminder reminder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (icon, color, kindLabel) = switch (reminder.kind) {
      'medication' => (Icons.medication, AppTheme.primary, '약 복용'),
      'checkup' => (Icons.local_hospital, AppTheme.ovulation, '검진'),
      _ => (Icons.event, AppTheme.secondary, '일정'),
    };
    final repeatLabel = switch (reminder.repeat) {
      'daily' => '매일',
      'weekly' => '매주',
      _ => '1회',
    };
    final timeStr = DateFormat('a h:mm', 'ko').format(reminder.nextTrigger);
    final dateStr = reminder.repeat == 'none'
        ? DateFormat('M월 d일 ', 'ko').format(reminder.nextTrigger)
        : '';

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(reminder.title,
            style: TextStyle(
              decoration: reminder.enabled ? null : TextDecoration.lineThrough,
              color: reminder.enabled ? null : Colors.grey,
            )),
        subtitle: Text('$kindLabel · $repeatLabel · $dateStr$timeStr'
            '${reminder.body != null ? '\n${reminder.body}' : ''}'),
        isThreeLine: reminder.body != null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Switch(
              value: reminder.enabled,
              onChanged: (v) => ref
                  .read(reminderServiceProvider)
                  .setEnabled(reminder, v),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () =>
                  ref.read(reminderServiceProvider).delete(reminder),
            ),
          ],
        ),
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.notifications_none, size: 64, color: Colors.orange),
            const SizedBox(height: 16),
            const Text('등록된 알림이 없어요', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('약 복용·검진·일정 알림을 추가해 보세요',
                style: TextStyle(color: Colors.grey.shade600)),
          ],
        ),
      ),
    );
  }
}
