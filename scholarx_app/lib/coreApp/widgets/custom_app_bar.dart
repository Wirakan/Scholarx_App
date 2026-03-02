import 'package:flutter/material.dart';
import 'package:scholarx/coreApp/themeApp/app_colors.dart';
import 'package:scholarx/coreApp/themeApp/app_text_style.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBack;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Widget? leading;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showBack = true,
    this.backgroundColor,
    this.foregroundColor,
    this.leading,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? AppColors.primary,
      foregroundColor: foregroundColor ?? Colors.white,
      elevation: 0,
      leading: showBack
          ? (leading ??
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                  onPressed: () => Navigator.of(context).maybePop(),
                ))
          : leading,
      automaticallyImplyLeading: showBack,
      title: Text(
        title,
        style: AppTextStyle.h3.copyWith(color: foregroundColor ?? Colors.white),
      ),
      actions: actions,
    );
  }
}
