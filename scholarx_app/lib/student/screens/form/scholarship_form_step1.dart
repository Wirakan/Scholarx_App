// ════════════════════════════════════════════════════════════
//  scholarship_form_step1.dart  (UPDATED)
//  — เก็บค่าจาก controller แล้วส่งต่อไป Step 2
// ════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import '/coreApp/themeApp/app_colors.dart';
import '/coreApp/themeApp/app_text_style.dart';
import '/coreApp/widgets/scholarship_form_widget.dart';
import '/student/models/student_model.dart';
import 'scholarship_form_step2.dart';
import 'scholarship_form_step5.dart'; // for ScholarshipFormData

class ScholarshipFormStep1 extends StatefulWidget {
  /// ข้อมูลทุนที่ผู้ใช้เลือก (ส่งมาจาก ScholarshipDetailScreen)
  final String scholarshipId;
  final String scholarshipName;
  final int amount;

  const ScholarshipFormStep1({
    super.key,
    required this.scholarshipId,
    required this.scholarshipName,
    required this.amount,
  });

  @override
  State<ScholarshipFormStep1> createState() => _ScholarshipFormStep1State();
}

class _ScholarshipFormStep1State extends State<ScholarshipFormStep1> {
  final _student = StudentModel.mock;

  late final _studentIdCtrl = TextEditingController(text: _student.studentId);
  late final _nameCtrl = TextEditingController(text: _student.fullName);
  late final _phoneCtrl = TextEditingController(text: '012-345-6789');
  late final _emailCtrl = TextEditingController(text: _student.email);
  final _addressCtrl = TextEditingController(
    text: '123 ถ.มิตรภาพ ต.ในเมือง อ.เมือง จ.ขอนแก่น 40000',
  );

  @override
  void dispose() {
    _studentIdCtrl.dispose();
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  void _goNext() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ScholarshipFormStep2(
          scholarshipId: widget.scholarshipId,
          scholarshipName: widget.scholarshipName,
          amount: widget.amount,
          studentId: _studentIdCtrl.text.trim(),
          fullName: _nameCtrl.text.trim(),
          phone: _phoneCtrl.text.trim(),
          email: _emailCtrl.text.trim(),
          address: _addressCtrl.text.trim(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const FormHeader(
            title: 'สมัครขอทุนการศึกษา',
            subtitle: 'กรุณากรอกข้อมูลการสมัคร',
          ),
          const StepIndicatorBar(currentStep: 1),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const FormInfoBanner(
                    message:
                        'กรุณาตรวจสอบความถูกต้องของข้อมูลก่อนกดถัดไป ข้อมูลที่มีเครื่องหมาย * จำเป็นต้องกรอก',
                  ),
                  FormSectionCard(
                    icon: Icons.person_outline,
                    iconBorderRadius: BorderRadius.circular(8),
                    title: 'ข้อมูลส่วนตัว',
                    children: [
                      FormTextField(
                        label: 'รหัสนักศึกษา',
                        controller: _studentIdCtrl,
                      ),
                      const SizedBox(height: 14),
                      FormTextField(
                        label: 'ชื่อจริง - นามสกุล',
                        controller: _nameCtrl,
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: FormTextField(
                              label: 'เบอร์โทรศัพท์',
                              controller: _phoneCtrl,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: FormTextField(
                              label: 'อีเมล',
                              controller: _emailCtrl,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  FormSectionCard(
                    icon: Icons.home_outlined,
                    iconBorderRadius: BorderRadius.circular(8),
                    title: 'ที่อยู่',
                    iconBgColor: const Color(0xFFFFF0E8),
                    children: [
                      FormTextField(
                        label: 'ที่อยู่ปัจจุบัน',
                        controller: _addressCtrl,
                        maxLines: 3,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          FormBottomButtons(onNext: _goNext),
          const AppBottomNavBar(activeIndex: 1),
        ],
      ),
    );
  }
}
