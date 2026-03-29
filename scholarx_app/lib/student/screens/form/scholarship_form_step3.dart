import 'package:flutter/material.dart';
import '/coreApp/themeApp/app_colors.dart';
import '/coreApp/widgets/scholarship_form_widget.dart';
import 'scholarship_form_step4.dart';

class ScholarshipFormStep3 extends StatefulWidget {
  const ScholarshipFormStep3({super.key});

  @override
  State<ScholarshipFormStep3> createState() => _ScholarshipFormStep3State();
}

class _ScholarshipFormStep3State extends State<ScholarshipFormStep3> {
  final _nameCtrl = TextEditingController(text: 'สุดสวย หสชัย');
  String _relationship = 'ป้า';
  final _phoneCtrl = TextEditingController(text: '081-212-2243');
  String _occupation = 'พนักงานราชการ';
  String _income = '15,000 - 30,000';

  final _relationships = [
    'บิดา',
    'มารดา',
    'ปู่',
    'ย่า',
    'ตา',
    'ยาย',
    'ป้า',
    'อา',
    'ลุง',
    'อื่นๆ',
  ];

  final _occupations = [
    'ค้าขาย',
    'แม่บ้าน',
    'พนักงานบริษัท',
    'พนักงานราชการ',
    'รับจ้าง',
    'เกษตรกร',
    'อื่นๆ',
  ];

  final _incomeRanges = [
    '0 - 15,000',
    '15,000 - 20,000',
    '15,000 - 30,000',
    '20,001 - 30,000',
    '30,001 - 50,000',
    '50,001 - 100,000',
    'มากกว่า 100,000',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const FormHeader(
            title: 'ผู้อุปการะ',
            subtitle: 'กรอกข้อมูลผู้อุปการะที่สามารถติดต่อได้ในกรณีฉุกเฉิน',
          ),
          const StepIndicatorBar(currentStep: 3),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const FormInfoBanner(
                    message:
                        'กรอกข้อมูลผู้อุปการะที่สามารถติดต่อได้ในกรณีฉุกเฉิน',
                  ),
FormSectionCard(
                    icon: Icons.person_outline,
                    iconBorderRadius: BorderRadius.circular(8), // ← เพิ่ม
                    title: 'ข้อมูลผู้อุปการะ',
                    children: [
                      FormTextField(
                        label: 'ชื่อจริง - นามสกุลผู้อุปการะ',
                        controller: _nameCtrl,
                        isRequired: false,
                      ),
                      const SizedBox(height: 14),
                      FormDropdown(
                        label: 'ความสัมพันธ์กับผู้สมัคร',
                        value: _relationship,
                        items: _relationships,
                        onChanged: (v) => setState(() => _relationship = v!),
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
                            child: FormDropdown(
                              label: 'อาชีพ',
                              value: _occupation,
                              items: _occupations,
                              onChanged: (v) =>
                                  setState(() => _occupation = v!),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      FormDropdown(
                        label: 'รายได้ต่อเดือน(บาท)',
                        value: _income,
                        items: _incomeRanges,
                        onChanged: (v) => setState(() => _income = v!),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          FormBottomButtons(
            onNext: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ScholarshipFormStep4()),
            ),
          ),
          const AppBottomNavBar(activeIndex: 1),
        ],
      ),
    );
  }
}
