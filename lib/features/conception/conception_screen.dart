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
import 'test_guide_sheet.dart';

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

// ─── 테스트 탭 (임신테스트/배란테스트) ────────────────────────────────────
class _TestTab extends ConsumerStatefulWidget {
  const _TestTab();

  @override
  ConsumerState<_TestTab> createState() => _TestTabState();
}

class _TestTabState extends ConsumerState<_TestTab> {
  String _filter = 'all'; // 'all' | 'pregnancy' | 'ovulation'

  @override
  Widget build(BuildContext context) {
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
          final filtered = _filter == 'all'
              ? logs
              : logs.where((l) => l.kind == _filter).toList();
          return Column(
            children: [
              // 전체/임신/배란 필터
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                child: SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'all', label: Text('전체')),
                    ButtonSegment(value: 'pregnancy', label: Text('임신테스트')),
                    ButtonSegment(value: 'ovulation', label: Text('배란테스트')),
                  ],
                  selected: {_filter},
                  onSelectionChanged: (s) => setState(() => _filter = s.first),
                  showSelectedIcon: false,
                ),
              ),
              Expanded(
                child: filtered.isEmpty
                    ? const _EmptyHint(
                        icon: Icons.science,
                        text: '아직 기록이 없어요.\n+ 버튼으로 결과를 사진과 함께 기록해 보세요',
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(12, 4, 12, 96),
                        itemCount: filtered.length,
                        itemBuilder: (context, i) => _TestTile(log: filtered[i]),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _chooseKind(BuildContext context) {
    void start(String kind) => TestGuideSheet.show(context,
        kind: kind, onStart: () => AddTestSheet.show(context, kind: kind));

    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.pregnant_woman),
              title: const Text('임신테스트'),
              onTap: () {
                Navigator.pop(context);
                start('pregnancy');
              },
            ),
            ListTile(
              leading: const Icon(Icons.egg_alt),
              title: const Text('배란테스트'),
              onTap: () {
                Navigator.pop(context);
                start('ovulation');
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
        subtitle: Text(DateFormat('yyyy.MM.dd HH:mm', 'ko').format(log.date) +
            ((log.ratio ?? 0) > 0
                ? ' · T/C ${((log.ratio ?? 0) * 100).round()}%'
                : '') +
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
          if (logs.isEmpty) {
            return const _EmptyHint(
              icon: Icons.thermostat,
              text: '매일 아침 기초체온을 기록하면\n배란 시점을 추정할 수 있어요',
            );
          }
          final fmt = DateFormat('yyyy.MM.dd (E)', 'ko');
          // 목록은 최신순.
          final recent = logs.reversed.toList();
          return ListView(
            padding: const EdgeInsets.fromLTRB(12, 16, 12, 96),
            children: [
              if (logs.length >= 2) ...[
                SizedBox(height: 240, child: _BbtChart(logs: logs)),
                const SizedBox(height: 8),
                const Text('배란 후에는 체온이 약 0.3~0.5℃ 상승해 고온기가 유지됩니다.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
              ] else
                const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text('2일 이상 기록하면 변화 그래프가 표시돼요.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                ),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                child: Text('기록',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              ...recent.map((log) => Card(
                    child: ListTile(
                      onTap: () => AddBbtSheet.show(context, existing: log),
                      leading: const CircleAvatar(
                        backgroundColor: AppTheme.primary,
                        child: Icon(Icons.thermostat,
                            color: Colors.white, size: 20),
                      ),
                      title: Text(fmt.format(log.date)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('${log.temperature}℃',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15)),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, size: 20),
                            onPressed: () =>
                                ref.read(databaseProvider).deleteBbtLog(log.id),
                          ),
                        ],
                      ),
                    ),
                  )),
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
