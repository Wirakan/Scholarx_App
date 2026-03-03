import 'package:flutter/material.dart';
import '/coreApp/themeApp/app_colors.dart';
import '/coreApp/themeApp/app_text_style.dart';
import '/coreApp/widgets/scholarship_form_widget.dart';
import 'scholarship_form_success.dart';

class ScholarshipFormStep5 extends StatelessWidget {
  const ScholarshipFormStep5({super.key});

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
                  // Personal info
                  _ReviewCard(
                    icon: Icons.person_outline,
                    title: 'ข้อมูลส่วนตัว',
                    rows: const [
                      _ReviewRow('รหัสนักศึกษา', '663040127-7'),
                      _ReviewRow('นามสกุล', 'ธนวัฒน์ ประเสริฐ'),
                      _ReviewRow('เบอร์โทรศัพท์', '012-345-6789'),
                      _ReviewRow('อีเมล', 'thanawat.p@kkumail.com'),
                      _ReviewRow(
                        'ที่อยู่',
                        '123 ถ.มิตรภาพ ต.ในเมือง อ.เมือง จ.ขอนแก่น 40000',
                      ),
                    ],
                  ),
                  // Family info
                  _ReviewCard(
                    icon: Icons.home_outlined,
                    title: 'ข้อมูลครอบครัว',
                    rows: const [
                      _ReviewRow('ชื่อ - นามสกุลบิดา', 'สหรัฐ ประเสริฐ'),
                      _ReviewRow('เบอร์โทรศัพท์', '098-123-1456'),
                      _ReviewRow('อาชีพ', 'ค้าขาย'),
                      _ReviewRow('รายได้', '15,001 – 20,000'),
                      _ReviewRow('ชื่อ - นามสกุลมิดา', 'สุภัทรา ประเสริฐ'),
                      _ReviewRow('เบอร์โทรศัพท์', '098-765-5555'),
                      _ReviewRow('อาชีพ', 'แม่บ้าน'),
                      _ReviewRow('รายได้', '0 - 15,000'),
                      _ReviewRow('สภาพครอบครัว', 'อยู่ด้วยกัน'),
                      _ReviewRow(
                        'รายได้ของผู้ครอบครัวต่อเดือน(บาท)',
                        '20,001 – 30,000',
                      ),
                      _ReviewRow(
                        'รายได้รวมของครอบครัว(บาท/ปี)',
                        '200,000 - 300,000',
                      ),
                      _ReviewRow(
                        'ข้อมูลเพิ่มเติม',
                        'ครอบครัวมีรายได้หลักจากบิดาเพียงคนเดียวและมีภาระค่าใช้จ่ายด้านการศึกษาและค่าครองชีพที่ต้องการความช่วยเหลือด้านทุนการศึกษา',
                      ),
                    ],
                  ),
                  // Guardian info
                  _ReviewCard(
                    icon: Icons.person_outline,
                    title: 'ข้อมูลผู้อุปการะ',
                    rows: const [
                      _ReviewRow('ชื่อ - นามสกุลผู้อุปการะ:', 'สมชาย ประเสริฐ'),
                      _ReviewRow('ความสัมพันธ์กับผู้สมัคร', 'บิดา'),
                      _ReviewRow('เบอร์โทรศัพท์', '098-765-4321'),
                      _ReviewRow('อาชีพ', 'พนักงานบริษัทเอกชน'),
                      _ReviewRow('รายได้', '15,001 – 20,000'),
                    ],
                  ),
                  // Documents
                  _ReviewCard(
                    icon: Icons.upload_file_outlined,
                    title: 'อัปโหลดเอกสาร',
                    iconBg: const Color(0xFFFFF3E0),
                    rows: const [],
                    customChild: Column(
                      children: [
                        _DocReviewRow('สำเนาบัตรประชาชน.pdf'),
                        _DocReviewRow('รูปถ่ายหน้าตรง.JPEG'),
                        _DocReviewRow('ใบแสดงผลการเรียน.pdf'),
                        _DocReviewRow('สำเนาสมุดบัญชีธนาคาร.JPEG'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          FormBottomButtons(
            nextLabel: 'ยืนยัน',
            onNext: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const ScholarshipFormSuccess()),
              (route) => route.isFirst,
            ),
          ),
          const AppBottomNavBar(activeIndex: 1),
        ],
      ),
    );
  }
}

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
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppColors.primary, size: 18),
              ),
              const SizedBox(width: 10),
              Text(title, style: AppTextStyle.title),
            ],
          ),
          const SizedBox(height: 12),
          if (customChild != null) customChild!,
          ...rows.map((r) => r),
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
