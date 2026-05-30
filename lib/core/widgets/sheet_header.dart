import 'package:flutter/material.dart';

/// 바텀시트 공통 헤더: 가운데 제목 + 오른쪽 닫기(X) 버튼.
/// 저장하지 않아도 시트를 닫을 수 있도록 모든 입력 시트에서 사용한다.
class SheetHeader extends StatelessWidget {
  const SheetHeader({
    super.key,
    required this.title,
    this.icon,
    this.iconColor,
    this.onClose,
  });

  final String title;
  final IconData? icon;
  final Color? iconColor;

  /// 닫기 동작(기본: Navigator.pop). 닫기 전 정리 작업이 필요한 시트에서 주입.
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 48), // 오른쪽 X버튼과 대칭(제목 가운데 정렬)
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, color: iconColor),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close),
          tooltip: '닫기',
          onPressed: onClose ?? () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
