import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/date_calc.dart';
import '../auth/auth_controller.dart';
import '../cycle/cycle_providers.dart';
import '../pregnancy/pregnancy_providers.dart';
import '../reminders/reminders_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).value;
    final name = user?.displayName ?? '회원';

    return Scaffold(
      appBar: AppBar(title: const Text('맘케어')),
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
          Text(
            '오늘도 건강한 하루 되세요',
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 16),
          const _TodaySummary(),
          const SizedBox(height: 4),
          _CycleSummaryCard(),
          _SummaryCard(
            color: AppTheme.accent.withValues(alpha: 0.18),
            icon: Icons.notifications_active,
            iconColor: Colors.orange,
            title: '알림',
            subtitle: '약 복용·검진 일정을 놓치지 마세요',
            onTap: () => context.go('/reminders'),
          ),
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
              _QuickAction(
                icon: Icons.pregnant_woman,
                label: '임신',
                onTap: () => context.push('/pregnancy'),
              ),
              _QuickAction(
                icon: Icons.science,
                label: '임테기',
                onTap: () => context.push('/conception'),
              ),
              _QuickAction(
                icon: Icons.menu_book,
                label: '일기',
                onTap: () => context.push('/diary'),
              ),
              _QuickAction(
                icon: Icons.photo_library,
                label: '초음파',
                onTap: () => context.push('/ultrasound'),
              ),
              _QuickAction(
                icon: Icons.child_care,
                label: '육아',
                onTap: () => context.push('/baby'),
              ),
              _QuickAction(
                icon: Icons.info_outline,
                label: '정보',
                onTap: () => context.push('/info'),
              ),
            ],
          ),
        ],
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
    final preg = ref.watch(activePregnancyProvider).value;
    final pred = ref.watch(cyclePredictionProvider);
    final reminders = ref.watch(remindersProvider).value ?? const [];
    final todayReminders = reminders
        .where((r) =>
            r.enabled &&
            (r.repeat != 'none' ||
                DateCalc.dateOnly(r.nextTrigger) == today))
        .length;

    String headline;
    IconData icon;
    if (preg != null) {
      final s = PregnancyStatus.from(preg, today);
      headline = '임신 ${s.week}주 ${s.dayOfWeek}일 · 출산까지 D-${s.dDay}';
      icon = Icons.pregnant_woman;
    } else if (pred != null) {
      final d = pred.daysUntilNextPeriod(today);
      headline = d > 0
          ? '다음 생리까지 D-$d'
          : (d == 0 ? '오늘이 생리 예정일이에요' : '생리 예정일 ${-d}일 경과');
      icon = Icons.water_drop;
    } else {
      headline = '생리를 기록하면 다음 주기를 예측해 드려요';
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
                  todayReminders > 0
                      ? '오늘 예정된 알림 $todayReminders건'
                      : '오늘 예정된 알림이 없어요',
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

/// 주기 추적 진입 카드 — 예측 요약을 동적으로 보여준다.
class _CycleSummaryCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pred = ref.watch(cyclePredictionProvider);
    final subtitle = pred == null
        ? '생리를 기록하고 다음 주기를 예측하세요'
        : '평균 ${pred.cycleLength}일 주기 · 배란 예정 '
            '${pred.ovulation.month}/${pred.ovulation.day}';
    return _SummaryCard(
      color: AppTheme.primary.withValues(alpha: 0.12),
      icon: Icons.water_drop,
      iconColor: AppTheme.period,
      title: '주기 추적',
      subtitle: subtitle,
      onTap: () => context.go('/cycle'),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.color,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final Color color;
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(icon, color: iconColor),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 2),
                    Text(subtitle,
                        style: TextStyle(
                            color: Colors.grey.shade700, fontSize: 13)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
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
