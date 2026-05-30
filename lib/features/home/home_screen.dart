import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/db/database.dart';
import '../../core/db/database_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/date_calc.dart';
import '../auth/auth_controller.dart';
import '../cycle/app_mode.dart';
import '../cycle/cycle_providers.dart';
import '../pregnancy/pregnancy_providers.dart';
import '../reminders/reminders_providers.dart';

/// 홈 바로가기 항목.
typedef _Qa = ({IconData icon, String label, String route});

const List<_Qa> _kQuickActions = [
  (icon: Icons.menu_book, label: '일기', route: '/diary'),
  (icon: Icons.science, label: '테스트', route: '/conception'),
  (icon: Icons.pregnant_woman, label: '임신', route: '/pregnancy'),
  (icon: Icons.photo_library, label: '초음파', route: '/ultrasound'),
  (icon: Icons.child_care, label: '육아', route: '/baby'),
  (icon: Icons.list_alt, label: '기록', route: '/records'),
  (icon: Icons.info_outline, label: '정보', route: '/info'),
];

/// 모드에 맞는 메뉴를 앞으로 당겨 정렬한다.
List<_Qa> _quickActionsForMode(AppMode mode) {
  final priority = switch (mode) {
    AppMode.pregnancy => ['임신', '초음파'],
    AppMode.conception => ['테스트'],
    AppMode.period => <String>[],
  };
  final front = [
    for (final l in priority) _kQuickActions.firstWhere((a) => a.label == l),
  ];
  final rest = _kQuickActions.where((a) => !priority.contains(a.label));
  return [...front, ...rest];
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).value;
    final name = user?.displayName ?? '회원';
    final mode = ref.watch(appModeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('forWomen')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Text(
            '안녕하세요, $name님 💕',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                '오늘도 건강한 하루 되세요',
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const Spacer(),
              _ModeChip(mode: ref.watch(appModeProvider)),
            ],
          ),
          const SizedBox(height: 16),
          const _TodaySummary(),
          const _TodayMedsCard(),
          const SizedBox(height: 8),
          Text(
            '바로가기',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.95,
            children: [
              for (final a in _quickActionsForMode(mode))
                _QuickAction(
                  icon: a.icon,
                  label: a.label,
                  onTap: () => context.push(a.route),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 현재 앱 모드를 보여주는 작은 칩 (탭하면 내정보로 이동해 변경).
class _ModeChip extends StatelessWidget {
  const _ModeChip({required this.mode});

  final AppMode mode;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => context.go('/profile'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: AppTheme.primary.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(mode.icon, size: 14, color: AppTheme.primary),
            const SizedBox(width: 4),
            Text('${mode.label} 모드',
                style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.primary,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

/// 오늘 복용해야 할 약을 한 탭으로 체크하는 카드.
/// 복용 기록은 캘린더·알림 배너와 동일한 DayEvent(type 'medication')를 공유한다.
class _TodayMedsCard extends ConsumerWidget {
  const _TodayMedsCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reminders = ref.watch(remindersProvider).value ?? const [];
    final events = ref.watch(dayEventsProvider).value ?? const [];
    final now = DateTime.now();
    final today = DateCalc.dateOnly(now);

    // 오늘 복용 대상인 약 알림(매일/오늘 요일의 매주/오늘 1회).
    bool dueToday(Reminder r) {
      if (!r.enabled || r.kind != 'medication') return false;
      return switch (r.repeat) {
        'daily' => true,
        'weekly' => r.nextTrigger.weekday == now.weekday,
        _ => DateCalc.dateOnly(r.nextTrigger) == today,
      };
    }

    final meds = reminders.where(dueToday).toList()
      ..sort((a, b) {
        final am = a.nextTrigger.hour * 60 + a.nextTrigger.minute;
        final bm = b.nextTrigger.hour * 60 + b.nextTrigger.minute;
        return am.compareTo(bm);
      });
    if (meds.isEmpty) return const SizedBox.shrink();

    // 오늘 이미 복용 처리된 약(제목 → DayEvent id). 해제 시 삭제에 사용.
    final takenByTitle = <String, int>{};
    for (final e in events) {
      if (e.type == 'medication' && DateCalc.dateOnly(e.date) == today) {
        takenByTitle.putIfAbsent(e.title ?? '', () => e.id);
      }
    }
    final doneCount =
        meds.where((m) => takenByTitle.containsKey(m.title)).length;

    Future<void> toggle(Reminder m, bool taken) async {
      if (taken) {
        await ref.read(reminderServiceProvider).recordTaken(m.title);
      } else {
        final id = takenByTitle[m.title];
        if (id != null) await ref.read(databaseProvider).deleteDayEvent(id);
      }
    }

    return Card(
      color: AppTheme.primary.withValues(alpha: 0.08),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 10, 8, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.medication, color: AppTheme.primary, size: 20),
                const SizedBox(width: 8),
                const Text('오늘의 약',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const Spacer(),
                Text('$doneCount/${meds.length} 복용',
                    style: TextStyle(
                        color: doneCount == meds.length
                            ? AppTheme.primary
                            : Colors.grey.shade600,
                        fontWeight: FontWeight.bold,
                        fontSize: 13)),
                const SizedBox(width: 8),
              ],
            ),
            ...meds.map((m) {
              final taken = takenByTitle.containsKey(m.title);
              final time = DateFormat('a h:mm', 'ko').format(m.nextTrigger);
              return InkWell(
                onTap: () => toggle(m, !taken),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Icon(
                        taken
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: taken ? AppTheme.primary : Colors.grey.shade400,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          m.title,
                          style: TextStyle(
                            decoration:
                                taken ? TextDecoration.lineThrough : null,
                            color: taken ? Colors.grey : null,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Text(time,
                          style: TextStyle(
                              color: Colors.grey.shade600, fontSize: 12)),
                      const SizedBox(width: 8),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

/// 오늘의 핵심 상태 한 줄 요약 (임신 주차 / 생리 D-day + 오늘 알림 수).
class _TodaySummary extends ConsumerWidget {
  const _TodaySummary();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = DateCalc.dateOnly(DateTime.now());
    final mode = ref.watch(appModeProvider);
    final preg = ref.watch(activePregnancyProvider).value;
    final pred = ref.watch(cyclePredictionProvider);
    final reminders = ref.watch(remindersProvider).value ?? const [];
    final todayReminders = reminders
        .where((r) =>
            r.enabled &&
            (r.repeat != 'none' ||
                DateCalc.dateOnly(r.nextTrigger) == today))
        .length;
    final alarmText = todayReminders > 0
        ? '오늘 예정된 알림 $todayReminders건'
        : '오늘 예정된 알림이 없어요';

    // 모드에 맞춰 보여줄 내용을 정한다.
    // - 임신 모드: 임신 주차·출산까지 D-day
    // - 그 외(생리·피임 / 임신준비): 생리·가임·배란 예측
    String headline;
    String detail;
    IconData icon;
    if (mode == AppMode.pregnancy && preg != null) {
      final s = PregnancyStatus.from(preg, today);
      headline = '임신 ${s.week}주 ${s.dayOfWeek}일 · 출산까지 D-${s.dDay}';
      detail = '출산 예정일 ${DateFormat('yyyy.MM.dd', 'ko').format(s.dueDate)}';
      icon = Icons.pregnant_woman;
    } else if (mode == AppMode.pregnancy) {
      headline = '임신을 등록해 주세요';
      detail = '임신 메뉴에서 등록하면 주차·출산예정일을 계산해요';
      icon = Icons.pregnant_woman;
    } else if (pred != null) {
      final dPeriod = pred.daysUntilNextPeriod(today);
      if (mode == AppMode.period) {
        // 생리·피임 모드: 생리 중심.
        headline = dPeriod > 0
            ? '다음 생리까지 D-$dPeriod'
            : (dPeriod == 0 ? '오늘이 생리 예정일이에요' : '생리 예정일 ${-dPeriod}일 경과');
        detail = '생리 예정 ${pred.nextPeriod.month}/${pred.nextPeriod.day}'
            ' · 평균 ${pred.cycleLength}일 주기';
        icon = Icons.water_drop;
      } else {
        // 임신준비 모드: 가임·배란 중심.
        final dOvu = DateCalc.daysBetween(today, pred.ovulation);
        final inFertile = !today.isBefore(pred.fertileStart) &&
            !today.isAfter(pred.fertileEnd);
        if (DateCalc.dateOnly(pred.ovulation) == today) {
          headline = '오늘 배란 예정일이에요';
          icon = Icons.brightness_5;
        } else if (inFertile) {
          headline = dOvu > 0 ? '가임기 · 배란까지 D-$dOvu' : '가임기예요';
          icon = Icons.eco;
        } else {
          headline = dPeriod > 0
              ? '다음 생리까지 D-$dPeriod'
              : (dPeriod == 0
                  ? '오늘이 생리 예정일이에요'
                  : '생리 예정일 ${-dPeriod}일 경과');
          icon = Icons.water_drop;
        }
        detail = '배란 ${pred.ovulation.month}/${pred.ovulation.day} · '
            '가임기 ${pred.fertileStart.month}/${pred.fertileStart.day}'
            '~${pred.fertileEnd.month}/${pred.fertileEnd.day}';
      }
    } else {
      headline = '생리를 기록하면 다음 주기를 예측해 드려요';
      detail = alarmText;
      icon = Icons.favorite;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primary.withValues(alpha: 0.85),
            AppTheme.secondary.withValues(alpha: 0.85),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 32),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(headline,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(
                  detail,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({required this.icon, required this.label, this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap ??
          () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('"$label" 기능은 다음 단계에서 추가됩니다')),
            );
          },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppTheme.secondary, size: 28),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
