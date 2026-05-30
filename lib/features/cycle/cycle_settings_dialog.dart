import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'cycle_settings.dart';

/// 평균 주기·생리 기간을 조정하는 다이얼로그.
class CycleSettingsDialog extends ConsumerStatefulWidget {
  const CycleSettingsDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) => const CycleSettingsDialog(),
    );
  }

  @override
  ConsumerState<CycleSettingsDialog> createState() => _State();
}

class _State extends ConsumerState<CycleSettingsDialog> {
  late int _cycle;
  late int _period;
  late bool _autoLearn;
  late bool _weekStartsMonday;

  @override
  void initState() {
    super.initState();
    final s = ref.read(cycleSettingsProvider);
    _cycle = s.avgCycleLength;
    _period = s.periodLength;
    _autoLearn = s.autoLearn;
    _weekStartsMonday = s.weekStartsMonday;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('주기 설정'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 자동 계산 ↔ 직접 설정 선택
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('기록으로 자동 계산'),
            subtitle: Text(
              _autoLearn
                  ? '생리 기록 2회 이상이면 평균 주기를 자동 계산해요'
                  : '아래에서 직접 설정한 주기를 사용해요',
              style: const TextStyle(fontSize: 12),
            ),
            value: _autoLearn,
            onChanged: (v) => setState(() => _autoLearn = v),
          ),
          const Divider(),
          _Stepper(
            label: _autoLearn ? '기본 주기' : '내 주기',
            value: _cycle,
            unit: '일',
            min: 20,
            max: 45,
            onChanged: (v) => setState(() => _cycle = v),
          ),
          const SizedBox(height: 12),
          _Stepper(
            label: '생리 기간',
            value: _period,
            unit: '일',
            min: 2,
            max: 10,
            onChanged: (v) => setState(() => _period = v),
          ),
          const SizedBox(height: 8),
          Text(
            _autoLearn
                ? '기록이 2회 미만일 땐 위의 기본 주기로 계산합니다.'
                : '입력하신 주기로 배란·가임기·다음 생리를 계산합니다.',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const Divider(height: 20),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text('달력 주 시작 요일',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 8),
          SegmentedButton<bool>(
            showSelectedIcon: false,
            segments: const [
              ButtonSegment(value: false, label: Text('일요일')),
              ButtonSegment(value: true, label: Text('월요일')),
            ],
            selected: {_weekStartsMonday},
            onSelectionChanged: (s) =>
                setState(() => _weekStartsMonday = s.first),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('취소'),
        ),
        FilledButton(
          onPressed: () async {
            await ref.read(cycleSettingsProvider.notifier).update(
                  avgCycleLength: _cycle,
                  periodLength: _period,
                  autoLearn: _autoLearn,
                  weekStartsMonday: _weekStartsMonday,
                );
            if (context.mounted) Navigator.pop(context);
          },
          child: const Text('저장'),
        ),
      ],
    );
  }
}

class _Stepper extends StatelessWidget {
  const _Stepper({
    required this.label,
    required this.value,
    required this.unit,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  final String label;
  final int value;
  final String unit;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(label)),
        IconButton(
          icon: const Icon(Icons.remove_circle_outline),
          onPressed: value > min ? () => onChanged(value - 1) : null,
        ),
        SizedBox(
          width: 48,
          child: Text('$value$unit', textAlign: TextAlign.center),
        ),
        IconButton(
          icon: const Icon(Icons.add_circle_outline),
          onPressed: value < max ? () => onChanged(value + 1) : null,
        ),
      ],
    );
  }
}
