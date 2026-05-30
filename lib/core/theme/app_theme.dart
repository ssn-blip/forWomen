import 'package:flutter/material.dart';

/// 앱 전역 테마. 여성 친화적인 파스텔 톤을 사용한다.
class AppTheme {
  AppTheme._();

  // 브랜드 색상 (로고: 보라·라벤더 톤)
  static const Color primary = Color(0xFF8763B6); // 보라
  static const Color secondary = Color(0xFFB39DDB); // 라벤더
  static const Color accent = Color(0xFFD1C4E9); // 연보라
  static const Color background = Color(0xFFF7F4FB); // 연보라빛 화이트
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
            borderRadius: BorderRadius.circular(18),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
          elevation: 2,
          shadowColor: primary.withValues(alpha: 0.4),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          side: BorderSide(color: primary.withValues(alpha: 0.5)),
          foregroundColor: primary,
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
