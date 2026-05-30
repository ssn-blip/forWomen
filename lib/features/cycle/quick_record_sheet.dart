import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/db/database.dart';
import '../../core/db/database_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/date_calc.dart';
import '../../core/widgets/sheet_header.dart';
import '../conception/add_test_sheet.dart';
import '../conception/conception_providers.dart';
import 'add_event_sheet.dart';
import 'cycle_providers.dart';
import 'day_event_types.dart';
import 'day_note_screen.dart';
import 'pill_settings_dialog.dart';
import 'symptom_catalog.dart';
import 'symptom_picker_screen.dart';

/// 선택한 날짜의 기록 항목(생리·증상·테스트·이벤트 등)을 토글/입력하는 목록.
/// 주기 화면의 상시 하단 패널과 [QuickRecordSheet] 모달에서 공유한다.
///
/// [scrollController]가 주어지면(= DraggableScrollableSheet 안) 그 컨트롤러로
/// 스크롤해 시트 확장/축소를 구동한다. 없으면(모달) shrinkWrap으로 동작.
class DayRecordList extends ConsumerWidget {
  const DayRecordList({
    super.key,
    required this.date,
    this.scrollController,
    this.padding,
  });

  final DateTime date;
  final ScrollController? scrollController;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.read(databaseProvider);
    final day = DateCalc.dateOnly(date);

    final logs = ref.watch(cycleLogsProvider).value ?? const [];
    final events = ref.watch(dayEventsProvider).value ?? const [];
    final symptoms = ref.watch(daySymptomsProvider).value ?? const [];
    final bbts = ref.watch(bbtLogsProvider).value ?? const [];
    final tests = ref.watch(testLogsProvider).value ?? const [];
    final notes = ref.watch(dayNotesProvider).value ?? const [];

    bool sameDay(DateTime d) => DateCalc.dateOnly(d) == day;

    final periodStart =
        logs.where((l) => sameDay(l.startDate)).cast<CycleLog?>().firstOrNull;
    final periodEnd = logs
        .where((l) => l.endDate != null && sameDay(l.endDate!))
        .cast<CycleLog?>()
        .firstOrNull;
    final daySym = symptoms
        .where((s) => sameDay(s.date))
        .cast<DaySymptom?>()
        .firstOrNull;
    final symTags = parseSymptoms(daySym?.symptoms);
    final bbt = bbts.where((b) => sameDay(b.date)).cast<BbtLog?>().firstOrNull;
    final dayEventsOf = events.where((e) => sameDay(e.date)).toList();
    bool hasEvent(String type) => dayEventsOf.any((e) => e.type == type);
    final pregTest = tests.any((t) => t.kind == 'pregnancy' && sameDay(t.date));
    final ovuTest = tests.any((t) => t.kind == 'ovulation' && sameDay(t.date));
    final dayNote =
        notes.where((n) => sameDay(n.date)).cast<DayNote?>().firstOrNull;
    final hasNote = dayNote != null &&
        ((dayNote.memo ?? '').isNotEmpty ||
            dayNote.weather != null ||
            dayNote.mood != null);

    // 생리 시작 체크 토글
    Future<void> togglePeriodStart(bool on) async {
      if (on) {
        await db.insertCycleLog(CycleLogsCompanion(startDate: Value(day)));
      } else if (periodStart != null) {
        await db.deleteCycleLog(periodStart.id);
      }
    }

    // 생리 종료 체크 토글
    Future<void> togglePeriodEnd(bool on) async {
      if (on) {
        final candidates = logs
            .where((l) =>
                !DateCalc.dateOnly(l.startDate).isAfter(day) &&
                l.endDate == null)
            .toList()
          ..sort((a, b) => b.startDate.compareTo(a.startDate));
        final target = candidates.firstOrNull;
        if (target != null) {
          await db.updateCycleLog(target.copyWith(endDate: Value(day)));
        }
      } else if (periodEnd != null) {
        await db
            .updateCycleLog(periodEnd.copyWith(endDate: const Value(null)));
      }
    }

    Future<void> editTemp() async {
      final v = await _numberDialog(context,
          title: '기초체온',
          hint: '예: 36.7',
          suffix: '℃',
          initial: bbt?.temperature.toString());
      if (v == null) return;
      if (bbt != null) {
        await db.updateBbtLog(bbt.copyWith(temperature: v));
      } else {
        await db.insertBbtLog(
            BbtLogsCompanion(date: Value(day), temperature: Value(v)));
      }
    }

