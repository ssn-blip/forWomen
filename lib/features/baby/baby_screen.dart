import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/db/database.dart';
import '../../core/db/database_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/date_calc.dart';
import 'baby_providers.dart';
import 'register_baby_sheet.dart';
import 'vaccine_schedule.dart';

class BabyScreen extends ConsumerWidget {
  const BabyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final baby = ref.watch(activeBabyProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('육아')),
      body: baby == null
          ? const _NoBaby()
          : _BabyDashboard(baby: baby),
    );
  }
}

class _NoBaby extends StatelessWidget {
  const _NoBaby();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.child_care, size: 72, color: AppTheme.primary),
            const SizedBox(height: 16),
            const Text('아기를 등록해 주세요',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('수유·기저귀·예방접종을 기록하고 관리할 수 있어요',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600)),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => RegisterBabySheet.show(context),
              icon: const Icon(Icons.add),
              label: const Text('아기 등록'),
            ),
          ],
        ),
      ),
    );
  }
}

class _BabyDashboard extends ConsumerWidget {
  const _BabyDashboard({required this.baby});

  final BabyProfile baby;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedings = ref.watch(feedingsProvider(baby.id)).value ?? const [];
    final diapers = ref.watch(diapersProvider(baby.id)).value ?? const [];
    final today = DateCalc.dateOnly(DateTime.now());
    final todayFeedings =
        feedings.where((f) => DateCalc.dateOnly(f.time) == today).length;
    final todayDiapers =
        diapers.where((d) => DateCalc.dateOnly(d.time) == today).length;

