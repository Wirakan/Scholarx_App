import 'package:flutter/material.dart';
import '../core/colors.dart';
import '../core/text_styles.dart';
import '../core/models.dart';
import 'status_badge.dart';

class ApplicantCard extends StatelessWidget {
  final Applicant applicant;
  final VoidCallback onTap;

  const ApplicantCard({super.key, required this.applicant, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: SXColor.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: SXColor.border),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4, offset: const Offset(0, 1)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  applicant.id,
                  style: SXText.caption.copyWith(color: SXColor.primary, fontWeight: FontWeight.w700),
                ),
                const Spacer(),
                StatusBadge(status: applicant.status),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: SXColor.primary,
                  child: Text(
                    applicant.name[0],
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(applicant.name, style: SXText.label),
                      Text(applicant.studentId, style: SXText.caption),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.school_outlined, size: 13, color: SXColor.textSecondary),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(applicant.scholarship, style: SXText.caption, overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.calendar_today_outlined, size: 13, color: SXColor.textSecondary),
                const SizedBox(width: 4),
                Text(applicant.date, style: SXText.caption),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    border: Border.all(color: SXColor.primary),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'ดูรายละเอียด',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: SXColor.primary),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}