    return ListView(
      controller: scrollController,
      physics: scrollController != null
          ? const AlwaysScrollableScrollPhysics()
          : null,
      shrinkWrap: scrollController == null,
      padding: padding ?? const EdgeInsets.only(bottom: 24),
      children: [
        _CheckRow(
          icon: Icons.water_drop,
          color: AppTheme.period,
          label: '생리 시작',
          value: periodStart != null,
          onChanged: togglePeriodStart,
        ),
        _CheckRow(
          icon: Icons.water_drop_outlined,
          color: AppTheme.period,
          label: '생리 종료',
          value: periodEnd != null,
          onChanged: togglePeriodEnd,
        ),
        _PlusRow(
          icon: Icons.healing,
          color: const Color(0xFFEF9A9A),
          label: '증상',
          detail: symTags.isEmpty
              ? null
              : (symTags.length <= 3
                  ? symTags.join(', ')
                  : '${symTags.take(3).join(', ')} 외 ${symTags.length - 3}'),
          onTap: () => SymptomPickerScreen.show(context, day),
        ),
        _PlusRow(
          icon: Icons.science,
          color: const Color(0xFFBA68C8),
          label: '임신테스트',
          done: pregTest,
          onTap: () => AddTestSheet.show(context, kind: 'pregnancy'),
        ),
        _PlusRow(
          icon: Icons.science_outlined,
          color: const Color(0xFF4DB6AC),
          label: '배란테스트',
          done: ovuTest,
          onTap: () => AddTestSheet.show(context, kind: 'ovulation'),
        ),
        _PlusRow(
          icon: Icons.thermostat,
          color: const Color(0xFFFF8A65),
          label: '기초체온',
          detail: bbt != null ? '${bbt.temperature}℃' : null,
          onTap: editTemp,
        ),
        _CheckRow(
          icon: Icons.favorite,
          color: const Color(0xFFF06292),
          label: '사랑',
          value: hasEvent('love'),
          onChanged: (on) async {
            if (on) {
              await db.insertDayEvent(DayEventsCompanion(
                date: Value(day),
                type: const Value('love'),
              ));
            } else {
              for (final e in dayEventsOf.where((e) => e.type == 'love')) {
                await db.deleteDayEvent(e.id);
              }
            }
          },
        ),
        for (final meta in kEventTypes.values)
          if (meta.key != 'love')
            _PlusRow(
              icon: meta.icon,
              color: meta.color,
              label: meta.label,
              done: hasEvent(meta.key),
              // 기록이 있으면 관리(수정·삭제·추가) 시트, 없으면 바로 추가.
              onTap: () => hasEvent(meta.key)
                  ? _EventManageSheet.show(context, type: meta.key, day: day)
                  : AddEventSheet.show(context,
                      type: meta.key, initialDate: day),
            ),
        _PlusRow(
          icon: pillMeta.icon,
          color: pillMeta.color,
          label: pillMeta.label,
          done: hasEvent('pill'),
          onTap: () => PillSettingsDialog.show(context, initialDate: day),
        ),
        _PlusRow(
          icon: Icons.edit_note,
          color: const Color(0xFF7E57C2),
          label: '노트',
          detail: hasNote ? (dayNote.memo ?? '날씨·기분 기록됨') : null,
          onTap: () => DayNoteScreen.show(context, day),
        ),
      ],
    );
  }
}

/// 선택한 날짜의 모든 기록을 한 화면에서 입력하는 "한방에 작성" 모달 시트.
/// (주기 화면은 상시 패널을 쓰지만, 다른 진입점을 위해 모달 형태도 유지한다.)
class QuickRecordSheet extends StatelessWidget {
  const QuickRecordSheet({super.key, required this.date});

  final DateTime date;

  static Future<void> show(BuildContext context, DateTime date) {
    final maxH = MediaQuery.of(context).size.height * 0.72;
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      constraints: BoxConstraints(maxHeight: maxH),
      builder: (_) => QuickRecordSheet(date: DateCalc.dateOnly(date)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final headerFmt = DateFormat('M월 d일 (E)', 'ko');
    return SafeArea(
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 8, 4),
              child: Row(
                children: [
                  Text('${headerFmt.format(date)} 기록',
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Flexible(child: DayRecordList(date: date)),
          ],
        ),
      ),
    );
  }
}

