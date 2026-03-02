import 'package:flutter/material.dart';
import 'package:scholarx/coreApp/themeApp/app_colors.dart';
import 'package:scholarx/coreApp/themeApp/app_text_style.dart';

enum ButtonSize { large, medium, small }

enum ButtonVariant { primary, outline, ghost, success, danger }

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final ButtonSize size;
  final ButtonVariant variant;
  final bool isLoading;
  final Widget? prefixIcon;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.size = ButtonSize.large,
    this.variant = ButtonVariant.primary,
    this.isLoading = false,
    this.prefixIcon,
  });

  double get _height {
    switch (size) {
      case ButtonSize.large:
        return 56;
      case ButtonSize.medium:
        return 44;
      case ButtonSize.small:
        return 34;
    }
  }

  double get _fontSize {
    switch (size) {
      case ButtonSize.large:
        return 15;
      case ButtonSize.medium:
        return 14;
      case ButtonSize.small:
        return 13;
    }
  }

  Color get _bgColor {
    if (onPressed == null) return AppColors.border;
    switch (variant) {
      case ButtonVariant.primary:
        return AppColors.primary;
      case ButtonVariant.outline:
        return Colors.transparent;
      case ButtonVariant.ghost:
        return Colors.transparent;
      case ButtonVariant.success:
        return AppColors.success;
      case ButtonVariant.danger:
        return AppColors.error;
    }
  }

  Color get _textColor {
    if (onPressed == null) return AppColors.textTertiary;
    switch (variant) {
      case ButtonVariant.primary:
        return Colors.white;
      case ButtonVariant.outline:
        return AppColors.primary;
      case ButtonVariant.ghost:
        return AppColors.textPrimary;
      case ButtonVariant.success:
        return Colors.white;
      case ButtonVariant.danger:
        return Colors.white;
    }
  }

  Border? get _border {
    if (variant == ButtonVariant.outline) {
      return Border.all(color: AppColors.primary, width: 1.5);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: _height,
        decoration: BoxDecoration(
          color: _bgColor,
          borderRadius: BorderRadius.circular(999),
          border: _border != null
              ? Border.all(color: AppColors.primary, width: 1.5)
              : null,
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: _textColor,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (prefixIcon != null) ...[
                    prefixIcon!,
                    const SizedBox(width: 8),
                  ],
                  Text(
                    label,
                    style: AppTextStyle.label.copyWith(
                      color: _textColor,
                      fontSize: _fontSize,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
