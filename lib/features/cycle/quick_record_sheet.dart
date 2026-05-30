import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/db/database.dart';
import '../../core/db/database_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/date_calc.dart';
import '../conception/add_test_sheet.dart';
import '../conception/conception_providers.dart';
import 'add_event_sheet.dart';
import 'cycle_providers.dart';
import 'day_event_types.dart';
import 'pill_settings_dialog.dart';
import 'symptom_catalog.dart';
import 'symptom_picker_screen.dart';

/// 선택한 날짜의 모든 기록을 한 화면에서 입력하는 "한방에 작성" 시트.
class QuickRecordSheet extends ConsumerWidget {
  const QuickRecordSheet({super.key, required this.date});

  final DateTime date;

  static Future<void> show(BuildContext context, DateTime date) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => QuickRecordSheet(date: DateCalc.dateOnly(date)),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.read(databaseProvider);
    final day = date;

    final logs = ref.watch(cycleLogsProvider).value ?? const [];
    final events = ref.watch(dayEventsProvider).value ?? const [];
    final symptoms = ref.watch(daySymptomsProvider).value ?? const [];
    final bbts = ref.watch(bbtLogsProvider).value ?? const [];
    final tests = ref.watch(testLogsProvider).value ?? const [];

    bool sameDay(DateTime d) => DateCalc.dateOnly(d) == day;

    // 현재 상태 파악
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
    final bbt =
        bbts.where((b) => sameDay(b.date)).cast<BbtLog?>().firstOrNull;
    final dayEventsOf = events.where((e) => sameDay(e.date)).toList();
    bool hasEvent(String type) => dayEventsOf.any((e) => e.type == type);
    final pregTest = tests.any((t) => t.kind == 'pregnancy' && sameDay(t.date));
    final ovuTest = tests.any((t) => t.kind == 'ovulation' && sameDay(t.date));

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
        // day를 포함/이전에 시작했고 아직 종료 안 한 가장 최근 생리 기록에 종료일 지정.
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

    final headerFmt = DateFormat('M월 d일 (E)', 'ko');

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 헤더
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 8, 4),
              child: Row(
                children: [
                  Text('${headerFmt.format(day)} 기록',
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
            Flexible(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.only(bottom: 12),
                children: [
                  // 생리 시작/종료 (체크)
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
                  // 증상 (칩 선택)
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
                  // 임신/배란 테스트
                  _PlusRow(
                    icon: Icons.science,
                    color: const Color(0xFFBA68C8),
                    label: '임신테스트',
                    done: pregTest,
                    onTap: () =>
                        AddTestSheet.show(context, kind: 'pregnancy'),
                  ),
                  _PlusRow(
                    icon: Icons.science_outlined,
                    color: const Color(0xFF4DB6AC),
                    label: '배란테스트',
                    done: ovuTest,
                    onTap: () =>
                        AddTestSheet.show(context, kind: 'ovulation'),
                  ),
                  // 기초체온
                  _PlusRow(
                    icon: Icons.thermostat,
                    color: const Color(0xFFFF8A65),
                    label: '기초체온',
                    detail: bbt != null ? '${bbt.temperature}℃' : null,
                    onTap: editTemp,
                  ),
                  // 약/주사/병원/임신 이벤트
                  for (final meta in kEventTypes.values)
                    _PlusRow(
                      icon: meta.icon,
                      color: meta.color,
                      label: meta.label,
                      done: hasEvent(meta.key),
                      onTap: () => AddEventSheet.show(context,
                          type: meta.key, initialDate: day),
                    ),
                  // 피임약
                  _PlusRow(
                    icon: pillMeta.icon,
                    color: pillMeta.color,
                    label: pillMeta.label,
                    done: hasEvent('pill'),
                    onTap: () =>
                        PillSettingsDialog.show(context, initialDate: day),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 체크박스 행 (생리 시작/종료).
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

/// 숫자 입력 다이얼로그(기초체온/체중 등). 확인 시 double 반환, 취소 시 null.
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
