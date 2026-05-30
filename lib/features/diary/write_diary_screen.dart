import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/db/database.dart';
import '../../core/db/database_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/image_storage.dart';
import 'diary_providers.dart';

/// 기분 1~5에 대응하는 아이콘·라벨 (일기 작성/목록 공용).
const List<IconData> kMoodIcons = [
  Icons.sentiment_very_dissatisfied,
  Icons.sentiment_dissatisfied,
  Icons.sentiment_neutral,
  Icons.sentiment_satisfied,
  Icons.sentiment_very_satisfied,
];
const List<String> kMoodLabels = ['나쁨', '별로', '보통', '좋음', '최고'];

/// 일기 작성/수정 화면.
class WriteDiaryScreen extends ConsumerStatefulWidget {
  const WriteDiaryScreen({super.key, required this.kind, this.existing});

  /// 일기 종류. 신규는 'general', 과거 글은 'pregnancy'/'parenting'.
  final String kind;
  final DiaryEntry? existing;

  @override
  ConsumerState<WriteDiaryScreen> createState() => _State();
}

class _State extends ConsumerState<WriteDiaryScreen> {
  late final TextEditingController _titleCtrl;
  late final TextEditingController _bodyCtrl;
  late DateTime _date;
  int _mood = 4;
  late List<String> _photos;
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _titleCtrl = TextEditingController(text: e?.title ?? '');
    _bodyCtrl = TextEditingController(text: e?.body ?? '');
    _date = e?.date ?? DateTime.now();
    _mood = e?.mood ?? 4;
    _photos = [...decodePhotoPaths(e?.photoPaths)];
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _bodyCtrl.dispose();
    super.dispose();
  }

  Future<void> _addPhoto(ImageSource source) async {
    final picked = await _picker.pickImage(source: source, maxWidth: 1600);
    if (picked == null) return;
    final saved = await ImageStorage.persist(picked.path, subdir: 'diary');
    setState(() => _photos.add(saved));
  }

  Future<void> _save() async {
    if (_bodyCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('내용을 입력해 주세요')));
      return;
    }
    final db = ref.read(databaseProvider);
    final title = _titleCtrl.text.trim().isEmpty ? null : _titleCtrl.text.trim();
    if (widget.existing == null) {
      await db.insertDiary(DiaryEntriesCompanion(
        date: Value(_date),
        kind: Value(widget.kind),
        title: Value(title),
        body: Value(_bodyCtrl.text.trim()),
        mood: Value(_mood),
        photoPaths: Value(encodePhotoPaths(_photos)),
      ));
    } else {
      await db.updateDiary(widget.existing!.copyWith(
        date: _date,
        title: Value(title),
        body: _bodyCtrl.text.trim(),
        mood: Value(_mood),
        photoPaths: Value(encodePhotoPaths(_photos)),
      ));
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existing == null ? '일기 쓰기' : '일기 수정'),
        actions: [
          TextButton(onPressed: _save, child: const Text('저장')),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 기분 선택
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(5, (i) {
              final selected = _mood == i + 1;
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => setState(() => _mood = i + 1),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: selected
                            ? AppTheme.primary
                            : Colors.grey.shade100,
                        shape: BoxShape.circle,
                        border: selected
                            ? null
                            : Border.all(color: Colors.grey.shade300),
                      ),
                      child: Icon(kMoodIcons[i],
                          size: 30,
                          color:
                              selected ? Colors.white : Colors.grey.shade500),
                    ),
                    const SizedBox(height: 4),
                    Text(kMoodLabels[i],
                        style: TextStyle(
                            fontSize: 11,
                            color: selected ? AppTheme.primary : Colors.grey,
                            fontWeight: selected
                                ? FontWeight.bold
                                : FontWeight.normal)),
                  ],
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _titleCtrl,
            decoration: const InputDecoration(labelText: '제목 (선택)'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _bodyCtrl,
            decoration: const InputDecoration(
              labelText: '오늘의 이야기',
              alignLabelWithHint: true,
            ),
            maxLines: 8,
          ),
          const SizedBox(height: 16),
          if (_photos.isNotEmpty)
            SizedBox(
              height: 100,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _photos.length,
                separatorBuilder: (_, i) => const SizedBox(width: 8),
                itemBuilder: (context, i) => Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(File(_photos[i]),
                          width: 100, height: 100, fit: BoxFit.cover),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: GestureDetector(
                        onTap: () => setState(() => _photos.removeAt(i)),
                        child: const CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.black54,
                          child: Icon(Icons.close,
                              size: 14, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _addPhoto(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('촬영'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _addPhoto(ImageSource.gallery),
                  icon: const Icon(Icons.photo),
                  label: const Text('사진 추가'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
