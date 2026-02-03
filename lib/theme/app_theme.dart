import 'package:flutter/material.dart';

class AppTheme {
  // 颜色定义
  static const Color backgroundColor = Color(0xFF1A1A1A);
  static const Color cardBackground = Color(0xFF2A2A2A);
  static const Color surfaceColor = Color(0xFF252525);
  static const Color borderColor = Color(0xFF3A3A3A);

  // 数据颜色
  static const Color pupilColor = Color(0xFF00D4AA); // 青色 - 瞳孔数据
  static const Color refractionColor = Color(0xFFFF6B6B); // 红色 - 屈光度数据
  static const Color estimateColor = Color(0xFFFFD93D); // 黄色 - 估计值

  // 文字颜色
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B0B0);
  static const Color textMuted = Color(0xFF808080);

  // 功能按钮颜色
  static const Color startButtonColor = Color(0xFF4CAF50);
  static const Color recordButtonColor = Color(0xFFFF5722);
  static const Color resetButtonColor = Color(0xFF2196F3);

  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: backgroundColor,
      primaryColor: pupilColor,
      colorScheme: const ColorScheme.dark(
        primary: pupilColor,
        secondary: refractionColor,
        surface: surfaceColor,
        onPrimary: textPrimary,
        onSecondary: textPrimary,
        onSurface: textPrimary,
      ),
      cardTheme: const CardThemeData(
        color: cardBackground,
        elevation: 0,
        margin: .zero,
        shape: RoundedRectangleBorder(
          borderRadius: .all(Radius.circular(4)),
          side: BorderSide(color: borderColor, width: 1),
        ),
      ),
      dividerTheme: const DividerThemeData(color: borderColor, thickness: 1),
      sliderTheme: SliderThemeData(
        activeTrackColor: pupilColor,
        inactiveTrackColor: borderColor,
        thumbColor: pupilColor,
        overlayColor: pupilColor.withValues(alpha: 0.2),
        trackHeight: 4,
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(color: textPrimary, fontSize: 16, fontWeight: .bold),
        titleMedium: TextStyle(color: textPrimary, fontSize: 14, fontWeight: .w600),
        bodyMedium: TextStyle(color: textSecondary, fontSize: 12),
        bodySmall: TextStyle(color: textMuted, fontSize: 11),
        labelSmall: TextStyle(color: textMuted, fontSize: 10),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        contentPadding: const .symmetric(horizontal: 8, vertical: 4),
        border: OutlineInputBorder(
          borderRadius: .circular(4),
          borderSide: const BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: .circular(4),
          borderSide: const BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: .circular(4),
          borderSide: const BorderSide(color: pupilColor),
        ),
        isDense: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: surfaceColor,
          foregroundColor: textPrimary,
          padding: const .symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: .circular(4),
            side: const BorderSide(color: borderColor),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: textSecondary, padding: const .symmetric(horizontal: 12, vertical: 8)),
      ),
      iconTheme: const IconThemeData(color: textSecondary, size: 18),
    );
  }
}
