import 'package:flutter/material.dart';
import '/coreApp/themeApp/app_colors.dart';
import '/coreApp/themeApp/app_text_style.dart';
import '/coreApp/widgets/scholarship_form_widget.dart';
import '/shared/application_repository.dart';
import '/student/models/student_model.dart';
import 'scholarship_form_success.dart';

/// Step 5 — ตรวจสอบข้อมูล + Submit
/// รับ formData ที่รวบรวมมาตลอด 4 step
class ScholarshipFormStep5 extends StatelessWidget {
  final ScholarshipFormData formData;

  const ScholarshipFormStep5({super.key, required this.formData});

  ApplicationRecord _buildRecord() {
    final repo = ApplicationRepository.instance;
    final student = StudentModel.mock;
    return ApplicationRecord(
      id: repo.generateId(),
      scholarshipId: formData.scholarshipId,
      scholarshipName: formData.scholarshipName,
      amount: formData.amount,
      // ── Step 1 ──
      studentId: formData.studentId,
      fullName: formData.fullName,
      phone: formData.phone,
      email: formData.email,
      address: formData.address,
      // ── Step 2 ──
      fatherName: formData.fatherName,
      fatherPhone: formData.fatherPhone,
      fatherJob: formData.fatherJob,
      fatherIncome: formData.fatherIncome,
      motherName: formData.motherName,
      motherPhone: formData.motherPhone,
      motherJob: formData.motherJob,
      motherIncome: formData.motherIncome,
      familyStatus: formData.familyStatus,
      siblingCount: formData.siblingCount,
      applicantOrder: formData.applicantOrder,
      applicantIncome: formData.applicantIncome,
      totalFamilyIncome: formData.totalFamilyIncome,
      familyNote: formData.familyNote,
      // ── Step 3 ──
      guardianName: formData.guardianName,
      guardianRelation: formData.guardianRelation,
      guardianPhone: formData.guardianPhone,
      guardianJob: formData.guardianJob,
      guardianIncome: formData.guardianIncome,
      // ── Step 4 ──
      uploadedDocuments: formData.uploadedDocuments,
      // ── Student profile ──
      faculty: student.faculty,
      major: student.major,
      year: 'ปี 3',
      gpa: student.gpa,
      reason: formData.familyNote.isNotEmpty
          ? formData.familyNote
          : 'ต้องการทุนการศึกษาเพื่อสนับสนุนค่าใช้จ่ายในการเรียน',
      appliedAt: DateTime.now(),
      status: ApplicationStatus.pending,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const FormHeader(
            title: 'ตรวจสอบข้อมูล',
            subtitle: 'กรุณาตรวจสอบความถูกต้องของข้อมูลก่อนยืนยัน',
          ),
          const StepIndicatorBar(currentStep: 5),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const FormInfoBanner(
                    message: 'กรุณาตรวจสอบความถูกต้องของข้อมูลก่อนยืนยัน',
                  ),
                  // ── ข้อมูลส่วนตัว ──
                  _ReviewCard(
                    icon: Icons.person_outline,
                    title: 'ข้อมูลส่วนตัว',
                    rows: [
                      _ReviewRow('รหัสนักศึกษา', formData.studentId),
                      _ReviewRow('ชื่อ - นามสกุล', formData.fullName),
                      _ReviewRow('เบอร์โทรศัพท์', formData.phone),
                      _ReviewRow('อีเมล', formData.email),
                      _ReviewRow('ที่อยู่', formData.address),
                    ],
                  ),
                  // ── ข้อมูลครอบครัว ──
                  _ReviewCard(
                    icon: Icons.home_outlined,
                    title: 'ข้อมูลครอบครัว',
                    rows: [
                      _ReviewRow('ชื่อ - นามสกุลบิดา', formData.fatherName),
                      _ReviewRow('เบอร์โทร (บิดา)', formData.fatherPhone),
                      _ReviewRow('อาชีพ (บิดา)', formData.fatherJob),
                      _ReviewRow('รายได้ (บิดา)', formData.fatherIncome),
                      _ReviewRow('ชื่อ - นามสกุลมารดา', formData.motherName),
                      _ReviewRow('เบอร์โทร (มารดา)', formData.motherPhone),
                      _ReviewRow('อาชีพ (มารดา)', formData.motherJob),
                      _ReviewRow('รายได้ (มารดา)', formData.motherIncome),
                      _ReviewRow('สภาพครอบครัว', formData.familyStatus),
                      _ReviewRow('รายได้รวม (ปี)', formData.totalFamilyIncome),
                    ],
                  ),
                  // ── ผู้อุปการะ ──
                  _ReviewCard(
                    icon: Icons.person_outline,
                    title: 'ข้อมูลผู้อุปการะ',
                    rows: [
                      _ReviewRow('ชื่อ - นามสกุล', formData.guardianName),
                      _ReviewRow('ความสัมพันธ์', formData.guardianRelation),
                      _ReviewRow('เบอร์โทรศัพท์', formData.guardianPhone),
                      _ReviewRow('อาชีพ', formData.guardianJob),
                      _ReviewRow('รายได้', formData.guardianIncome),
                    ],
                  ),
                  // ── เอกสาร ──
                  _ReviewCard(
                    icon: Icons.upload_file_outlined,
                    title: 'อัปโหลดเอกสาร',
                    iconBg: const Color(0xFFFFF3E0),
                    rows: const [],
                    customChild: Column(
                      children: formData.uploadedDocuments
                          .map((f) => _DocReviewRow(f))
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          FormBottomButtons(
            nextLabel: 'ยืนยันการสมัคร',
            onNext: () {
              final record = _buildRecord().copyWith(
                status: ApplicationStatus.reviewing,
              );
              ApplicationRepository.instance.submit(record);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => ScholarshipFormSuccess(record: record),
                ),
                (route) => route.isFirst,
              );
            },
          ),
          const AppBottomNavBar(activeIndex: 1),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  DATA CARRIER — รวบรวมข้อมูลทุก step
// ─────────────────────────────────────────────
class ScholarshipFormData {
  // Scholarship info
  final String scholarshipId;
  final String scholarshipName;
  final int amount;

  // Step 1
  final String studentId;
  final String fullName;
  final String phone;
  final String email;
  final String address;

  // Step 2
  final String fatherName;
  final String fatherPhone;
  final String fatherJob;
  final String fatherIncome;
  final String motherName;
  final String motherPhone;
  final String motherJob;
  final String motherIncome;
  final String familyStatus;
  final String siblingCount;
  final String applicantOrder;
  final String applicantIncome;
  final String totalFamilyIncome;
  final String familyNote;

  // Step 3
  final String guardianName;
  final String guardianRelation;
  final String guardianPhone;
  final String guardianJob;
  final String guardianIncome;

  // Step 4
  final List<String> uploadedDocuments;

  const ScholarshipFormData({
    required this.scholarshipId,
    required this.scholarshipName,
    required this.amount,
    required this.studentId,
    required this.fullName,
    required this.phone,
    required this.email,
    required this.address,
    required this.fatherName,
    required this.fatherPhone,
    required this.fatherJob,
    required this.fatherIncome,
    required this.motherName,
    required this.motherPhone,
    required this.motherJob,
    required this.motherIncome,
    required this.familyStatus,
    required this.siblingCount,
    required this.applicantOrder,
    required this.applicantIncome,
    required this.totalFamilyIncome,
    required this.familyNote,
    required this.guardianName,
    required this.guardianRelation,
    required this.guardianPhone,
    required this.guardianJob,
    required this.guardianIncome,
    required this.uploadedDocuments,
  });
}

// ─────────────────────────────────────────────
//  LOCAL WIDGETS
// ─────────────────────────────────────────────
class _ReviewCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<_ReviewRow> rows;
  final Color iconBg;
  final Widget? customChild;

  const _ReviewCard({
    required this.icon,
    required this.title,
    required this.rows,
    this.iconBg = const Color(0xFFFFF0E8),
    this.customChild,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: AppColors.primary, size: 18),
              ),
              const SizedBox(width: 10),
              Text(title, style: AppTextStyle.title),
            ],
          ),
          const SizedBox(height: 12),
          if (customChild != null) customChild!,
          ...rows,
        ],
      ),
    );
  }
}

class _ReviewRow extends StatelessWidget {
  final String label;
  final String value;
  const _ReviewRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: AppTextStyle.caption.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyle.body.copyWith(color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}

class _DocReviewRow extends StatelessWidget {
  final String fileName;
  const _DocReviewRow(this.fileName);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.insert_drive_file_outlined,
            color: AppColors.primary,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(fileName, style: AppTextStyle.body)),
          const Icon(
            Icons.visibility_outlined,
            color: AppColors.primary,
            size: 18,
          ),
        ],
      ),
    );
  }
}
