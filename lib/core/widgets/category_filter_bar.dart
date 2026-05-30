import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// 카테고리 한 칸. [subs]가 있으면 누를 때 아래로 세분류가 펼쳐진다.
class CategoryGroup {
  const CategoryGroup(this.label, [this.subs]);
  final String label;
  final List<String>? subs;
}

/// 큰 분류(가로 칩) + 선택한 분류에 하위가 있으면 아래로 펼쳐지는 세분류 칩.
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

class _CategoryFilterBarState extends State<CategoryFilterBar> {
  late String _top = widget.groups.first.label;
  String? _sub;

  CategoryGroup get _current => widget.groups
      .firstWhere((g) => g.label == _top, orElse: () => widget.groups.first);

  void _selectTop(String label) {
    setState(() {
      _top = label;
      _sub = null;
    });
    widget.onChanged(_top, _sub);
  }

  void _selectSub(String? sub) {
    setState(() => _sub = sub);
    widget.onChanged(_top, _sub);
  }

  @override
  Widget build(BuildContext context) {
    final subs = _current.subs;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
          child: Row(
            children: [
              for (final g in widget.groups)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _Chip(
                    label: g.subs != null ? '${g.label} ▾' : g.label,
                    selected: g.label == _top,
                    onTap: () => _selectTop(g.label),
                  ),
                ),
            ],
          ),
        ),
        // 선택한 분류에 하위가 있으면 세분류 칩을 아래로 펼친다.
        if (subs != null)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _Chip(
                    label: '전체',
                    selected: _sub == null,
                    small: true,
                    onTap: () => _selectSub(null),
                  ),
                ),
                for (final s in subs)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _Chip(
                      label: s,
                      selected: _sub == s,
                      small: true,
                      onTap: () => _selectSub(s),
                    ),
                  ),
              ],
            ),
          ),
        const Divider(height: 1),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.small = false,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool small;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      showCheckmark: false,
      visualDensity: VisualDensity.compact,
      labelStyle: TextStyle(
        fontSize: small ? 12 : 13,
        color: selected ? Colors.white : Colors.grey.shade700,
        fontWeight: selected ? FontWeight.bold : FontWeight.normal,
      ),
      selectedColor: AppTheme.primary,
      backgroundColor: Colors.grey.shade100,
      side: BorderSide(
          color: selected ? AppTheme.primary : Colors.grey.shade300),
    );
  }
}
