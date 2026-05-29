import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/db/database.dart';
import '../../core/db/database_provider.dart';

/// 기초체온 입력/편집 시트. [existing]이 있으면 편집 모드.
class AddBbtSheet extends ConsumerStatefulWidget {
  const AddBbtSheet({super.key, this.existing});

  final BbtLog? existing;

  static Future<void> show(BuildContext context, {BbtLog? existing}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => AddBbtSheet(existing: existing),
    );
  }

  @override
  ConsumerState<AddBbtSheet> createState() => _State();
}

class _State extends ConsumerState<AddBbtSheet> {
  late DateTime _date;
  late final TextEditingController _tempCtrl;

  bool get _isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _date = e?.date ?? DateTime.now();
    _tempCtrl = TextEditingController(
        text: e != null ? e.temperature.toString() : '36.5');
  }

  @override
  void dispose() {
    _tempCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final temp = double.tryParse(_tempCtrl.text.trim());
    if (temp == null || temp < 34 || temp > 42) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('34~42 사이의 체온을 입력해 주세요')));
      return;
    }
    final db = ref.read(databaseProvider);
    final e = widget.existing;
    if (e != null) {
      await db.updateBbtLog(e.copyWith(date: _date, temperature: temp));
    } else {
      await db.insertBbtLog(BbtLogsCompanion(
        date: Value(_date),
        temperature: Value(temp),
      ));
    }
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
          Center(
            child: Text(_isEditing ? '기초체온 수정' : '기초체온 기록',
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 16),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.calendar_today),
            title: const Text('측정일'),
            trailing: Text(DateFormat('yyyy.MM.dd', 'ko').format(_date)),
            onTap: () async {
              final p = await showDatePicker(
                context: context,
                initialDate: _date,
                firstDate: DateTime(2015),
                lastDate: DateTime.now(),
              );
              if (p != null) setState(() => _date = p);
            },
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _tempCtrl,
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
            ],
            decoration: const InputDecoration(
              labelText: '체온 (℃)',
              suffixText: '℃',
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton(onPressed: _save, child: const Text('저장')),
          ),
        ],
      ),
    );
  }
}
