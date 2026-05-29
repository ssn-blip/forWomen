import 'dart:io';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/db/database.dart';
import '../../core/db/database_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/date_calc.dart';
import 'add_bbt_sheet.dart';
import 'add_test_sheet.dart';
import 'conception_providers.dart';

class ConceptionScreen extends ConsumerWidget {
  const ConceptionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('임신 준비'),
          bottom: const TabBar(
            tabs: [
              Tab(text: '테스트'),
              Tab(text: '기초체온'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _TestTab(),
            _BbtTab(),
          ],
        ),
      ),
    );
  }
}

// ─── 테스트 탭 (임테기/배란테스트) ────────────────────────────────────────
class _TestTab extends ConsumerWidget {
  const _TestTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logsAsync = ref.watch(testLogsProvider);

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _chooseKind(context),
        icon: const Icon(Icons.add),
        label: const Text('테스트 기록'),
      ),
      body: logsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('오류: $e')),
        data: (logs) {
          if (logs.isEmpty) {
            return const _EmptyHint(
              icon: Icons.science,
              text: '임신테스트·배란테스트 결과를\n사진과 함께 기록해 보세요',
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 96),
            itemCount: logs.length,
            itemBuilder: (context, i) => _TestTile(log: logs[i]),
          );
        },
      ),
    );
  }

  void _chooseKind(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.pregnant_woman),
              title: const Text('임신테스트 (임테기)'),
              onTap: () {
                Navigator.pop(context);
                AddTestSheet.show(context, kind: 'pregnancy');
              },
            ),
            ListTile(
              leading: const Icon(Icons.egg_alt),
              title: const Text('배란테스트'),
              onTap: () {
                Navigator.pop(context);
                AddTestSheet.show(context, kind: 'ovulation');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _TestTile extends ConsumerWidget {
  const _TestTile({required this.log});

  final TestLog log;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kindLabel = log.kind == 'pregnancy' ? '임신테스트' : '배란테스트';
    final (resultLabel, color) = switch (log.result) {
      'positive' => ('양성', AppTheme.period),
      'faint' => ('희미함', AppTheme.predicted),
      'negative' => ('음성', Colors.grey),
      _ => ('판독불가', Colors.blueGrey),
    };

    return Card(
      child: ListTile(
        leading: log.photoPath != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(File(log.photoPath!),
                    width: 48, height: 48, fit: BoxFit.cover),
              )
            : CircleAvatar(
                backgroundColor: color.withValues(alpha: 0.2),
                child: Icon(Icons.science, color: color),
              ),
        title: Row(
          children: [
            Text(kindLabel),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(resultLabel,
                  style: TextStyle(
                      color: color, fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        subtitle: Text(DateFormat('yyyy.MM.dd', 'ko').format(log.date) +
            (log.note != null ? ' · ${log.note}' : '')),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: () => ref.read(databaseProvider).deleteTestLog(log.id),
        ),
      ),
    );
  }
}

// ─── 기초체온 탭 ──────────────────────────────────────────────────────────
class _BbtTab extends ConsumerWidget {
  const _BbtTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logsAsync = ref.watch(bbtLogsProvider);

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => AddBbtSheet.show(context),
        icon: const Icon(Icons.add),
        label: const Text('체온 기록'),
      ),
      body: logsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('오류: $e')),
        data: (logs) {
          if (logs.length < 2) {
            return const _EmptyHint(
              icon: Icons.thermostat,
              text: '매일 아침 기초체온을 기록하면\n배란 시점을 추정할 수 있어요 (2일 이상)',
            );
          }
          return ListView(
            padding: const EdgeInsets.fromLTRB(12, 16, 12, 96),
            children: [
              SizedBox(height: 260, child: _BbtChart(logs: logs)),
              const SizedBox(height: 8),
              const Text('배란 후에는 체온이 약 0.3~0.5℃ 상승해 고온기가 유지됩니다.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          );
        },
      ),
    );
  }
}

class _BbtChart extends StatelessWidget {
  const _BbtChart({required this.logs});

  final List<BbtLog> logs;

  @override
  Widget build(BuildContext context) {
    final first = logs.first.date;
    final spots = logs
        .map((e) => FlSpot(
              DateCalc.daysBetween(first, e.date).toDouble(),
              e.temperature,
            ))
        .toList();

    final temps = logs.map((e) => e.temperature);
    final minY = (temps.reduce((a, b) => a < b ? a : b) - 0.2);
    final maxY = (temps.reduce((a, b) => a > b ? a : b) + 0.2);

    return LineChart(
      LineChartData(
        minY: minY,
        maxY: maxY,
        gridData: const FlGridData(show: true, drawVerticalLine: false),
        titlesData: FlTitlesData(
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: 0.2,
              getTitlesWidget: (v, _) => Text(v.toStringAsFixed(1),
                  style: const TextStyle(fontSize: 10)),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
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
            color: AppTheme.primary,
            barWidth: 3,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: AppTheme.primary.withValues(alpha: 0.12),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyHint extends StatelessWidget {
  const _EmptyHint({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: AppTheme.secondary),
            const SizedBox(height: 16),
            Text(text,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600)),
          ],
        ),
      ),
    );
  }
}
