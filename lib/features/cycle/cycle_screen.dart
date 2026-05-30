import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../core/db/database.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/date_calc.dart';
import 'cycle_providers.dart';
import 'cycle_settings.dart';
import 'cycle_settings_dialog.dart';
import 'day_event_types.dart';
import 'quick_record_sheet.dart';
import 'record_panel_settings_screen.dart';

enum _DayType { none, period, predictedPeriod, ovulation, fertile }

/// 패널이 접혔을 때 / 펼쳐졌을 때 화면 높이 비율.
/// 1.0이면 본문(앱바 아래) 전체를 채워 헤더 바로 아래까지 올라온다.
const double _kPanelMin = 0.45;
const double _kPanelMax = 1.0;

class CycleScreen extends ConsumerStatefulWidget {
  const CycleScreen({super.key});

  @override
  ConsumerState<CycleScreen> createState() => _CycleScreenState();
}

class _CycleScreenState extends ConsumerState<CycleScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final _sheetController = DraggableScrollableController();
  bool _expanded = false;

  @override
  void initState() {
    super.initState();
    _sheetController.addListener(_onSheetMove);
  }

  @override
  void dispose() {
    _sheetController.removeListener(_onSheetMove);
    _sheetController.dispose();
    super.dispose();
  }

  /// 드래그로 시트가 절반 이상 올라오면 화살표 방향을 뒤집는다.
  void _onSheetMove() {
    if (!_sheetController.isAttached) return;
    final exp = _sheetController.size > (_kPanelMin + _kPanelMax) / 2;
    if (exp != _expanded) setState(() => _expanded = exp);
  }

  /// 가운데 화살표 탭: 접힘 ↔ 펼침 토글.
  void _toggleSheet() {
    if (!_sheetController.isAttached) return;
    final target = _sheetController.size > (_kPanelMin + _kPanelMax) / 2
        ? _kPanelMin
        : _kPanelMax;
    _sheetController.animateTo(
      target,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  /// 특정 날짜의 주기 의미(생리/예측/배란/가임). 실제 기록이 예측보다 우선.
  _DayType _typeOf(DateTime day, List<CycleLog> logs, CyclePrediction? pred,
      int periodLength) {
    final d = DateCalc.dateOnly(day);

    for (final log in logs) {
      final start = DateCalc.dateOnly(log.startDate);
      final end = log.endDate != null
          ? DateCalc.dateOnly(log.endDate!)
          : start.add(Duration(days: periodLength - 1));
      if (!d.isBefore(start) && !d.isAfter(end)) return _DayType.period;
    }

    if (pred == null) return _DayType.none;
    if (isSameDay(d, pred.ovulation)) return _DayType.ovulation;

    final predEnd = pred.nextPeriod.add(Duration(days: periodLength - 1));
    if (!d.isBefore(pred.nextPeriod) && !d.isAfter(predEnd)) {
      return _DayType.predictedPeriod;
    }
    if (!d.isBefore(pred.fertileStart) && !d.isAfter(pred.fertileEnd)) {
      return _DayType.fertile;
    }
    return _DayType.none;
  }

  Color? _colorFor(_DayType type) => switch (type) {
        _DayType.period => AppTheme.period,
        _DayType.predictedPeriod => AppTheme.predicted,
        _DayType.ovulation => AppTheme.ovulation,
        _DayType.fertile => AppTheme.fertile,
        _DayType.none => null,
      };

  void _showLegend() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('표시 안내'),
        content: const SingleChildScrollView(child: _Legend()),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('확인')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final logsAsync = ref.watch(cycleLogsProvider);
    final pred = ref.watch(cyclePredictionProvider);
    final periodLength = ref.watch(cycleSettingsProvider).periodLength;
    final events = ref.watch(dayEventsProvider).value ?? const [];
    final pillSeq = ref.watch(pillSequenceProvider);

    final eventsByDay = <DateTime, List<DayEvent>>{};
    for (final e in events) {
      (eventsByDay[DateCalc.dateOnly(e.date)] ??= []).add(e);
    }
    List<DayEvent> eventsOn(DateTime d) =>
        eventsByDay[DateCalc.dateOnly(d)] ?? const [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('주기'),
        actions: [
          IconButton(
            tooltip: '표시 안내',
            icon: const Icon(Icons.help_outline),
            onPressed: _showLegend,
          ),
          IconButton(
            tooltip: '주기 설정',
            icon: const Icon(Icons.tune),
            onPressed: () => CycleSettingsDialog.show(context),
          ),
        ],
      ),
      body: logsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('오류: $e')),
        data: (logs) {
          final selDay = _selectedDay ?? DateCalc.dateOnly(DateTime.now());
          final screenH = MediaQuery.of(context).size.height;
          return Stack(
            children: [
              // 배경: 달력. 접힌 패널 높이만큼 아래 여백을 둬 가려지지 않게.
              Positioned.fill(
                child: SingleChildScrollView(
                  padding:
                      EdgeInsets.fromLTRB(12, 8, 12, screenH * _kPanelMin + 16),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: TableCalendar(
                        locale: 'ko_KR',
                        firstDay: DateTime(2015),
                        lastDay: DateTime(2100),
                        focusedDay: _focusedDay,
                        rowHeight: 56,
                        selectedDayPredicate: (d) => isSameDay(d, _selectedDay),
                        onDaySelected: (selected, focused) {
                          // 날짜 탭 → 선택 표시. 패널은 그 날짜로 자동 갱신된다.
                          setState(() {
                            _selectedDay = selected;
                            _focusedDay = focused;
                          });
                        },
                        availableCalendarFormats: const {
                          CalendarFormat.month: '월'
                        },
                        headerStyle: const HeaderStyle(
                          formatButtonVisible: false,
                          titleCentered: true,
                        ),
                        calendarBuilders: CalendarBuilders(
                          defaultBuilder: (context, day, _) => _dayCell(
                              day,
                              _typeOf(day, logs, pred, periodLength),
                              eventsOn(day),
                              pillSeq),
                          outsideBuilder: (context, day, _) => _dayCell(
                              day,
                              _typeOf(day, logs, pred, periodLength),
                              eventsOn(day),
                              pillSeq,
                              outside: true),
                          todayBuilder: (context, day, _) => _dayCell(
                              day,
                              _typeOf(day, logs, pred, periodLength),
                              eventsOn(day),
                              pillSeq,
                              today: true),
                          selectedBuilder: (context, day, _) => _dayCell(
                              day,
                              _typeOf(day, logs, pred, periodLength),
                              eventsOn(day),
                              pillSeq,
                              selected: true),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // 하단 상시 기록 패널 (드래그/화살표로 확장·축소).
              DraggableScrollableSheet(
                controller: _sheetController,
                initialChildSize: _kPanelMin,
                minChildSize: _kPanelMin,
                maxChildSize: _kPanelMax,
                snap: true,
                snapSizes: const [_kPanelMin, _kPanelMax],
                builder: (context, scrollController) => _RecordPanel(
                  date: selDay,
                  scrollController: scrollController,
                  expanded: _expanded,
                  onToggle: _toggleSheet,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _dayCell(DateTime day, _DayType type, List<DayEvent> events,
      Map<int, int> pillSeq,
      {bool selected = false, bool today = false, bool outside = false}) {
    final color = _colorFor(type);
    final filled = color != null;
    final numberColor = filled
        ? Colors.white
        : (outside ? Colors.grey.shade400 : Colors.black87);

    final pillNums = events
        .where((e) => e.type == 'pill')
        .map((e) => pillSeq[e.id])
        .whereType<int>()
        .toList()
      ..sort();
    final otherEvents = events.where((e) => e.type != 'pill').toList();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: filled ? color.withValues(alpha: 0.85) : null,
              shape: BoxShape.circle,
              border: selected
                  ? Border.all(color: AppTheme.secondary, width: 2)
                  : today
                      ? Border.all(color: Colors.grey.shade400)
                      : null,
            ),
            alignment: Alignment.center,
            child: Text(
              '${day.day}',
              style: TextStyle(
                fontSize: 13,
                color: numberColor,
                fontWeight: filled ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          const SizedBox(height: 2),
          SizedBox(
            height: 14,
            child: (pillNums.isEmpty && otherEvents.isEmpty)
                ? null
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (pillNums.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 3, vertical: 1),
                          decoration: BoxDecoration(
                            color: pillMeta.color,
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(pillMeta.icon, size: 9, color: Colors.white),
                              const SizedBox(width: 1),
                              Text(
                                pillNums.join(','),
                                style: const TextStyle(
                                    fontSize: 9,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      for (final e in otherEvents.take(2))
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0.5),
                          child: Icon(
                            eventMeta(e.type)?.icon ?? Icons.circle,
                            size: 11,
                            color: eventMeta(e.type)?.color ?? Colors.grey,
                          ),
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

/// 하단 상시 기록 패널: 가운데 화살표 핸들 + 날짜 헤더 + 기록 목록.
class _RecordPanel extends StatelessWidget {
  const _RecordPanel({
    required this.date,
    required this.scrollController,
    required this.expanded,
    required this.onToggle,
  });

  final DateTime date;
  final ScrollController scrollController;
  final bool expanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final headerFmt = DateFormat('M월 d일 (E)', 'ko');
    return Material(
      elevation: 12,
      color: Theme.of(context).cardColor,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // 가운데 화살표 핸들 (탭: 확장/축소 토글)
          InkWell(
            onTap: onToggle,
            child: SizedBox(
              height: 40,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Icon(
                    expanded
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_up,
                    size: 22,
                    color: Colors.grey.shade500,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 8, 4),
            child: Row(
              children: [
                Text('${headerFmt.format(date)} 기록',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 20),
                  tooltip: '기록 항목 편집',
                  onPressed: () => RecordPanelSettingsScreen.show(context),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: DayRecordList(date: date, scrollController: scrollController),
          ),
        ],
      ),
    );
  }
}

/// 캘린더 색/아이콘 표시 안내 (도움말 다이얼로그에서 사용).
class _Legend extends StatelessWidget {
  const _Legend();

  @override
  Widget build(BuildContext context) {
    Widget dot(Color c, String label) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                width: 13,
                height: 13,
                decoration: BoxDecoration(color: c, shape: BoxShape.circle)),
            const SizedBox(width: 5),
            Text(label, style: const TextStyle(fontSize: 12)),
          ],
        );
    Widget icon(IconData i, Color c, String label) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(i, size: 14, color: c),
            const SizedBox(width: 4),
            Text(label, style: const TextStyle(fontSize: 12)),
          ],
        );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Wrap(
          spacing: 14,
          runSpacing: 8,
          children: [
            dot(AppTheme.period, '생리'),
            dot(AppTheme.predicted, '생리예측'),
            dot(AppTheme.ovulation, '배란'),
            dot(AppTheme.fertile, '가임기'),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 14,
          runSpacing: 8,
          children: [
            for (final m in kEventTypes.values) icon(m.icon, m.color, m.label),
            icon(pillMeta.icon, pillMeta.color, pillMeta.label),
          ],
        ),
      ],
    );
  }
}
