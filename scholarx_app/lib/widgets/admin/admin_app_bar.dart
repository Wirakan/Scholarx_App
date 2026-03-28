import 'package:flutter/material.dart';
import '../coreApp/colors.dart';
import '../coreApp/text_styles.dart';

class SXAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;

  const SXAppBar({super.key, required this.title, this.showBack = false});

  @override
  Size get preferredSize => const Size.fromHeight(96);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: Container(
        color: SXColor.primary,
        child: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row: icon + ScholarX/Admin Panel + menu
              SizedBox(
                height: 48,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (showBack)
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
                        onPressed: () => Navigator.pop(context),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 8, 6, 8),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.school, color: Colors.white, size: 18),
                        ),
                      ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'ScholarX',
                          style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                        Text(
                          'Admin Panel',
                          style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 11),
                        ),
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.menu, color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              // Page title
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 20, 16),
                child: Text(title, style: SXText.pageTitle),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
Dabest
status_badge.dart
Dabest
import 'package:flutter/material.dart';
import '../core/colors.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  Color get bgColor {
    switch (status) {
      case 'รอดำเนินการ': return SXColor.warningBg;
      case 'กำลังตรวจสอบ': return SXColor.primaryBg;
      case 'อนุมัติ': return SXColor.successBg;
      case 'ปฏิเสธ': return SXColor.errorBg;
      default: return SXColor.neutralBg;
    }
  }

  Color get textColor {
    switch (status) {
      case 'รอดำเนินการ': return SXColor.warning;
      case 'กำลังตรวจสอบ': return SXColor.primary;
      case 'อนุมัติ': return SXColor.success;
      case 'ปฏิเสธ': return SXColor.error;
      default: return SXColor.neutral;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: textColor),
      ),
    );
  }
}