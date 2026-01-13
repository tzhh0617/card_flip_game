import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF6C63FF);
  static const secondary = Color(0xFFFF6584);
  static const accent = Color(0xFFFFD93D);
  static const success = Color(0xFF4CAF50);
  static const error = Color(0xFFFF5252);

  static const background = Color(0xFFF5F7FF);
  static const cardBack = Color(0xFF3D5AFE);

  static const List<Color> themeColors = [
    Color(0xFF2196F3),
    Color(0xFFE91E63),
    Color(0xFF00BCD4),
    Color(0xFFFF5722),
    Color(0xFF4CAF50),
    Color(0xFF9C27B0),
    Color(0xFFFF9800),
    Color(0xFF673AB7),
    Color(0xFFCDDC39),
    Color(0xFF009688),
  ];

  static const List<Color> cardColors = [
    Color(0xFFE57373),
    Color(0xFF81C784),
    Color(0xFF64B5F6),
    Color(0xFFFFD54F),
    Color(0xFFBA68C8),
    Color(0xFF4DB6AC),
    Color(0xFFFF8A65),
    Color(0xFFA1887F),
    Color(0xFF90A4AE),
    Color(0xFFF06292),
    Color(0xFFAED581),
    Color(0xFF4FC3F7),
  ];
}

class AppSizes {
  static const double cardBorderRadius = 16.0;
  static const double buttonBorderRadius = 24.0;
  static const double screenPadding = 16.0;
  static const double cardSpacing = 8.0;

  static const double minTapTarget = 48.0;

  static const double titleFontSize = 32.0;
  static const double headingFontSize = 24.0;
  static const double bodyFontSize = 18.0;
  static const double buttonFontSize = 20.0;
}

class AppDurations {
  static const Duration cardFlip = Duration(milliseconds: 400);
  static const Duration cardMatch = Duration(milliseconds: 300);
  static const Duration cardMismatch = Duration(milliseconds: 800);
  static const Duration cardEntrance = Duration(milliseconds: 100);
  static const Duration celebration = Duration(milliseconds: 2000);
  static const Duration starDrop = Duration(milliseconds: 500);
}

class AppStrings {
  static const String appTitle = '翻转卡片';

  static const List<String> encouragements = [
    '你真棒！',
    '太厉害了！',
    '哇！好聪明！',
    '继续加油！',
    '你是最棒的！',
    '太amazing了！',
    '聪明的小天才！',
    '完美！Perfect！',
    '你做到了！',
    '超级厉害！',
  ];

  static const List<String> comboTexts = [
    '连击！',
    '太棒了！',
    '厉害！',
    'Amazing!',
    'Perfect!',
    'Excellent!',
  ];
}
