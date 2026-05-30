import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/db/database.dart';
import '../../core/db/database_provider.dart';
import '../../core/utils/date_calc.dart';
import '../../core/widgets/sheet_header.dart';

/// 임신 등록 시트. 마지막 생리 시작일을 받아 출산예정일을 자동 계산한다.
class RegisterPregnancySheet extends ConsumerStatefulWidget {
  const RegisterPregnancySheet({super.key});

  /// 저장(등록)하면 true, 그냥 닫으면 null을 반환한다.
  static Future<bool?> show(BuildContext context) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const RegisterPregnancySheet(),
    );
  }

  @override
  ConsumerState<RegisterPregnancySheet> createState() => _State();
}

class _State extends ConsumerState<RegisterPregnancySheet> {
  DateTime _lmp = DateTime.now().subtract(const Duration(days: 28));
  DateTime? _dueOverride;

  Future<void> _save() async {
    final db = ref.read(databaseProvider);
    // 중복 활성 임신 방지: 기존 진행 중 임신을 먼저 종료.
    await db.endActivePregnancies();
    await db.insertPregnancy(PregnanciesCompanion(
          lastPeriodStart: Value(_lmp),
          dueDateOverride: Value(_dueOverride),
          status: const Value('active'),
          createdAt: Value(DateTime.now()),
        ));
    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('yyyy.MM.dd (E)', 'ko');
    final due = _dueOverride ?? DateCalc.dueDate(_lmp);
    final age = DateCalc.gestationalAge(_lmp, DateTime.now());

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SheetHeader(title: '임신 등록'),
          const SizedBox(height: 16),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.event),
            title: const Text('마지막 생리 시작일'),
            subtitle: const Text('주차·출산예정일 계산 기준'),
            trailing: Text(fmt.format(_lmp)),
            onTap: () async {
              final p = await showDatePicker(
                context: context,
                initialDate: _lmp,
                firstDate: DateTime.now().subtract(const Duration(days: 300)),
                lastDate: DateTime.now(),
              );
              if (p != null) setState(() => _lmp = p);
            },
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.child_friendly),
            title: const Text('출산 예정일'),
            subtitle: Text(_dueOverride == null ? '자동 계산됨 (LMP+280일)' : '직접 지정'),
            trailing: Text(DateFormat('yyyy.MM.dd', 'ko').format(due)),
            onTap: () async {
              final p = await showDatePicker(
                context: context,
                initialDate: due,
                firstDate: _lmp,
                lastDate: _lmp.add(const Duration(days: 320)),
              );
              if (p != null) setState(() => _dueOverride = p);
            },
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.pink.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text('현재 임신 ${age.week}주 ${age.day}일차로 계산돼요 💕',
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton(onPressed: _save, child: const Text('등록')),
          ),
        ],
      ),
    );
  }
}
