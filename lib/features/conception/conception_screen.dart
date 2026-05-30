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
import 'strip_analyzer.dart';
import 'test_guide_sheet.dart';
import 'test_timer_sheet.dart';

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
      body: logsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('오류: $e')),
        data: (logs) {
          final filtered = _filter == 'all'
              ? logs
              : logs.where((l) => l.kind == _filter).toList();
          return Stack(
            children: [
              Column(
            children: [
              // 필터: [전체] [임신테스트 ▾]. 임신테스트 버튼 바로 아래로 종류 메뉴가 펼쳐진다.
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _FilterChip(
                      label: '전체',
                      selected: _filter == 'all',
                      onTap: () => setState(() => _filter = 'all'),
                    ),
                    const SizedBox(width: 8),
                    MenuAnchor(
                      builder: (context, controller, _) => _FilterChip(
                        label:
                            '${_filter == 'ovulation' ? '배란테스트' : '임신테스트'} ▾',
                        selected: _filter != 'all',
                        onTap: () => controller.isOpen
                            ? controller.close()
                            : controller.open(),
                      ),
                      menuChildren: [
                        for (final opt in const [
                          ('pregnancy', '임신테스트'),
                          ('ovulation', '배란테스트'),
                        ])
                          MenuItemButton(
                            trailingIcon: _filter == opt.$1
                                ? const Icon(Icons.check,
                                    color: AppTheme.primary, size: 18)
                                : null,
                            onPressed: () => setState(() => _filter = opt.$1),
                            child: Text(opt.$2),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              if (filtered.any((l) => (l.ratio ?? 0) > 0)) const _ScoreLegend(),
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
              ),
              // 왼쪽 하단: 판독 대기 타이머 / 오른쪽 하단: 기록 추가(대칭)
              Positioned(
                left: 16,
                bottom: 16,
                child: FloatingActionButton(
                  heroTag: 'testTimer',
                  onPressed: () => TestTimerSheet.show(context),
                  child: const Icon(Icons.timer_outlined),
                ),
              ),
              Positioned(
                right: 16,
                bottom: 16,
                child: FloatingActionButton(
                  heroTag: 'testAdd',
                  onPressed: () => _chooseKind(context),
                  child: const Icon(Icons.add),
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

/// 필터용 알약 칩 (선택 시 핑크+흰 글씨).
class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      showCheckmark: false,
      selectedColor: AppTheme.primary,
      labelStyle: TextStyle(
        color: selected ? Colors.white : Colors.grey.shade700,
        fontWeight: selected ? FontWeight.bold : FontWeight.normal,
      ),
      side: BorderSide(
          color: selected ? AppTheme.primary : Colors.grey.shade300),
    );
  }
}

class _TestTile extends ConsumerWidget {
  const _TestTile({required this.log});

  final TestLog log;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasScore = (log.ratio ?? 0) > 0;
    final score = scoreFromRatio(log.ratio ?? 0);
    final dotColor = scoreColor(score);
    final (resultLabel, resultColor) = switch (log.result) {
      'positive' => ('양성', AppTheme.period),
      'faint' => ('희미함', AppTheme.predicted),
      'negative' => ('음성', Colors.grey),
      _ => ('판독불가', Colors.blueGrey),
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        child: Row(
          children: [
            // 크롭된 스트립 썸네일 (가로)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: log.photoPath != null
                  ? Image.file(File(log.photoPath!),
                      width: 96, height: 44, fit: BoxFit.cover)
                  : Container(
                      width: 96,
                      height: 44,
                      color: Colors.grey.shade200,
                      child: Icon(Icons.science,
                          color: Colors.grey.shade500, size: 20),
                    ),
            ),
            const SizedBox(width: 10),
            // 점수 + 색 점 (배란) / 결과 배지 (임신)
            if (hasScore) ...[
              Container(
                width: 12,
                height: 12,
                decoration:
                    BoxDecoration(color: dotColor, shape: BoxShape.circle),
              ),
              const SizedBox(width: 6),
              Text(score.toStringAsFixed(1),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
            ] else
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: resultColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(resultLabel,
                    style: TextStyle(
                        color: resultColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold)),
              ),
            const Spacer(),
            // 날짜·시간
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${DateFormat('yyyy년 M월 d일', 'ko').format(log.date)}\n'
                  '${DateFormat('a hh시 mm분', 'ko').format(log.date)}',
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 20),
              onPressed: () => ref.read(databaseProvider).deleteTestLog(log.id),
            ),
          ],
        ),
      ),
    );
  }
}

/// 점수 구간 범례 (0~4.9 / 5.0~8.9 / 9.0~10.0)
class _ScoreLegend extends StatelessWidget {
  const _ScoreLegend();

  @override
  Widget build(BuildContext context) {
    Widget item(Color c, String label) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(color: c, shape: BoxShape.circle)),
            const SizedBox(width: 5),
            Text(label, style: const TextStyle(fontSize: 12)),
          ],
        );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Wrap(
        spacing: 14,
        runSpacing: 6,
        children: [
          item(const Color(0xFF90CAF9), '0~4.9'),
          item(const Color(0xFFA5D6A7), '5.0~8.9'),
          item(const Color(0xFF43A047), '9.0~10.0'),
        ],
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
