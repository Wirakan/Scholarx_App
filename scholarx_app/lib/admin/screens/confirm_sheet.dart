import 'package:flutter/material.dart';
import '../core/colors.dart';
import '../core/text_styles.dart';
import '../core/models.dart';


void showApproveSheet(
  BuildContext context,
  Applicant applicant, {
  VoidCallback? onConfirm,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => ConfirmSheet(applicant: applicant, isApprove: true, onConfirm: onConfirm),
  );
}

void showRejectSheet(
  BuildContext context,
  Applicant applicant, {
  VoidCallback? onConfirm,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => ConfirmSheet(applicant: applicant, isApprove: false, onConfirm: onConfirm),
  );
}

class ConfirmSheet extends StatelessWidget {
  final Applicant applicant;
  final bool isApprove;
  /// callback ที่จะ trigger หลัง confirm — ใช้อัพเดท repository
  final VoidCallback? onConfirm;

  const ConfirmSheet({
    super.key,
    required this.applicant,
    required this.isApprove,
    this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final color    = isApprove ? SXColor.success : SXColor.error;
    final bgColor  = isApprove ? SXColor.successBg : SXColor.errorBg;
    final icon     = isApprove ? Icons.check_rounded : Icons.close_rounded;
    final title    = isApprove ? 'ยืนยันการอนุมัติ' : 'ยืนยันการปฏิเสธ';
    final subtitle = isApprove
        ? 'คุณแน่ใจหรือไม่ว่าต้องการอนุมัติใบสมัครนี้?\nการดำเนินการนี้ไม่สามารถแก้ไขได้'
        : 'คุณแน่ใจหรือไม่ว่าต้องการปฏิเสธใบสมัครนี้?\nการดำเนินการนี้ไม่สามารถแก้ไขได้';
    final btnLabel = isApprove ? 'ยืนยันการอนุมัติ' : 'ยืนยันการปฏิเสธ';

    return Container(
      decoration: const BoxDecoration(
        color: SXColor.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 36),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: SXColor.border, borderRadius: BorderRadius.circular(999))),
          const SizedBox(height: 24),
          Container(
            width: 56, height: 56,
            decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(16)),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 16),
          Text(title, style: SXText.sectionHeader.copyWith(fontSize: 18)),
          const SizedBox(height: 8),
          Text(subtitle, textAlign: TextAlign.center, style: SXText.body.copyWith(color: SXColor.textSecondary, height: 1.5)),
          const SizedBox(height: 20),
          // Applicant card
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: SXColor.background, borderRadius: BorderRadius.circular(12), border: Border.all(color: SXColor.border)),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: SXColor.primary,
                  child: Text(applicant.name[0], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(applicant.name, style: SXText.label),
                      Text('${applicant.id}  ·  ${applicant.scholarship}', style: SXText.caption, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: SXColor.border),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('ยกเลิก', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: SXColor.textSecondary)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context); // ปิด sheet
                    // อัพเดท status ผ่าน callback (จะ trigger repository.updateStatus)
                    onConfirm?.call();
                    // แจ้งผล
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(isApprove ? 'อนุมัติใบสมัครสำเร็จ' : 'ปฏิเสธใบสมัครสำเร็จ'),
                        backgroundColor: color,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    );
                  },
                  icon: Icon(icon, size: 18),
                  label: Text(btnLabel),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}