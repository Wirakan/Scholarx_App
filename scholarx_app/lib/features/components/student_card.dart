import 'package:flutter/material.dart';
import '/coreApp/themeApp/app_colors.dart';
import '/coreApp/themeApp/app_text_style.dart';

// ScholarshipCardItem used by the cards is now defined in the
// student/models package.  we re‑export it here so existing imports
// continue to work without changes.
import '/features/student/models/scholarship_detail_model.dart';

export '/features/student/models/scholarship_detail_model.dart'
    show ScholarshipCardItem;

class StudentCard extends StatelessWidget {
  final ScholarshipCardItem item;
  final VoidCallback? onTap;

  const StudentCard({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item.title, style: AppTextStyle.titleCard),
          const SizedBox(height: 4),
          Text(
            item.category,
            style: AppTextStyle.badge.copyWith(
              color: AppColors.primary,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item.description,
            style: AppTextStyle.body.copyWith(color: AppColors.textSecondary),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'อัปเดตล่าสุด ${item.updatedAt}',
                style: AppTextStyle.caption,
              ),
              GestureDetector(
                onTap: onTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
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
}
