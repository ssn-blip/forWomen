import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// 세그먼트 선택색을 핑크+흰 글씨로(앱 강조색과 동일하게).
final ButtonStyle _kSegStyle = ButtonStyle(
  backgroundColor: WidgetStateProperty.resolveWith(
    (s) => s.contains(WidgetState.selected) ? AppTheme.primary : null,
  ),
  foregroundColor: WidgetStateProperty.resolveWith(
    (s) => s.contains(WidgetState.selected) ? Colors.white : Colors.grey.shade700,
  ),
);

/// 카테고리 한 칸. [subs]가 있으면 선택 시 아래로 세분류가 펼쳐진다.
class CategoryGroup {
  const CategoryGroup(this.label, [this.subs]);
  final String label;
  final List<String>? subs;
}

/// 큰 분류(세그먼트 버튼) + 선택한 분류에 하위가 있으면 아래로 펼쳐지는 세분류 세그먼트.
/// 선택이 바뀔 때마다 [onChanged]에 (큰분류, 세분류?)를 전달한다.
/// 세분류가 null이면 "그 분류 전체"를 의미한다.
class CategoryFilterBar extends StatefulWidget {
  const CategoryFilterBar({
    super.key,
    required this.groups,
    required this.onChanged,
  });

  final List<CategoryGroup> groups;
  final void Function(String top, String? sub) onChanged;

  @override
  State<CategoryFilterBar> createState() => _CategoryFilterBarState();
}

/// 세분류 "전체"용 센티넬 값.
const String _kSubAll = '__all__';

class _CategoryFilterBarState extends State<CategoryFilterBar> {
  late String _top = widget.groups.first.label;
  String? _sub;

  CategoryGroup get _current => widget.groups
      .firstWhere((g) => g.label == _top, orElse: () => widget.groups.first);

  @override
  Widget build(BuildContext context) {
    final subs = _current.subs;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 큰 분류 (연결된 세그먼트 버튼). 항목이 많아도 가로 스크롤.
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
          child: SegmentedButton<String>(
            showSelectedIcon: false,
            style: _kSegStyle,
            segments: [
              for (final g in widget.groups)
                ButtonSegment(
                  value: g.label,
                  label: Text(g.subs != null ? '${g.label} ▾' : g.label),
                ),
            ],
            selected: {_top},
            onSelectionChanged: (s) {
              setState(() {
                _top = s.first;
                _sub = null;
              });
              widget.onChanged(_top, _sub);
            },
          ),
        ),
        // 하위가 있으면 세분류 세그먼트를 아래로 펼친다.
        if (subs != null)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
            child: SegmentedButton<String>(
              showSelectedIcon: false,
              style: _kSegStyle,
              segments: [
                const ButtonSegment(value: _kSubAll, label: Text('전체')),
                for (final s in subs)
                  ButtonSegment(value: s, label: Text(s)),
              ],
              selected: {_sub ?? _kSubAll},
              onSelectionChanged: (s) {
                final v = s.first;
                setState(() => _sub = v == _kSubAll ? null : v);
                widget.onChanged(_top, _sub);
              },
            ),
          ),
        const Divider(height: 1),
      ],
    );
  }
}
