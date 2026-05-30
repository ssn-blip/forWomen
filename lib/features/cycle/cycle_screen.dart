import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../core/db/database.dart';
import '../../core/db/database_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/date_calc.dart';
import 'add_cycle_sheet.dart';
import 'add_event_sheet.dart';
import 'cycle_providers.dart';
import 'cycle_settings.dart';
import 'cycle_settings_dialog.dart';
import 'day_event_types.dart';
import 'pill_settings_dialog.dart';
import 'quick_record_sheet.dart';
import 'symptom_catalog.dart';
import 'symptom_picker_screen.dart';

enum _DayType { none, period, predictedPeriod, ovulation, fertile }

class CycleScreen extends ConsumerStatefulWidget {
  const CycleScreen({super.key});

  @override
  ConsumerState<CycleScreen> createState() => _CycleScreenState();
}

class _CycleScreenState extends ConsumerState<CycleScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

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

  @override
  Widget build(BuildContext context) {
    final logsAsync = ref.watch(cycleLogsProvider);
    final pred = ref.watch(cyclePredictionProvider);
    final periodLength = ref.watch(cycleSettingsProvider).periodLength;
    final events = ref.watch(dayEventsProvider).value ?? const [];
    final pillSeq = ref.watch(pillSequenceProvider);

    // 날짜별 이벤트 묶음.
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
            tooltip: '주기 설정',
            icon: const Icon(Icons.tune),
            onPressed: () => CycleSettingsDialog.show(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => QuickRecordSheet.show(
            context, _selectedDay ?? DateTime.now()),
        child: const Icon(Icons.add),
      ),
      body: logsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('오류: $e')),
        data: (logs) => ListView(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 96),
          children: [
            if (pred != null) _PredictionCard(pred: pred),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: TableCalendar(
                  locale: 'ko_KR',
                  firstDay: DateTime(2015),
                  lastDay: DateTime(2100),
                  focusedDay: _focusedDay,
                  rowHeight: 60,
                  selectedDayPredicate: (d) => isSameDay(d, _selectedDay),
                  onDaySelected: (selected, focused) => setState(() {
                    _selectedDay = selected;
                    _focusedDay = focused;
                  }),
                  availableCalendarFormats: const {CalendarFormat.month: '월'},
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
                    // 전달/다음달 날짜(예: 6월 그리드의 5월 31일)도 표시가 보이게.
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
            const _Legend(),
            const SizedBox(height: 8),
            _SelectedDayRecords(
              day: _selectedDay ?? DateCalc.dateOnly(DateTime.now()),
              logs: logs,
              events: eventsOn(_selectedDay ?? DateTime.now()),
              periodLength: periodLength,
            ),
          ],
        ),
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

    // 피임약 정 번호와 그 외 이벤트 아이콘 분리.
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
                      // 피임약: 아이콘 + 정 번호 배지 (예: 💊6 또는 💊6,7)
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
                              Icon(pillMeta.icon,
                                  size: 9, color: Colors.white),
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
                      // 그 외 이벤트 아이콘
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

class _PredictionCard extends StatelessWidget {
  const _PredictionCard({required this.pred});

  final CyclePrediction pred;

  @override
  Widget build(BuildContext context) {
    final today = DateCalc.dateOnly(DateTime.now());
    final dDay = pred.daysUntilNextPeriod(today);
    final fmt = DateFormat('M월 d일', 'ko');

    final String headline;
    if (dDay > 0) {
      headline = '다음 생리까지 D-$dDay';
    } else if (dDay == 0) {
      headline = '오늘이 생리 예정일이에요';
    } else {
      headline = '생리 예정일이 ${-dDay}일 지났어요';
    }

    return Card(
      color: AppTheme.primary.withValues(alpha: 0.12),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(headline,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _row(Icons.water_drop, AppTheme.predicted, '다음 생리 예정',
                fmt.format(pred.nextPeriod)),
            _row(Icons.brightness_5, AppTheme.ovulation, '배란 예정일',
                fmt.format(pred.ovulation)),
            _row(Icons.eco, AppTheme.fertile, '가임기',
                '${fmt.format(pred.fertileStart)} ~ ${fmt.format(pred.fertileEnd)}'),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '주기 ${pred.cycleLength}일 · '
                    '${pred.isAuto ? '기록 기반 자동 계산' : '직접 설정'} · 참고용',
                    style:
                        TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ),
                InkWell(
                  onTap: () => CycleSettingsDialog.show(context),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.edit, size: 14, color: AppTheme.secondary),
                      SizedBox(width: 2),
                      Text('수정',
                          style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.secondary,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(IconData icon, Color color, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 10),
          Text(label),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1줄: 자동 계산되는 주기 항목
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
          const SizedBox(height: 8),
          // 2줄: 직접 기록하는 항목 (약복용·주사·병원·임신·피임약)
          Wrap(
            spacing: 14,
            runSpacing: 8,
            children: [
              for (final m in kEventTypes.values) icon(m.icon, m.color, m.label),
              icon(pillMeta.icon, pillMeta.color, pillMeta.label),
            ],
          ),
        ],
      ),
    );
  }
}