    return ListView(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
      children: [
        _ProfileCard(baby: baby),
        Row(
          children: [
            Expanded(
              child: _CountCard(
                  label: '오늘 수유', count: todayFeedings, icon: Icons.local_drink),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _CountCard(
                  label: '오늘 기저귀', count: todayDiapers, icon: Icons.baby_changing_station),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text('빠른 기록',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        _QuickFeeding(babyId: baby.id),
        const SizedBox(height: 6),
        _QuickDiaper(babyId: baby.id),
        const SizedBox(height: 16),
        _RecentActivity(feedings: feedings, diapers: diapers),
        const SizedBox(height: 16),
        const Text('예방접종',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 4),
        _VaccinationList(babyId: baby.id),
      ],
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.baby});

  final BabyProfile baby;

  @override
  Widget build(BuildContext context) {
    final days = DateCalc.daysBetween(baby.birthDate, DateTime.now());
    final months = days ~/ 30;
    final ageLabel = days < 0
        ? '출생 예정'
        : (months < 1 ? '$days일' : '$months개월 ($days일)');
    final emoji = baby.gender == 'male'
        ? '👦'
        : baby.gender == 'female'
            ? '👧'
            : '👶';

    return Card(
      color: AppTheme.accent.withValues(alpha: 0.18),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white,
              child: Text(emoji, style: const TextStyle(fontSize: 30)),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(baby.name,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('생후 $ageLabel',
                    style: TextStyle(color: Colors.grey.shade700)),
                Text(
                    DateFormat('yyyy.MM.dd 출생', 'ko').format(baby.birthDate) +
                        (baby.birthWeightKg != null
                            ? ' · ${baby.birthWeightKg}kg'
                            : ''),
                    style: TextStyle(
                        color: Colors.grey.shade600, fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CountCard extends StatelessWidget {
  const _CountCard(
      {required this.label, required this.count, required this.icon});

  final String label;
  final int count;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Icon(icon, color: AppTheme.secondary),
            const SizedBox(height: 6),
            Text('$count회',
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold)),
            Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class _QuickFeeding extends ConsumerWidget {
  const _QuickFeeding({required this.babyId});

  final int babyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> log(String type) async {
      await ref.read(databaseProvider).insertFeeding(FeedingLogsCompanion(
            babyId: Value(babyId),
            time: Value(DateTime.now()),
            type: Value(type),
          ));
    }

    return Row(
      children: [
        _ActionChip(label: '모유', icon: Icons.favorite, onTap: () => log('breast')),
        _ActionChip(label: '분유', icon: Icons.local_drink, onTap: () => log('bottle')),
        _ActionChip(label: '이유식', icon: Icons.restaurant, onTap: () => log('solid')),
      ],
    );
  }
}

class _QuickDiaper extends ConsumerWidget {
  const _QuickDiaper({required this.babyId});

  final int babyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> log(String type) async {
      await ref.read(databaseProvider).insertDiaper(DiaperLogsCompanion(
            babyId: Value(babyId),
            time: Value(DateTime.now()),
            type: Value(type),
          ));
    }

    return Row(
      children: [
        _ActionChip(label: '소변', icon: Icons.water_drop, onTap: () => log('wet')),
        _ActionChip(label: '대변', icon: Icons.eco, onTap: () => log('dirty')),
        _ActionChip(label: '둘다', icon: Icons.cyclone, onTap: () => log('both')),
      ],
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip(
      {required this.label, required this.icon, required this.onTap});

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: OutlinedButton.icon(
          onPressed: () {
            onTap();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('$label 기록됨'), duration: const Duration(milliseconds: 700)),
            );
          },
          icon: Icon(icon, size: 18),
          label: Text(label),
          style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
        ),
      ),
    );
  }
}

class _RecentActivity extends ConsumerWidget {
  const _RecentActivity({required this.feedings, required this.diapers});

  final List<FeedingLog> feedings;
  final List<DiaperLog> diapers;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 수유+기저귀를 시간순으로 병합 (최근 8개).
    final items = <({DateTime time, String label, IconData icon, void Function() delete})>[];
    final db = ref.read(databaseProvider);
    for (final f in feedings) {
      final t = switch (f.type) {
        'breast' => '모유 수유',
        'bottle' => '분유 수유',
        _ => '이유식',
      };
      items.add((time: f.time, label: t, icon: Icons.local_drink, delete: () => db.deleteFeeding(f.id)));
    }
    for (final d in diapers) {
      final t = switch (d.type) {
        'wet' => '기저귀(소변)',
        'dirty' => '기저귀(대변)',
        _ => '기저귀(둘다)',
      };
      items.add((time: d.time, label: t, icon: Icons.baby_changing_station, delete: () => db.deleteDiaper(d.id)));
    }
    items.sort((a, b) => b.time.compareTo(a.time));

    if (items.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text('아직 기록이 없어요. 위 버튼으로 빠르게 기록해 보세요.',
              style: TextStyle(color: Colors.grey)),
        ),
      );
    }

    final fmt = DateFormat('M/d a h:mm', 'ko');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('최근 활동',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 4),
        ...items.take(8).map((it) => Card(
              child: ListTile(
                dense: true,
                leading: Icon(it.icon, color: AppTheme.secondary),
                title: Text(it.label),
                subtitle: Text(fmt.format(it.time)),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, size: 20),
                  onPressed: it.delete,
                ),
              ),
            )),
      ],
    );
  }
}

class _VaccinationList extends ConsumerWidget {
  const _VaccinationList({required this.babyId});

  final int babyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final records = ref.watch(vaccinationsProvider(babyId)).value ?? const {};
    final db = ref.read(databaseProvider);

    return Column(
      children: kVaccineSchedule.map((v) {
        final record = records[v.name];
        final done = record != null;
        return Card(
          child: CheckboxListTile(
            dense: true,
            value: done,
            title: Text(v.name,
                style: TextStyle(
                  decoration: done ? TextDecoration.lineThrough : null,
                )),
            subtitle: Text(done
                ? '완료 · ${DateFormat('yyyy.MM.dd', 'ko').format(record.doneDate)}'
                : v.ageLabel),
            onChanged: (checked) async {
              if (checked == true) {
                await db.insertVaccination(VaccinationRecordsCompanion(
                  babyId: Value(babyId),
                  name: Value(v.name),
                  doneDate: Value(DateTime.now()),
                ));
              } else {
                await db.deleteVaccinationByName(babyId, v.name);
              }
            },
          ),
        );
      }).toList(),
    );
  }
}
