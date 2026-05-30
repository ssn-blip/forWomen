import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/db/database.dart';
import '../../core/db/database_provider.dart';
import '../../core/widgets/sheet_header.dart';

/// 출산 기록 시트. 출산 정보를 입력하면 아기 프로필을 만들고
/// 진행 중이던 임신을 완료 상태로 전환한다.
class BirthRecordSheet extends ConsumerStatefulWidget {
  const BirthRecordSheet({super.key, this.pregnancy});

  /// 완료 처리할 진행 중 임신 (없으면 임신 상태 변경은 생략).
  final Pregnancy? pregnancy;

  static Future<void> show(BuildContext context, {Pregnancy? pregnancy}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => BirthRecordSheet(pregnancy: pregnancy),
    );
  }

  @override
  ConsumerState<BirthRecordSheet> createState() => _State();
}

class _State extends ConsumerState<BirthRecordSheet> {
  final _nameCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  DateTime _birthDate = DateTime.now();
  String? _gender;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _weightCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_nameCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('아기 이름을 입력해 주세요')));
      return;
    }
    final db = ref.read(databaseProvider);
    final weight = double.tryParse(_weightCtrl.text.trim());

    await db.insertBaby(BabyProfilesCompanion(
      name: Value(_nameCtrl.text.trim()),
      birthDate: Value(_birthDate),
      gender: Value(_gender),
      birthWeightKg: Value(weight),
      birthNote: Value(
          _noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim()),
    ));

    // 진행 중이던 임신을 완료로 전환.
    final preg = widget.pregnancy;
    if (preg != null) {
      await db.updatePregnancy(preg.copyWith(status: 'completed'));
    }

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('출산을 축하드려요! 육아 기록을 시작할 수 있어요 🎉')),
      );
    }
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
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SheetHeader(title: '출산 기록'),
            const SizedBox(height: 16),
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: '아기 이름'),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.cake),
              title: const Text('출산일'),
              trailing:
                  Text(DateFormat('yyyy.MM.dd', 'ko').format(_birthDate)),
              onTap: () async {
                final p = await showDatePicker(
                  context: context,
                  initialDate: _birthDate,
                  firstDate: DateTime(2015),
                  lastDate: DateTime.now(),
                );
                if (p != null) setState(() => _birthDate = p);
              },
            ),
            const SizedBox(height: 4),
            const Text('성별', style: TextStyle(fontWeight: FontWeight.bold)),
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
            const SizedBox(height: 12),
            TextField(
              controller: _weightCtrl,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
              ],
              decoration: const InputDecoration(
                  labelText: '출생 체중 (kg, 선택사항)', suffixText: 'kg'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _noteCtrl,
              decoration: const InputDecoration(
                  labelText: '메모 (분만 방법, 신장 등 선택사항)'),
              maxLines: 2,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                  onPressed: _save, child: const Text('출산 기록 저장')),
            ),
          ],
        ),
      ),
    );
  }
}
