import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/db/database_provider.dart';
import '../../core/theme/app_theme.dart';
import 'symptom_catalog.dart';

/// 증상 칩 다중 선택 화면. 카테고리별로 칩을 눌러 선택/해제하고 완료로 저장.
class SymptomPickerScreen extends ConsumerStatefulWidget {
  const SymptomPickerScreen({super.key, required this.date});

  final DateTime date;

  static Future<void> show(BuildContext context, DateTime date) {
    return Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => SymptomPickerScreen(date: date)),
    );
  }

  @override
  ConsumerState<SymptomPickerScreen> createState() => _State();
}

class _State extends ConsumerState<SymptomPickerScreen> {
  final Set<String> _selected = {};
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final existing =
        await ref.read(databaseProvider).getDaySymptom(widget.date);
    if (!mounted) return;
    setState(() {
      _selected.addAll(parseSymptoms(existing?.symptoms));
      _loaded = true;
    });
  }

  Future<void> _save() async {
    await ref
        .read(databaseProvider)
        .setDaySymptoms(widget.date, joinSymptoms(_selected));
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('M월 d일 (E)', 'ko').format(widget.date);
    return Scaffold(
      appBar: AppBar(
        title: const Text('증상'),
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text('완료',
                style: TextStyle(
                    color: AppTheme.primary, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: !_loaded
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
              children: [
                Text('$dateStr · ${_selected.length}개 선택',
                    style: TextStyle(color: Colors.grey.shade600)),
                const SizedBox(height: 8),
                for (final cat in kSymptomCatalog) ...[
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 8),
                    child: Text(cat.title,
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade700)),
                  ),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: cat.items.map((s) {
                      final on = _selected.contains(s);
                      return FilterChip(
                        label: Text(s),
                        selected: on,
                        showCheckmark: false,
                        selectedColor: AppTheme.primary.withValues(alpha: 0.25),
                        onSelected: (_) => setState(() {
                          if (on) {
                            _selected.remove(s);
                          } else {
                            _selected.add(s);
                          }
                        }),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
    );
  }
}
