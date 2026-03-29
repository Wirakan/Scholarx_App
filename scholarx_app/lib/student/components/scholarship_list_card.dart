// features/student/components/scholarship_list_card.dart

import 'package:flutter/material.dart';
import '/coreApp/themeApp/app_colors.dart';
import '/coreApp/themeApp/app_text_style.dart';
import '/student/models/scholarship_model.dart';

class ScholarshipListCard extends StatelessWidget {
  final ScholarshipModel scholarship;
  final VoidCallback? onTap;

  const ScholarshipListCard({super.key, required this.scholarship, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row with amount
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(scholarship.title, style: AppTextStyle.titleCard),
              ),
              const SizedBox(width: 12),
Text(
                _formatAmount(scholarship.amount),
                style: AppTextStyle.statNumber.copyWith(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Description
          Text(
            scholarship.description,
            style: AppTextStyle.body.copyWith(color: AppColors.textSecondary),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),
          // Category badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primaryBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              scholarship.categoryLabel,
              style: AppTextStyle.badge.copyWith(
                color: AppColors.primary,
                letterSpacing: 0,
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Footer: deadline + button
          Row(
            children: [
              const Icon(
                Icons.calendar_today_rounded,
                size: 13,
                color: AppColors.textTertiary,
              ),
              const SizedBox(width: 5),
              Text(
                'เปิดรับถึง ${scholarship.deadline}',
                style: AppTextStyle.caption,
              ),
              const Spacer(),
              GestureDetector(
                onTap: onTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primary),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'ดูรายละเอียด',
                    style: AppTextStyle.label.copyWith(
                      color: AppColors.primary,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatAmount(double amount) {
    if (amount >= 1000) {
      final formatted = amount.toInt().toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]},',
      );
      return formatted;
    }
    return amount.toInt().toString();
  }
}
