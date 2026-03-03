import 'package:flutter/material.dart';
import '/coreApp/themeApp/app_colors.dart';
import '/coreApp/themeApp/app_text_style.dart';
import '/coreApp/widgets/scholarship_form_widget.dart';
import 'scholarship_form_step2.dart';

class ScholarshipFormStep1 extends StatefulWidget {
  const ScholarshipFormStep1({super.key});

  @override
  State<ScholarshipFormStep1> createState() => _ScholarshipFormStep1State();
}

class _ScholarshipFormStep1State extends State<ScholarshipFormStep1> {
  final _studentIdCtrl = TextEditingController(text: '663040127-7');
  final _nameCtrl = TextEditingController(text: 'ธนวัฒน์ ประเสริฐ');
  final _phoneCtrl = TextEditingController(text: '012-345-67xx');
  final _emailCtrl = TextEditingController(text: 'som.s@kkumail.com');
  final _addressCtrl = TextEditingController(
    text: '123 ถ.มิตรภาพ ต.ในเมือง อ.เมือง จ.ขอนแก่น 40000',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // ── ORANGE HEADER ──
          const FormHeader(
            title: 'สมัครขอทุนการศึกษา',
            subtitle: 'กรุณากรอกข้อมูลการสมัคร',
          ),
          // ── WHITE STEP BAR ──
          const StepIndicatorBar(currentStep: 1),
          // ── SCROLLABLE CONTENT ──
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
          // ── BOTTOM BUTTONS ──
          FormBottomButtons(
            onNext: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ScholarshipFormStep2()),
            ),
          ),
          const AppBottomNavBar(activeIndex: 1),
        ],
      ),
    );
  }
}
