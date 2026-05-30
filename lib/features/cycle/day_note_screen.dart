import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/db/database_provider.dart';
import '../../core/theme/app_theme.dart';

/// 날씨 선택지 (key, 아이콘, 라벨).
const List<({String key, IconData icon, String label})> kWeathers = [
  (key: 'sunny', icon: Icons.wb_sunny, label: '맑음'),
  (key: 'cloudy', icon: Icons.cloud, label: '흐림'),
  (key: 'rainy', icon: Icons.umbrella, label: '비'),
  (key: 'snowy', icon: Icons.ac_unit, label: '눈'),
];

/// 기분 선택지 (1~5, 아이콘).
const List<({int value, IconData icon, String label})> kMoods = [
  (value: 1, icon: Icons.sentiment_very_dissatisfied, label: '나쁨'),
  (value: 2, icon: Icons.sentiment_dissatisfied, label: '별로'),
  (value: 3, icon: Icons.sentiment_neutral, label: '보통'),
  (value: 4, icon: Icons.sentiment_satisfied, label: '좋음'),
  (value: 5, icon: Icons.sentiment_very_satisfied, label: '최고'),
];

IconData weatherIcon(String? key) =>
    kWeathers.where((w) => w.key == key).map((w) => w.icon).firstOrNull ??
    Icons.wb_sunny_outlined;

IconData moodIcon(int? value) =>
    kMoods.where((m) => m.value == value).map((m) => m.icon).firstOrNull ??
    Icons.sentiment_satisfied_outlined;

/// 하루 노트: 날씨 + 기분 + 메모.
class DayNoteScreen extends ConsumerStatefulWidget {
  const DayNoteScreen({super.key, required this.date});

  final DateTime date;

  static Future<void> show(BuildContext context, DateTime date) {
    return Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => DayNoteScreen(date: date)));
  }

  @override
  ConsumerState<DayNoteScreen> createState() => _State();
}

class _State extends ConsumerState<DayNoteScreen> {
  String? _weather;
  int? _mood;
  final _memoCtrl = TextEditingController();
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _memoCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final existing = await ref.read(databaseProvider).getDayNote(widget.date);
    if (!mounted) return;
    setState(() {
      _weather = existing?.weather;
      _mood = existing?.mood;
      _memoCtrl.text = existing?.memo ?? '';
      _loaded = true;
    });
  }

  Future<void> _save() async {
    await ref.read(databaseProvider).setDayNote(
          widget.date,
          weather: _weather,
          mood: _mood,
          memo: _memoCtrl.text,
        );
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('yyyy.MM.dd (E)', 'ko').format(widget.date);
    return Scaffold(
      appBar: AppBar(
        title: const Text('노트'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: AppTheme.primary),
            tooltip: '저장',
            onPressed: _save,
          ),
        ],
      ),
      body: !_loaded
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text('Today is...',
                    style: TextStyle(color: Colors.grey, fontSize: 13)),
                const SizedBox(height: 8),
                Text(dateStr,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                // 날씨
                const Text('날씨',
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: kWeathers.map((w) {
                    final on = _weather == w.key;
                    return _PickIcon(
                      icon: w.icon,
                      label: w.label,
                      selected: on,
                      onTap: () =>
                          setState(() => _weather = on ? null : w.key),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                // 기분
                const Text('기분',
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: kMoods.map((m) {
                    final on = _mood == m.value;
                    return _PickIcon(
                      icon: m.icon,
                      label: m.label,
                      selected: on,
                      onTap: () =>
                          setState(() => _mood = on ? null : m.value),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                const Text('메모',
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextField(
                  controller: _memoCtrl,
                  maxLines: 8,
                  minLines: 4,
                  decoration: const InputDecoration(
                    hintText: '이곳을 터치하여 입력하세요.',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
    );
  }
}

class _PickIcon extends StatelessWidget {
  const _PickIcon({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Column(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: selected
                  ? AppTheme.primary.withValues(alpha: 0.2)
                  : Colors.grey.shade200,
              child: Icon(icon,
                  color: selected ? AppTheme.primary : Colors.grey.shade500),
            ),
            const SizedBox(height: 4),
            Text(label,
                style: TextStyle(
                    fontSize: 11,
                    color: selected ? AppTheme.primary : Colors.grey,
                    fontWeight:
                        selected ? FontWeight.bold : FontWeight.normal)),
          ],
        ),
      ),
    );
  }
}
