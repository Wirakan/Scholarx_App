import 'package:flutter/material.dart';
import '../core/colors.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  Color get bgColor {
    switch (status) {
      case 'รอดำเนินการ': return SXColor.warningBg;
      case 'กำลังพิจารณา': return const Color(0xFFEFF6FF);
      case 'อนุมัติ': return SXColor.successBg;
      case 'ปฏิเสธ': return SXColor.errorBg;
      default: return SXColor.neutralBg;
    }
  }

  Color get textColor {
    switch (status) {
      case 'รอดำเนินการ': return SXColor.warning;
      case 'กำลังพิจารณา': return const Color(0xFF60A5FA);
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