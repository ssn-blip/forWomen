import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/notifications/notification_service.dart';
import '../../core/theme/app_theme.dart';

/// 테스트 판독 대기 타이머 (3분·5분 등). 끝나면 알림.
class TestTimerSheet extends ConsumerStatefulWidget {
  const TestTimerSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const TestTimerSheet(),
    );
  }

  @override
  ConsumerState<TestTimerSheet> createState() => _State();
}

class _State extends ConsumerState<TestTimerSheet> {
  static const _notifId = 990001;
  int _total = 5 * 60; // 기본 5분
  int _remaining = 5 * 60;
  Timer? _timer;
  bool _running = false;
  bool _done = false;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _setMinutes(int m) {
    if (_running) return;
    setState(() {
      _total = m * 60;
      _remaining = _total;
      _done = false;
    });
  }

  void _start() {
    if (_remaining <= 0) return;
    // 카운트다운은 즉시 시작(권한 흐름과 분리).
    setState(() {
      _running = true;
      _done = false;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remaining <= 1) {
        _finish();
      } else {
        setState(() => _remaining--);
      }
    });

    // 백그라운드 알림은 best-effort로 예약(실패해도 인앱 타이머는 동작).
    final notif = ref.read(notificationServiceProvider);
    final at = DateTime.now().add(Duration(seconds: _remaining));
    () async {
      try {
        await notif.requestPermissions();
        await notif.schedule(
          id: _notifId,
          title: '⏰ 테스트 확인 시간',
          body: '결과를 확인하세요.',
          at: at,
        );
      } catch (_) {}
    }();
  }

  void _finish() {
    _timer?.cancel();
    HapticFeedback.heavyImpact();
    SystemSound.play(SystemSoundType.alert);
    setState(() {
      _remaining = 0;
      _running = false;
      _done = true;
    });
  }

  Future<void> _stop() async {
    _timer?.cancel();
    await ref.read(notificationServiceProvider).cancel(_notifId);
    setState(() {
      _running = false;
      _remaining = _total;
      _done = false;
    });
  }

  String get _mmss {
    final m = (_remaining ~/ 60).toString().padLeft(2, '0');
    final s = (_remaining % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final progress = _total == 0 ? 0.0 : _remaining / _total;
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('판독 대기 타이머',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text('테스트 설명서의 권장 시간을 맞춰 두세요.',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
          const SizedBox(height: 20),
          // 프리셋
          Wrap(
            spacing: 8,
            children: [3, 5, 10].map((m) {
              final selected = _total == m * 60;
              return ChoiceChip(
                label: Text('$m분'),
                selected: selected,
                onSelected: _running ? null : (_) => _setMinutes(m),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          // 미세 조정
          if (!_running)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: _total > 60
                      ? () => _setMinutes((_total ~/ 60) - 1)
                      : null,
                ),
                Text('${_total ~/ 60}분',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: _total < 60 * 60
                      ? () => _setMinutes((_total ~/ 60) + 1)
                      : null,
                ),
              ],
            ),
          const SizedBox(height: 12),
          // 카운트다운
          SizedBox(
            width: 180,
            height: 180,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 180,
                  height: 180,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 10,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation(
                        _done ? AppTheme.fertile : AppTheme.primary),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_done ? '완료!' : _mmss,
                        style: const TextStyle(
                            fontSize: 36, fontWeight: FontWeight.bold)),
                    if (_done)
                      const Text('결과를 확인하세요',
                          style: TextStyle(
                              fontSize: 13, color: AppTheme.fertile)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _stop,
                  icon: const Icon(Icons.restart_alt),
                  label: const Text('리셋'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton.icon(
                  onPressed: _running ? _stop : _start,
                  icon: Icon(_running ? Icons.stop : Icons.play_arrow),
                  label: Text(_running ? '정지' : '시작'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
