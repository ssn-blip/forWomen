import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/db/database.dart';
import '../../core/db/database_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/date_calc.dart';
import '../baby/birth_record_sheet.dart';
import '../cycle/app_mode.dart';
import '../cycle/mode_prompt.dart';
import 'fetal_info.dart';
import 'pregnancy_providers.dart';
import 'pregnancy_sheets.dart';
import 'register_pregnancy_sheet.dart';

class PregnancyScreen extends ConsumerWidget {
  const PregnancyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pregAsync = ref.watch(activePregnancyProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('임신'),
        actions: [
          if (pregAsync.value != null)
            IconButton(
              tooltip: '임신 기록 삭제',
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _confirmDelete(context, ref, pregAsync.value!),
            ),
        ],
      ),
      body: pregAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('오류: $e')),
        data: (preg) =>
            preg == null ? const _NoPregnancy() : _PregnancyDashboard(preg: preg),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, Pregnancy preg) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('임신 기록 삭제'),
        content: const Text('현재 임신 기록을 삭제할까요?\n(잘못 등록했거나 종료된 경우)'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () async {
              await ref.read(databaseProvider).deletePregnancy(preg.id);
              if (context.mounted) Navigator.pop(context);
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red.shade400),
            child: const Text('삭제'),
          ),
        ],
      ),
    );
  }
}

class _NoPregnancy extends ConsumerWidget {
  const _NoPregnancy();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.pregnant_woman, size: 72, color: AppTheme.primary),
            const SizedBox(height: 16),
            const Text('임신을 등록해 주세요',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('마지막 생리 시작일을 입력하면\n주차와 출산예정일을 자동으로 계산해 드려요',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600)),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () async {
                final saved = await RegisterPregnancySheet.show(context);
                if (saved == true && context.mounted) {
                  await promptSwitchMode(context, ref, AppMode.pregnancy,
                      message: '임신을 등록했어요. 홈에서 임신 주차·출산까지 D-day를 보려면 '
                          '임신 모드로 바꿔보세요.');
                }
              },
              icon: const Icon(Icons.add),
              label: const Text('임신 등록'),
            ),
          ],
        ),
      ),
    );
  }
}

class _PregnancyDashboard extends ConsumerWidget {
  const _PregnancyDashboard({required this.preg});

  final Pregnancy preg;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status =
        PregnancyStatus.from(preg, DateCalc.dateOnly(DateTime.now()));
    final info = fetalInfoForWeek(status.week);

    return ListView(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
      children: [
        _StatusCard(status: status),
        _FetalCard(info: info, week: status.week),
        _SectionHeader(
          title: '체중 변화',
          onAdd: () => AddWeightSheet.show(context),
        ),
        const _WeightSection(),
        _SectionHeader(
          title: '증상 기록',
          onAdd: () => AddSymptomSheet.show(context),
        ),
        const _SymptomSection(),
        const SizedBox(height: 16),
        Center(
          child: FilledButton.icon(
            onPressed: () => BirthRecordSheet.show(context, pregnancy: preg),
            icon: const Icon(Icons.celebration),
            label: const Text('출산 기록하기'),
          ),
        ),
      ],
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.status});

  final PregnancyStatus status;

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('yyyy년 M월 d일', 'ko');
    return Card(
      color: AppTheme.primary.withValues(alpha: 0.12),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('임신 ${status.week}주 ${status.dayOfWeek}일',
                style: const TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('${status.trimester}분기 · 출산까지 D-${status.dDay}',
                style: TextStyle(color: Colors.grey.shade700)),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.child_friendly, size: 18),
                const SizedBox(width: 8),
                Text('출산 예정일  ${fmt.format(status.dueDate)}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FetalCard extends StatelessWidget {
  const _FetalCard({required this.info, required this.week});

  final FetalInfo info;
  final int week;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: AppTheme.accent.withValues(alpha: 0.3),
              child: const Text('👶', style: TextStyle(fontSize: 26)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('아기 크기: ${info.size} 정도',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(info.summary,
                      style: TextStyle(
                          color: Colors.grey.shade700, fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.onAdd});

  final String title;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, left: 4, right: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          TextButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add, size: 18),
            label: const Text('추가'),
          ),
        ],
      ),
    );
  }
}

class _WeightSection extends ConsumerWidget {
  const _WeightSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logs = ref.watch(weightLogsProvider).value ?? const [];
    if (logs.length < 2) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text('체중을 2회 이상 기록하면 변화 그래프가 표시돼요.',
              style: TextStyle(color: Colors.grey)),
        ),
      );
    }

    final first = logs.first.date;
    final spots = logs
        .map((e) => FlSpot(
            DateCalc.daysBetween(first, e.date).toDouble(), e.weightKg))
        .toList();
    final ws = logs.map((e) => e.weightKg);
    final minY = ws.reduce((a, b) => a < b ? a : b) - 1;
    final maxY = ws.reduce((a, b) => a > b ? a : b) + 1;

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 16, 16, 8),
        child: SizedBox(
          height: 220,
          child: LineChart(
            LineChartData(
              minY: minY,
              maxY: maxY,
              gridData: const FlGridData(show: true, drawVerticalLine: false),
              titlesData: FlTitlesData(
                rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false)),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 36,
                    getTitlesWidget: (v, _) => Text(v.toStringAsFixed(0),
                        style: const TextStyle(fontSize: 10)),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 24,
                    interval: (spots.length / 5).ceilToDouble().clamp(1, 999),
                    getTitlesWidget: (v, _) {
                      final d = first.add(Duration(days: v.toInt()));
                      return Text(DateFormat('M/d').format(d),
                          style: const TextStyle(fontSize: 10));
                    },
                  ),
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  color: AppTheme.secondary,
                  barWidth: 3,
                  dotData: const FlDotData(show: true),
                  belowBarData: BarAreaData(
                    show: true,
                    color: AppTheme.secondary.withValues(alpha: 0.12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SymptomSection extends ConsumerWidget {
  const _SymptomSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logs = ref.watch(symptomLogsProvider).value ?? const [];
    if (logs.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text('오늘의 컨디션과 증상을 기록해 보세요.',
              style: TextStyle(color: Colors.grey)),
        ),
      );
    }
    final fmt = DateFormat('M월 d일', 'ko');
    return Column(
      children: logs.take(8).map((log) {
        final sev = switch (log.severity) {
          3 => '심함',
          2 => '보통',
          _ => '약함',
        };
        return Card(
          child: ListTile(
            dense: true,
            leading: const Icon(Icons.healing, color: AppTheme.secondary),
            title: Text(log.symptoms.replaceAll(',', ', ')),
            subtitle: Text('${fmt.format(log.date)} · 강도 $sev'
                '${log.note != null ? ' · ${log.note}' : ''}'),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline, size: 20),
              onPressed: () =>
                  ref.read(databaseProvider).deleteSymptomLog(log.id),
            ),
          ),
        );
      }).toList(),
    );
  }
}
