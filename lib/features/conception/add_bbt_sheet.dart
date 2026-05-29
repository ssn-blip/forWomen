import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/db/database.dart';
import '../../core/db/database_provider.dart';

/// 기초체온 입력 시트.
class AddBbtSheet extends ConsumerStatefulWidget {
  const AddBbtSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const AddBbtSheet(),
    );
  }

  @override
  ConsumerState<AddBbtSheet> createState() => _State();
}

class _State extends ConsumerState<AddBbtSheet> {
  DateTime _date = DateTime.now();
  final _tempCtrl = TextEditingController(text: '36.5');

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
    await ref.read(databaseProvider).insertBbtLog(BbtLogsCompanion(
          date: Value(_date),
          temperature: Value(temp),
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
            child: Text('기초체온 기록',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
