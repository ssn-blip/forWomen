import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/date_calc.dart';
import '../conception/conception_providers.dart';
import '../cycle/cycle_providers.dart';
import '../cycle/day_event_types.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('기록 통계')),
      body: const StatsView(),
    );
  }
}

/// 통계 본문(차트·카운트). 별도 화면과 기록 화면의 '통계' 탭에서 공용.
class StatsView extends ConsumerWidget {
  const StatsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logs = ref.watch(cycleLogsProvider).value ?? const [];
    final events = ref.watch(dayEventsProvider).value ?? const [];
    final tests = ref.watch(testLogsProvider).value ?? const [];

    // 주기 길이(연속된 생리 시작일 간격), 오름차순.
    final starts = logs.map((e) => DateCalc.dateOnly(e.startDate)).toList()
      ..sort();
    final cycles = <({DateTime start, int len})>[];
    for (var i = 1; i < starts.length; i++) {
      final len = DateCalc.daysBetween(starts[i - 1], starts[i]);
      if (len >= 15 && len <= 60) cycles.add((start: starts[i], len: len));
    }
    final avgCycle = DateCalc.averageCycleLength(starts);

    // 평균 생리 기간 (종료일 입력된 기록 기준).
    final durations = logs
        .where((e) => e.endDate != null)
        .map((e) => DateCalc.daysBetween(e.startDate, e.endDate!) + 1)
        .toList();
    final avgPeriod = durations.isEmpty
        ? null
        : (durations.reduce((a, b) => a + b) / durations.length).round();

    // 종류별 개수.
    final eventCounts = <String, int>{};
    for (final e in events) {
      eventCounts[e.type] = (eventCounts[e.type] ?? 0) + 1;
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            _StatBox(
                  label: '평균 주기',
                  value: avgCycle != null ? '$avgCycle일' : '-',
                  icon: Icons.autorenew,
                  color: AppTheme.period),
              const SizedBox(width: 8),
              _StatBox(
                  label: '평균 생리기간',
                  value: avgPeriod != null ? '$avgPeriod일' : '-',
                  icon: Icons.water_drop,
                  color: AppTheme.predicted),
              const SizedBox(width: 8),
              _StatBox(
                  label: '기록 주기',
                  value: '${cycles.length}회',
                  icon: Icons.calendar_month,
                  color: AppTheme.secondary),
            ],
          ),
          const SizedBox(height: 16),
          const Text('최근 주기 길이',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 16, 16, 8),
              child: SizedBox(
                height: 200,
                child: cycles.length < 2
                    ? const Center(
                        child: Text('생리를 2회 이상 기록하면 주기 변화가 표시돼요.',
                            style: TextStyle(color: Colors.grey)))
                    : _CycleBarChart(cycles: cycles),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text('기록 종류별 개수',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          _CountRow(
              icon: Icons.water_drop,
              color: AppTheme.period,
              label: '생리',
              count: logs.length),
          _CountRow(
              icon: Icons.science,
              color: AppTheme.ovulation,
              label: '임테기·배란테스트',
              count: tests.length),
          for (final m in kEventTypes.values)
            _CountRow(
                icon: m.icon,
                color: m.color,
                label: m.label,
                count: eventCounts[m.key] ?? 0),
          _CountRow(
              icon: pillMeta.icon,
              color: pillMeta.color,
              label: pillMeta.label,
              count: eventCounts['pill'] ?? 0),
          const SizedBox(height: 12),
          Text('※ 통계는 참고용이며 의료 진단이 아닙니다.',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
        ],
      );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox(
      {required this.label,
      required this.value,
      required this.icon,
      required this.color});

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        color: color.withValues(alpha: 0.1),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Column(
            children: [
              Icon(icon, color: color),
              const SizedBox(height: 6),
              Text(value,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text(label,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}

class _CycleBarChart extends StatelessWidget {
  const _CycleBarChart({required this.cycles});

  final List<({DateTime start, int len})> cycles;

  @override
  Widget build(BuildContext context) {
    final recent = cycles.length > 8
        ? cycles.sublist(cycles.length - 8)
        : cycles;
    final maxLen =
        recent.map((c) => c.len).reduce((a, b) => a > b ? a : b).toDouble();

    return BarChart(
      BarChartData(
        maxY: (maxLen + 5).clamp(35, 70),
        minY: 0,
        gridData: const FlGridData(show: true, drawVerticalLine: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 10,
              getTitlesWidget: (v, _) =>
                  Text('${v.toInt()}', style: const TextStyle(fontSize: 10)),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 24,
              getTitlesWidget: (v, _) {
                final i = v.toInt();
                if (i < 0 || i >= recent.length) return const SizedBox();
                return Text(DateFormat('M/d').format(recent[i].start),
                    style: const TextStyle(fontSize: 9));
              },
            ),
          ),
        ),
        barGroups: [
          for (var i = 0; i < recent.length; i++)
            BarChartGroupData(x: i, barRods: [
              BarChartRodData(
                toY: recent[i].len.toDouble(),
                color: AppTheme.primary,
                width: 16,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
              ),
            ]),
        ],
      ),
    );
  }
}

class _CountRow extends StatelessWidget {
  const _CountRow(
      {required this.icon,
      required this.color,
      required this.label,
      required this.count});

  final IconData icon;
  final Color color;
  final String label;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        dense: true,
        leading: Icon(icon, color: color),
        title: Text(label),
        trailing: Text('$count회',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
      ),
    );
  }
}