/// 특정 날짜·종류(약/주사/병원/임신)의 기록을 관리하는 시트.
/// 목록에서 탭하면 수정, 휴지통으로 삭제, 하단 버튼으로 추가.
class _EventManageSheet extends ConsumerWidget {
  const _EventManageSheet({required this.type, required this.day});

  final String type;
  final DateTime day;

  static Future<void> show(BuildContext context,
      {required String type, required DateTime day}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _EventManageSheet(type: type, day: day),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final meta = eventMeta(type)!;
    final db = ref.read(databaseProvider);
    final all = ref.watch(dayEventsProvider).value ?? const [];
    final items = all
        .where((e) =>
            e.type == type &&
            DateCalc.dateOnly(e.date) == DateCalc.dateOnly(day))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    String? subtitleOf(DayEvent e) {
      final parts = <String>[
        if (typeUsesTime(type)) DateFormat('a h:mm', 'ko').format(e.date),
        if (e.note != null && e.note!.isNotEmpty) e.note!,
      ];
      return parts.isEmpty ? null : parts.join(' · ');
    }

    return SafeArea(
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: SheetHeader(
                title: '${meta.label} 기록',
                icon: meta.icon,
                iconColor: meta.color,
              ),
            ),
            const Divider(height: 1),
            if (items.isEmpty)
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text('이 날의 ${meta.label} 기록이 없어요.',
                    style: TextStyle(color: Colors.grey.shade600)),
              )
            else
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: items.map((e) {
                    final subtitle = subtitleOf(e);
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: meta.color.withValues(alpha: 0.18),
                        child: Icon(meta.icon, color: meta.color, size: 20),
                      ),
                      title: Text(
                          (e.title?.isNotEmpty ?? false) ? e.title! : meta.label),
                      subtitle: subtitle != null ? Text(subtitle) : null,
                      onTap: () {
                        Navigator.pop(context);
                        AddEventSheet.show(context, type: type, existing: e);
                      },
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        tooltip: '삭제',
                        onPressed: () => db.deleteDayEvent(e.id),
                      ),
                    );
                  }).toList(),
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    AddEventSheet.show(context, type: type, initialDate: day);
                  },
                  icon: const Icon(Icons.add),
                  label: Text('${meta.label} 추가'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 체크박스 행 (생리 시작/종료·사랑).
class _CheckRow extends StatelessWidget {
  const _CheckRow({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final Color color;
  final String label;
  final bool value;
  final Future<void> Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withValues(alpha: 0.18),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(label),
      trailing: Checkbox(
        value: value,
        onChanged: (v) => onChanged(v ?? false),
        activeColor: AppTheme.primary,
        shape: const CircleBorder(),
      ),
      onTap: () => onChanged(!value),
    );
  }
}

/// + 버튼 행 (탭하면 입력 화면). detail/done으로 현재 상태 표시.
class _PlusRow extends StatelessWidget {
  const _PlusRow({
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
    this.detail,
    this.done = false,
  });

  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;
  final String? detail;
  final bool done;

  @override
  Widget build(BuildContext context) {
    final hasState = detail != null || done;
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withValues(alpha: 0.18),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(label),
      subtitle: detail != null ? Text(detail!) : null,
      trailing: Icon(
        hasState ? Icons.check_circle : Icons.add_circle_outline,
        color: hasState ? AppTheme.primary : Colors.grey.shade400,
      ),
      onTap: onTap,
    );
  }
}

/// 숫자 입력 다이얼로그(기초체온 등). 확인 시 double 반환, 취소 시 null.
Future<double?> _numberDialog(
  BuildContext context, {
  required String title,
  required String hint,
  required String suffix,
  String? initial,
}) {
  final ctrl = TextEditingController(text: initial ?? '');
  return showDialog<double?>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: TextField(
        controller: ctrl,
        autofocus: true,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(hintText: hint, suffixText: suffix),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('취소'),
        ),
        FilledButton(
          onPressed: () {
            final v = double.tryParse(ctrl.text.trim());
            Navigator.pop(ctx, v);
          },
          child: const Text('저장'),
        ),
      ],
    ),
  );
}
