import 'package:flutter/material.dart';

/// 앱 전역 테마. 여성 친화적인 파스텔 톤을 사용한다.
class AppTheme {
  AppTheme._();

  // 브랜드 색상
  static const Color primary = Color(0xFFF48FB1); // 핑크
  static const Color secondary = Color(0xFF9FA8DA); // 라벤더
  static const Color accent = Color(0xFFFFCC80); // 살구
  static const Color background = Color(0xFFFFF7FA);
  static const Color surface = Colors.white;

  // 의미 색상 (주기 캘린더 등에서 사용)
  static const Color period = Color(0xFFE57373); // 생리
  static const Color fertile = Color(0xFF81C784); // 가임기
  static const Color ovulation = Color(0xFF64B5F6); // 배란일
  static const Color predicted = Color(0xFFFFB74D); // 예측

  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: primary,
      primary: primary,
      secondary: secondary,
      surface: surface,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        foregroundColor: Color(0xFF4A4A4A),
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      chipTheme: const ChipThemeData(
        backgroundColor: Color(0xFFF5F5F5),
        side: BorderSide.none,
      ),
    );
  }
}
