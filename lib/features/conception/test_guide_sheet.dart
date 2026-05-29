import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

/// 임신/배란테스트 촬영 가이드 모달. "기록 시작" 시 [onStart] 호출.
class TestGuideSheet extends StatelessWidget {
  const TestGuideSheet({super.key, required this.kind, required this.onStart});

  /// 'pregnancy' | 'ovulation'
  final String kind;
  final VoidCallback onStart;

  static Future<void> show(BuildContext context,
      {required String kind, required VoidCallback onStart}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => TestGuideSheet(kind: kind, onStart: onStart),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isPregnancy = kind == 'pregnancy';
    final tips = <(IconData, String)>[
      (Icons.wb_sunny_outlined, '밝은 곳에서 그림자 없이 촬영하세요.'),
      (Icons.crop_free, '결과창(C·T선)이 화면에 꽉 차도록 가까이.'),
      (Icons.straighten, '스트립을 가로로, C선이 왼쪽에 오게 두면 인식이 잘 돼요.'),
      (Icons.timer_outlined, '설명서 권장 시간(보통 표시 후 5~10분) 안에 촬영.'),
      (Icons.center_focus_strong, '흔들리지 않게 초점을 맞춰주세요.'),
    ];

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Center(
              child: Text(
                '${isPregnancy ? '임신테스트' : '배란테스트'} 촬영 가이드',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 14),
            // 예시 사진
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/guide/test_example.png',
                width: double.infinity,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 14),
            ...tips.map((t) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(t.$1, size: 20, color: AppTheme.secondary),
                      const SizedBox(width: 10),
                      Expanded(
                          child: Text(t.$2,
                              style: const TextStyle(fontSize: 14))),
                    ],
                  ),
                )),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                '⚠️ 자동 판독은 참고용 추정입니다. 결과는 직접 확인하고, 정확한 진단은 의료기관 검사를 받으세요.',
                style: TextStyle(fontSize: 12),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  onStart();
                },
                icon: const Icon(Icons.camera_alt),
                label: const Text('기록 시작'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
