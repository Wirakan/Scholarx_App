import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyle {
  // DISPLAY
  static const TextStyle display = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w900,
    letterSpacing: -0.5,
    color: AppColors.textPrimary,
  );

  // HEADINGS
  static const TextStyle heading1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
    color: AppColors.textPrimary,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  // TITLE / CARD
  static const TextStyle title = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: 1.35,
    color: AppColors.textPrimary,
  );

  // BODY
  static const TextStyle body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.6,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  // LABEL / BUTTON
  static const TextStyle label = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  // CAPTION
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  // OVERLINE / BADGE
  static const TextStyle overline = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
    color: AppColors.textSecondary,
  );

  // MICRO
  static const TextStyle micro = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  // STAT / NUMBER
  static const TextStyle stat = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w900,
    color: AppColors.primary,
  );

  // ---- Aliases for legacy names used throughout app ----
  static TextStyle get h1 => heading1;
  static TextStyle get h2 => heading2;
  static TextStyle get h3 => heading3;
  static TextStyle get titleCard => title;
  static TextStyle get badge => overline;
  static TextStyle get statNumber => stat;
}
