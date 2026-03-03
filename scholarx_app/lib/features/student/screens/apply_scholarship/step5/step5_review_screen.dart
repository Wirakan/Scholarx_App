import 'package:flutter/material.dart';

import '/coreApp/themeApp/app_colors.dart';
import '/coreApp/themeApp/app_text_style.dart';
import '/coreApp/constants/app_strings.dart';
import '/coreApp/widgets/custom_app_bar.dart';
import '/coreApp/widgets/form_input.dart';
import '/coreApp/widgets/primary_button.dart';
import '/features/student/models/scholarship_form_model.dart';

class Step5ReviewScreen extends StatelessWidget {
  const Step5ReviewScreen({
    super.key,
    required this.formData,
    required this.onSubmit,
    required this.onBack,
  });

  final ScholarshipFormModel formData;
  final VoidCallback onSubmit;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final d = formData;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          ScholarshipHeader(title: AppStrings.appName),
          const StepIndicatorBar(currentStep: 4),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 100),
              child: Column(
                children: [
                  AlertBanner(message: AppStrings.step5Alert),

                  // ข้อมูลส่วนตัว
                  SectionCard(
                    icon: '👤',
                    title: AppStrings.reviewPersonal,
                    children: [
                      _divRow(AppStrings.reviewStudentId, d.studentId),
                      _divRow(AppStrings.reviewFullName, d.fullName),
                      _divRow(AppStrings.reviewPhone, d.phone),
                      _divRow(AppStrings.reviewEmail, d.email),
                      ReviewRow(label: AppStrings.reviewAddress, value: d.address),
                    ],
                  ),

                  // ข้อมูลครอบครัว
                  SectionCard(
                    icon: '👨‍👩‍👧',
                    title: AppStrings.reviewFamily,
                    children: [
                      _divRow(AppStrings.reviewFatherName, d.fatherName),
                      _divRow(AppStrings.reviewPhone, d.fatherPhone),
                      _divRow(AppStrings.reviewJob, d.fatherJob ?? ''),
                      _divRow(AppStrings.reviewIncome, d.fatherIncome ?? ''),
                      _divRow(AppStrings.reviewMotherName, d.motherName),
                      _divRow(AppStrings.reviewPhone, d.motherPhone),
                      _divRow(AppStrings.reviewJob, d.motherJob ?? ''),
                      _divRow(AppStrings.reviewIncome, d.motherIncome ?? ''),
                      _divRow(AppStrings.reviewFamilyStatus, d.familyStatus ?? ''),
                      _divRow(AppStrings.reviewApplicantIncome, d.applicantIncome ?? ''),
                      _divRow(AppStrings.reviewFamilyIncome, d.familyIncome ?? ''),
                      ReviewRow(label: AppStrings.reviewNote, value: d.familyNote),
                    ],
                  ),

                  // ข้อมูลผู้อุปการะ
                  SectionCard(
                    icon: '👤',
                    title: AppStrings.reviewGuardian,
                    children: [
                      _divRow(AppStrings.reviewFullName, d.guardianName),
                      _divRow(AppStrings.reviewRelation, d.guardianRelation ?? ''),
                      _divRow(AppStrings.reviewPhone, d.guardianPhone),
                      _divRow(AppStrings.reviewJob, d.guardianJob ?? ''),
                      ReviewRow(label: AppStrings.reviewIncome, value: d.guardianIncome ?? ''),
                    ],
                  ),

                  // เอกสาร
                  SectionCard(
                    icon: '📎',
                    title: AppStrings.reviewDocuments,
                    children: [
                      _fileRow(AppStrings.docIdCard,     d.idCardFile),
                      _fileRow(AppStrings.docPhoto,      d.photoFile),
                      _fileRow(AppStrings.docTranscript, d.transcriptFile),
                      _fileRow(AppStrings.docBankBook,   d.bankBookFile),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: FooterButtons(
        backLabel: AppStrings.btnBack, onBack: onBack,
        nextLabel: AppStrings.btnConfirm, onNext: onSubmit,
      ),
    );
  }

  Widget _divRow(String label, String value) => Column(
    children: [
      ReviewRow(label: label, value: value),
      const Divider(height: 1, color: Color(0xFFF3F4F6)),
    ],
  );

  Widget _fileRow(String label, String? file) {
    final hasFile = file != null && file.isNotEmpty;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: hasFile ? AppColors.primaryLight : const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: hasFile ? AppColors.primaryBorder : const Color(0xFFE5E7EB),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              hasFile ? '📄 $file' : label,
              style: TextStyle(
                fontSize: 13,
                color: hasFile ? AppColors.primaryDark : AppColors.textHint,
              ),
            ),
          ),
          if (hasFile)
            const Text('👁️', style: TextStyle(fontSize: 16, color: AppColors.primary)),
          if (!hasFile)
            const Text(AppStrings.noFile,
                style: TextStyle(fontSize: 12, color: AppColors.textHint)),
        ],
      ),
    );
  }
}