/// 선택한 날짜의 모든 기록(생리 + 이벤트)을 목록으로 보여준다.
/// 항목을 탭하면 편집, 휴지통으로 삭제.
class _SelectedDayRecords extends ConsumerWidget {
  const _SelectedDayRecords({
    required this.day,
    required this.logs,
    required this.events,
    required this.periodLength,
  });

  final DateTime day;
  final List<CycleLog> logs;
  final List<DayEvent> events;
  final int periodLength;

  /// 이 날짜를 포함하는 생리 기록(있으면).
  CycleLog? _periodLogFor() {
    final d = DateCalc.dateOnly(day);
    for (final log in logs) {
      final start = DateCalc.dateOnly(log.startDate);
      final end = log.endDate != null
          ? DateCalc.dateOnly(log.endDate!)
          : start.add(Duration(days: periodLength - 1));
      if (!d.isBefore(start) && !d.isAfter(end)) return log;
    }
    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.read(databaseProvider);
    final pillSeq = ref.watch(pillSequenceProvider);
    final periodLog = _periodLogFor();
    final headerFmt = DateFormat('M월 d일 (E)', 'ko');

    // 이 날짜의 증상 태그(있으면).
    final allSymptoms = ref.watch(daySymptomsProvider).value ?? const [];
    final daySym = allSymptoms
        .where((s) => DateCalc.dateOnly(s.date) == DateCalc.dateOnly(day))
        .cast<DaySymptom?>()
        .firstOrNull;
    final hasAny =
        periodLog != null || events.isNotEmpty || daySym != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Text('${headerFmt.format(day)} 기록',
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ),
        if (!hasAny)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const Icon(Icons.edit_calendar, color: Colors.grey),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text('이 날의 기록이 없어요.\n+ 버튼으로 추가해 보세요.',
                        style: TextStyle(color: Colors.grey.shade600)),
                  ),
                ],
              ),
            ),
          ),
        // 생리 기록
        if (periodLog != null)
          Card(
            child: ListTile(
              onTap: () =>
                  AddCycleSheet.show(context, existing: periodLog),
              leading: const CircleAvatar(
                backgroundColor: AppTheme.period,
                child: Icon(Icons.water_drop, color: Colors.white, size: 20),
              ),
              title: const Text('생리'),
              subtitle: Text(_periodSubtitle(periodLog)),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () => db.deleteCycleLog(periodLog.id),
              ),
            ),
          ),
        // 증상 기록 (칩 선택) — 탭하면 수정, 휴지통으로 삭제
        if (daySym != null)
          Card(
            child: ListTile(
              onTap: () => SymptomPickerScreen.show(context, day),
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFEF9A9A),
                child: Icon(Icons.healing, color: Colors.white, size: 20),
              ),
              title: const Text('증상'),
              subtitle: Text(parseSymptoms(daySym.symptoms).join(', ')),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () => db.deleteDaySymptom(daySym.id),
              ),
            ),
          ),
        // 이벤트 기록 (약/주사/병원/임신/피임약)
        ...events.map((e) {
          final meta = eventMeta(e.type);
          final isPill = e.type == 'pill';
          // 피임약은 정 번호만, 그 외는 제목/메모/시간 표시.
          final String? subtitle;
          if (isPill) {
            final n = pillSeq[e.id];
            subtitle = n != null ? '$n정' : null;
          } else {
            final timeStr = typeUsesTime(e.type)
                ? DateFormat('a h:mm', 'ko').format(e.date)
                : null;
            final parts = [
              ?timeStr,
              if (e.title != null) e.title!,
              if (e.note != null) e.note!,
            ];
            subtitle = parts.isEmpty ? null : parts.join(' · ');
          }
          return Card(
            child: ListTile(
              onTap: isPill
                  ? () => PillSettingsDialog.show(context)
                  : (meta != null
                      ? () =>
                          AddEventSheet.show(context, type: e.type, existing: e)
                      : null),
              leading: CircleAvatar(
                backgroundColor: meta?.color ?? Colors.grey,
                child: Icon(meta?.icon ?? Icons.circle,
                    color: Colors.white, size: 20),
              ),
              title: Text(meta?.label ?? e.type),
              subtitle: subtitle != null ? Text(subtitle) : null,
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () => db.deleteDayEvent(e.id),
              ),
            ),
          );
        }),
      ],
    );
  }

  String _periodSubtitle(CycleLog log) {
    final flowLabel = switch (log.flow) {
      1 => '적음',
      3 => '많음',
      _ => '보통',
    };
    final duration = log.endDate != null
        ? '${DateCalc.daysBetween(log.startDate, log.endDate!) + 1}일'
        : '진행/미입력';
    return '$duration · 출혈량 $flowLabel'
        '${log.symptoms != null ? ' · ${log.symptoms}' : ''}';
  }
}
