import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/db/database.dart';
import '../../core/db/database_provider.dart';

/// 아기 프로필 등록 시트.
class RegisterBabySheet extends ConsumerStatefulWidget {
  const RegisterBabySheet({super.key});

  static Future<void> show(BuildContext context) => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) => const RegisterBabySheet(),
      );

  @override
  ConsumerState<RegisterBabySheet> createState() => _State();
}

class _State extends ConsumerState<RegisterBabySheet> {
  final _nameCtrl = TextEditingController();
  DateTime _birth = DateTime.now();
  String? _gender;

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_nameCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('아기 이름(태명)을 입력해 주세요')));
      return;
    }
    await ref.read(databaseProvider).insertBaby(BabyProfilesCompanion(
          name: Value(_nameCtrl.text.trim()),
          birthDate: Value(_birth),
          gender: Value(_gender),
        ));
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
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
          const Center(
            child: Text('아기 등록',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _nameCtrl,
            decoration: const InputDecoration(labelText: '이름 / 태명'),
          ),
          const SizedBox(height: 8),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.cake),
            title: const Text('생년월일'),
            trailing: Text(DateFormat('yyyy.MM.dd', 'ko').format(_birth)),
            onTap: () async {
              final p = await showDatePicker(
                context: context,
                initialDate: _birth,
                firstDate: DateTime(2015),
                lastDate: DateTime.now(),
              );
              if (p != null) setState(() => _birth = p);
            },
          ),
          const SizedBox(height: 8),
          const Text('성별 (선택)', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          SegmentedButton<String?>(
            emptySelectionAllowed: true,
            segments: const [
              ButtonSegment(value: 'male', label: Text('남아')),
              ButtonSegment(value: 'female', label: Text('여아')),
            ],
            selected: {_gender},
            onSelectionChanged: (s) =>
                setState(() => _gender = s.isEmpty ? null : s.first),
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
