import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/db/database.dart';
import '../../core/db/database_provider.dart';
import '../../core/theme/app_theme.dart';
import 'diary_providers.dart';

/// 임신·육아 화면 등에서 간단한 메모를 남기는 섹션.
/// 일기(DiaryEntries)를 재사용하되 일기 탭과 섞이지 않도록 별도 [kind]로 저장한다.
/// (예: 'pregnancy_memo', 'baby_memo')
class MemoSection extends ConsumerWidget {
  const MemoSection({super.key, required this.kind, this.title = '메모'});

  final String kind;
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memos = ref.watch(diaryProvider(kind)).value ?? const [];
    final fmt = DateFormat('M월 d일 (E) a h:mm', 'ko');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const Spacer(),
            TextButton.icon(
              onPressed: () => _edit(context, ref),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('메모 추가'),
            ),
          ],
        ),
        const SizedBox(height: 4),
        if (memos.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Icon(Icons.sticky_note_2_outlined,
                      color: Colors.grey.shade400),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text('기억하고 싶은 순간이나 메모를 남겨보세요.',
                        style: TextStyle(color: Colors.grey.shade600)),
                  ),
                ],
              ),
            ),
          )
        else
          ...memos.map((m) => Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppTheme.accent,
                    child: const Icon(Icons.sticky_note_2,
                        color: Colors.white, size: 20),
                  ),
                  title: Text(m.body,
                      maxLines: 4, overflow: TextOverflow.ellipsis),
                  subtitle: Text(fmt.format(m.date),
                      style: const TextStyle(fontSize: 12)),
                  onTap: () => _edit(context, ref, existing: m),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, size: 20),
                    onPressed: () =>
                        ref.read(databaseProvider).deleteDiary(m.id),
                  ),
                ),
              )),
      ],
    );
  }

  /// 메모 추가/수정 다이얼로그. 확인 시 저장(빈 값이면 기존 메모 삭제), 취소 시 변경 없음.
  Future<void> _edit(BuildContext context, WidgetRef ref,
      {DiaryEntry? existing}) async {
    final ctrl = TextEditingController(text: existing?.body ?? '');
    final text = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(existing == null ? '메모 추가' : '메모 수정'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          minLines: 3,
          maxLines: 6,
          decoration: const InputDecoration(
            hintText: '메모를 입력하세요',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
            child: const Text('저장'),
          ),
        ],
      ),
    );

    if (text == null) return; // 취소/바깥 탭
    final db = ref.read(databaseProvider);
    if (text.isEmpty) {
      if (existing != null) await db.deleteDiary(existing.id);
      return;
    }
    if (existing != null) {
      await db.updateDiary(existing.copyWith(body: text));
    } else {
      await db.insertDiary(DiaryEntriesCompanion.insert(
        date: DateTime.now(),
        kind: kind,
        body: text,
      ));
    }
  }
}
