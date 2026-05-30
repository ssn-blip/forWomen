import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/db/database.dart';
import '../../core/theme/app_theme.dart';
import '../baby/baby_providers.dart';
import '../conception/conception_providers.dart';
import '../cycle/cycle_providers.dart';
import '../cycle/day_event_types.dart';
import '../cycle/day_note_screen.dart';
import '../cycle/symptom_catalog.dart';
import '../pregnancy/pregnancy_providers.dart';

/// 모아보기용 통합 기록 항목.
class _Rec {
  const _Rec({
    required this.date,
    required this.icon,
    required this.color,
    required this.category,
    required this.title,
    this.subtitle,
  });

  final DateTime date;
  final IconData icon;
  final Color color;
  final String category; // '약 복용' | '예방접종' | '생리' | '증상' | ...
  final String title;
  final String? subtitle;
}

/// 모든 기록을 한 화면에서 리스트로 모아보는 화면 (전체 / 약 복용 / 예방접종).
class RecordsScreen extends ConsumerWidget {
  const RecordsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final all = _collect(ref)..sort((a, b) => b.date.compareTo(a.date));
    final meds = all.where((r) => r.category == '약 복용').toList();
    final vaccines = all.where((r) => r.category == '예방접종').toList();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('기록 모아보기'),
          bottom: const TabBar(
            tabs: [
              Tab(text: '전체'),
              Tab(text: '약 복용'),
              Tab(text: '예방접종'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _RecList(items: all, emptyHint: '아직 기록이 없어요.'),
            _RecList(
                items: meds, emptyHint: '약 복용 기록이 없어요.\n홈·주기·알림에서 복용을 체크해 보세요.'),
            _RecList(
                items: vaccines, emptyHint: '예방접종 기록이 없어요.\n육아 화면에서 접종을 체크해 보세요.'),
          ],
        ),
      ),
    );
  }

  /// 여러 테이블을 통합 항목 리스트로 수집.
  List<_Rec> _collect(WidgetRef ref) {
    final items = <_Rec>[];

    // 생리
    for (final l in ref.watch(cycleLogsProvider).value ?? const <CycleLog>[]) {
      final dur = l.endDate != null
          ? '${l.endDate!.difference(l.startDate).inDays + 1}일'
          : '진행/미입력';
      items.add(_Rec(
        date: l.startDate,
        icon: Icons.water_drop,
        color: AppTheme.period,
        category: '생리',
        title: '생리',
        subtitle: dur,
      ));
    }

    // 증상
    for (final s
        in ref.watch(daySymptomsProvider).value ?? const <DaySymptom>[]) {
      items.add(_Rec(
        date: s.date,
        icon: Icons.healing,
        color: const Color(0xFFEF9A9A),
        category: '증상',
        title: '증상',
        subtitle: parseSymptoms(s.symptoms).join(', '),
      ));
    }

    // 테스트 (임신/배란)
    for (final t in ref.watch(testLogsProvider).value ?? const <TestLog>[]) {
      final kindLabel = t.kind == 'pregnancy' ? '임신테스트' : '배란테스트';
      final resultLabel = switch (t.result) {
        'positive' => '양성',
        'faint' => '희미한 양성',
        'negative' => '음성',
        _ => '판독 불가',
      };
      items.add(_Rec(
        date: t.date,
        icon: Icons.science,
        color: const Color(0xFFBA68C8),
        category: '테스트',
        title: kindLabel,
        subtitle: resultLabel,
      ));
    }

    // 기초체온
    for (final b in ref.watch(bbtLogsProvider).value ?? const <BbtLog>[]) {
      items.add(_Rec(
        date: b.date,
        icon: Icons.thermostat,
        color: const Color(0xFFFF8A65),
        category: '기초체온',
        title: '기초체온',
        subtitle: '${b.temperature}℃',
      ));
    }

    // 체중
    for (final w
        in ref.watch(weightLogsProvider).value ?? const <WeightLog>[]) {
      items.add(_Rec(
        date: w.date,
        icon: Icons.monitor_weight,
        color: const Color(0xFF90A4AE),
        category: '체중',
        title: '체중',
        subtitle: '${w.weightKg}kg',
      ));
    }

    // 하루 노트
    for (final n in ref.watch(dayNotesProvider).value ?? const <DayNote>[]) {
      final parts = [
        if (n.weather != null)
          kWeathers
                  .where((w) => w.key == n.weather)
                  .map((w) => w.label)
                  .firstOrNull ??
              '',
        if ((n.memo ?? '').isNotEmpty) n.memo!,
      ].where((e) => e.isNotEmpty).toList();
      items.add(_Rec(
        date: n.date,
        icon: Icons.edit_note,
        color: const Color(0xFF7E57C2),
        category: '노트',
        title: '노트',
        subtitle: parts.isEmpty ? '날씨·기분 기록' : parts.join(' · '),
      ));
    }

    // 캘린더 이벤트 (약/주사/병원/임신/피임약)
    for (final e in ref.watch(dayEventsProvider).value ?? const <DayEvent>[]) {
      final meta = eventMeta(e.type);
      final isMed = e.type == 'medication';
      final timeStr = typeUsesTime(e.type)
          ? DateFormat('a h:mm', 'ko').format(e.date)
          : null;
      final parts = [
        ?timeStr,
        if (e.title != null) e.title!,
        if (e.note != null) e.note!,
      ];
      items.add(_Rec(
        date: e.date,
        icon: meta?.icon ?? Icons.event,
        color: meta?.color ?? Colors.grey,
        category: isMed ? '약 복용' : (meta?.label ?? e.type),
        title: meta?.label ?? e.type,
        subtitle: parts.isEmpty ? null : parts.join(' · '),
      ));
    }

    // 예방접종 (아기 이름 표시)
    final babies = ref.watch(babiesProvider).value ?? const <BabyProfile>[];
    final babyName = {for (final b in babies) b.id: b.name};
    for (final v
        in ref.watch(allVaccinationsProvider).value ?? const <VaccinationRecord>[]) {
      final who = babyName[v.babyId];
      items.add(_Rec(
        date: v.doneDate,
        icon: Icons.vaccines,
        color: const Color(0xFF4DB6AC),
        category: '예방접종',
        title: v.name,
        subtitle: who != null ? '$who 접종 완료' : '접종 완료',
      ));
    }

    return items;
  }
}

class _RecList extends StatelessWidget {
  const _RecList({required this.items, required this.emptyHint});

  final List<_Rec> items;
  final String emptyHint;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(emptyHint,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600)),
        ),
      );
    }
    final dateFmt = DateFormat('yyyy.MM.dd (E)', 'ko');
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: 4),
      itemBuilder: (context, i) {
        final r = items[i];
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: r.color.withValues(alpha: 0.18),
              child: Icon(r.icon, color: r.color, size: 20),
            ),
            title: Text(r.title,
                style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text([
              dateFmt.format(r.date),
              if (r.subtitle != null) r.subtitle!,
            ].join('  ·  ')),
            trailing: Text(r.category,
                style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.bold)),
          ),
        );
      },
    );
  }
}
