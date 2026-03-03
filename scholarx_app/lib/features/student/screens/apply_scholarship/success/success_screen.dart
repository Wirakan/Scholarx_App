import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_style.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key, required this.onHome});

  final VoidCallback onHome;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          // Header สีส้ม — ไม่มี step bar
          ScholarshipHeader(title: AppStrings.appName),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 40, 24, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Check icon
                  Container(
                    width: 80, height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryLight,
                      border: Border.all(color: AppColors.primary, width: 4),
                    ),
                    child: const Center(
                      child: Icon(Icons.check, color: AppColors.primary, size: 36),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(AppStrings.successTitle,  style: AppTextStyle.successTitle),
                  const SizedBox(height: 6),
                  Text(AppStrings.successSub,    style: AppTextStyle.successSub),
                  const SizedBox(height: 24),

                  // Receipt card
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 2)),
                      ],
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(children: [
                            TextSpan(text: '${AppStrings.successRefLabel} ',
                                style: AppTextStyle.receiptLabel),
                            TextSpan(text: AppStrings.successRefNo,
                                style: AppTextStyle.receiptNumber),
                          ]),
                        ),
                        const SizedBox(height: 12),
                        ...[
                          [AppStrings.receiptFundName,  AppStrings.receiptFundValue],
                          [AppStrings.receiptAmount,    AppStrings.receiptAmountValue],
                          [AppStrings.receiptDate,      AppStrings.receiptDateValue],
                          [AppStrings.receiptTime,      AppStrings.receiptTimeValue],
                        ].map(
                          (row) => Column(
                            children: [
                              const Divider(height: 1, color: Color(0xFFF3F4F6)),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(row[0], style: AppTextStyle.receiptLabel),
                                    Text(row[1], style: AppTextStyle.receiptValue),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Notification banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.primaryBorder),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('🔔', style: TextStyle(fontSize: 18)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(AppStrings.successNotif,
                              style: AppTextStyle.alertText),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Buttons
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text(AppStrings.btnTrack),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: onHome,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary, width: 2),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text(AppStrings.btnHome,
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
