import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'record_kinds.dart';
import 'record_panel_settings.dart';

/// 기록 패널에 표시할 항목과 순서를 편집하는 화면.
/// - 드래그로 순서 변경
/// - 눈 아이콘으로 숨기기(제거)
/// - 아래 "추가할 수 있는 항목"에서 다시 추가
class RecordPanelSettingsScreen extends ConsumerWidget {
  const RecordPanelSettingsScreen({super.key});

  static Future<void> show(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const RecordPanelSettingsScreen()),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final order = ref.watch(recordPanelOrderProvider);
    final notifier = ref.read(recordPanelOrderProvider.notifier);
    final hidden =
        kAllRecordKinds.where((k) => !order.contains(k.key)).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('기록 항목 편집'),
        actions: [
          TextButton(
            onPressed: () => notifier.reset(),
            child: const Text('초기화'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 16, 20, 4),
            child: Text('표시 항목 · 드래그로 순서 변경',
                style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold)),
          ),
          ReorderableListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            buildDefaultDragHandles: false,
            onReorder: notifier.reorder,
            children: [
              for (int i = 0; i < order.length; i++)
                _EnabledTile(
                  key: ValueKey(order[i]),
                  index: i,
                  kind: recordKindByKey(order[i])!,
                  onHide: () => notifier.hide(order[i]),
                ),
            ],
          ),
          if (hidden.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 4),
              child: Text('추가할 수 있는 항목',
                  style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold)),
            ),
            for (final k in hidden)
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: k.color.withValues(alpha: 0.18),
                  child: Icon(k.icon, color: k.color, size: 20),
                ),
                title: Text(k.label),
                trailing: TextButton.icon(
                  onPressed: () => notifier.add(k.key),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('추가'),
                ),
              ),
          ],
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Text('숨겨도 기존 기록은 삭제되지 않아요. 언제든 다시 추가할 수 있어요.',
                style: TextStyle(fontSize: 12, color: Colors.grey)),
          ),
        ],
      ),
    );
  }
}

class _EnabledTile extends StatelessWidget {
  const _EnabledTile({
    super.key,
    required this.index,
    required this.kind,
    required this.onHide,
  });

  final int index;
  final RecordKind kind;
  final VoidCallback onHide;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: kind.color.withValues(alpha: 0.18),
        child: Icon(kind.icon, color: kind.color, size: 20),
      ),
      title: Text(kind.label),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.visibility_off_outlined,
                color: Colors.red.shade300),
            tooltip: '숨기기',
            onPressed: onHide,
          ),
          ReorderableDragStartListener(
            index: index,
            child: Icon(Icons.drag_handle, color: Colors.grey.shade500),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}
