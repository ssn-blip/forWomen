import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/db/database.dart';
import '../../core/db/database_provider.dart';
import '../../core/theme/app_theme.dart';
import 'diary_providers.dart';
import 'write_diary_screen.dart';

class DiaryScreen extends ConsumerWidget {
  const DiaryScreen({super.key});

  void _openEditor(BuildContext context, {DiaryEntry? existing}) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) =>
          WriteDiaryScreen(kind: existing?.kind ?? 'general', existing: existing),
    ));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(allDiaryProvider);
    const moodEmoji = ['😢', '😟', '😐', '🙂', '😄'];

    return Scaffold(
      appBar: AppBar(title: const Text('일기')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openEditor(context),
        icon: const Icon(Icons.edit),
        label: const Text('일기 쓰기'),
      ),
      body: entriesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('오류: $e')),
        data: (entries) {
          if (entries.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.menu_book,
                        size: 64, color: AppTheme.secondary),
                    const SizedBox(height: 16),
                    Text('소중한 오늘의 순간을 기록해 보세요',
                        style: TextStyle(color: Colors.grey.shade600)),
                  ],
                ),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 96),
            itemCount: entries.length,
            itemBuilder: (context, i) {
              final e = entries[i];
              final photos = decodePhotoPaths(e.photoPaths);
              return Card(
                child: InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () => _openEditor(context, existing: e),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              e.mood != null
                                  ? moodEmoji[(e.mood! - 1).clamp(0, 4)]
                                  : '📝',
                              style: const TextStyle(fontSize: 20),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              DateFormat('yyyy.MM.dd (E)', 'ko').format(e.date),
                              style: TextStyle(
                                  color: Colors.grey.shade600, fontSize: 13),
                            ),
                            const Spacer(),
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon: const Icon(Icons.delete_outline, size: 20),
                              onPressed: () =>
                                  ref.read(databaseProvider).deleteDiary(e.id),
                            ),
                          ],
                        ),
                        if (e.title != null) ...[
                          const SizedBox(height: 6),
                          Text(e.title!,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                        const SizedBox(height: 4),
                        Text(e.body,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.grey.shade800)),
                        if (photos.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 72,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: photos.length,
                              separatorBuilder: (_, i) =>
                                  const SizedBox(width: 6),
                              itemBuilder: (_, j) => ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(File(photos[j]),
                                    width: 72, height: 72, fit: BoxFit.cover),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
