import 'package:flutter/material.dart';
import '/coreApp/themeApp/app_colors.dart';
import '/coreApp/widgets/scholarship_form_widget.dart';
import 'scholarship_form_step3.dart';

class ScholarshipFormStep2 extends StatefulWidget {
  const ScholarshipFormStep2({super.key});

  @override
  State<ScholarshipFormStep2> createState() => _ScholarshipFormStep2State();
}

class _ScholarshipFormStep2State extends State<ScholarshipFormStep2> {
  // Father
  final _fatherNameCtrl = TextEditingController(text: 'สหรัฐ ประเสริฐ');
  final _fatherPhoneCtrl = TextEditingController(text: '098-123-1456');
  String _fatherOccupation = 'ค้าขาย';
  String _fatherIncome = '15,000 - 20,000';

  // Mother
  final _motherNameCtrl = TextEditingController(text: 'สุภัทรา ประเสริฐ');
  final _motherPhoneCtrl = TextEditingController(text: '098-765-5555');
  String _motherOccupation = 'แม่บ้าน';
  String _motherIncome = '0 - 15,000';

  // Family status
  String _familyStatus = 'บิดา - มารดา อยู่ด้วยกัน';
  String _siblingCount = '1';
  String _applicantOrder = '1';
  String _applicantIncome = '15,000 - 20,000';
  String _totalFamilyIncome = '200,000 - 300,000';
  final _additionalInfoCtrl = TextEditingController(
    text:
        'ครอบครัวมีรายได้หลักจากบิดาเพียงคนเดียวและมีภาระค่าใช้จ่ายด้านการศึกษาและค่าครองชีพที่ต้องการความช่วยเหลือด้านทุนการศึกษา',
  );

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
    '20,001 - 30,000',
    '30,001 - 50,000',
    '50,001 - 100,000',
    'มากกว่า 100,000',
  ];

  final _familyStatuses = [
    'บิดา - มารดา อยู่ด้วยกัน',
    'บิดาเสียชีวิต',
    'มารดาเสียชีวิต',
    'บิดา - มารดาแยกทางกัน',
    'อื่นๆ',
  ];

  final _totalIncomes = [
    '0 - 50,000',
    '50,001 - 100,000',
    '100,001 - 200,000',
    '200,000 - 300,000',
    '300,001 - 500,000',
    'มากกว่า 500,000',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const FormHeader(
            title: 'ข้อมูลครอบครัว',
            subtitle: 'กรอกข้อมูลครอบครัวให้ครบถ้วนเพื่อประกอบการพิจารณาทุน',
          ),
          const StepIndicatorBar(currentStep: 2),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const FormInfoBanner(
                    message:
                        'กรอกข้อมูลครอบครัวให้ครบถ้วนเพื่อประกอบการพิจารณาทุน',
                  ),
                  // FATHER
// FATHER
                  FormSectionCard(
                    icon: Icons.person_outline,
                    iconBorderRadius: BorderRadius.circular(8), // ← เพิ่ม
                    title: 'ข้อมูลบิดา',
                    children: [
                      FormTextField(
                        label: 'ชื่อจริง-นามสกุลบิดา',
                        controller: _fatherNameCtrl,
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: FormTextField(
                              label: 'เบอร์โทรศัพท์',
                              controller: _fatherPhoneCtrl,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: FormDropdown(
                              label: 'อาชีพ',
                              value: _fatherOccupation,
                              items: _occupations,
                              onChanged: (v) =>
                                  setState(() => _fatherOccupation = v!),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      FormDropdown(
                        label: 'รายได้ต่อเดือน(บาท)',
                        value: _fatherIncome,
                        items: _incomeRanges,
                        onChanged: (v) => setState(() => _fatherIncome = v!),
                      ),
                    ],
                  ),
                  // MOTHER
                  FormSectionCard(
                    icon: Icons.person_outline,
                    iconBorderRadius: BorderRadius.circular(8), // ← เพิ่ม
                    title: 'ข้อมูลมารดา',
                    children: [
                      FormTextField(
                        label: 'ชื่อจริง-นามสกุลมารดา',
                        controller: _motherNameCtrl,
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: FormTextField(
                              label: 'เบอร์โทรศัพท์',
                              controller: _motherPhoneCtrl,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: FormDropdown(
                              label: 'อาชีพ',
                              value: _motherOccupation,
                              items: _occupations,
                              onChanged: (v) =>
                                  setState(() => _motherOccupation = v!),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      FormDropdown(
                        label: 'รายได้ต่อเดือน(บาท)',
                        value: _motherIncome,
                        items: _incomeRanges,
                        onChanged: (v) => setState(() => _motherIncome = v!),
                      ),
                    ],
                  ),
                  // FAMILY STATUS
                  FormSectionCard(
                    icon: Icons.favorite_outline,
                    iconBorderRadius: BorderRadius.circular(8), // ← เพิ่ม
                    title: 'สถานะครอบครัว',
                    iconBgColor: const Color(0xFFFFF0F0),
                    children: [
                      FormDropdown(
                        label: 'สถาพครอบครัว',
                        value: _familyStatus,
                        items: _familyStatuses,
                        onChanged: (v) => setState(() => _familyStatus = v!),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: FormDropdown(
                              label: 'จำนวนพี่น้อง(รวมผู้สมัคร)',
                              value: _siblingCount,
                              items: ['1', '2', '3', '4', '5', '6+'],
                              onChanged: (v) =>
                                  setState(() => _siblingCount = v!),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: FormDropdown(
                              label: 'ผู้สมัครเป็นลำดับที่',
                              value: _applicantOrder,
                              items: ['1', '2', '3', '4', '5', '6+'],
                              onChanged: (v) =>
                                  setState(() => _applicantOrder = v!),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      FormDropdown(
                        label: 'รายได้ที่ผู้สมัครได้รับต่อเดือน(บาท)',
                        value: _applicantIncome,
                        items: _incomeRanges,
                        onChanged: (v) => setState(() => _applicantIncome = v!),
                      ),
                      const SizedBox(height: 14),
                      FormDropdown(
                        label: 'รายได้รวมครอบครัว(บาท/ปี)',
                        value: _totalFamilyIncome,
                        items: _totalIncomes,
                        onChanged: (v) =>
                            setState(() => _totalFamilyIncome = v!),
                      ),
                      const SizedBox(height: 14),
                      FormTextField(
                        label: 'ข้อมูลเพิ่มเติม',
                        controller: _additionalInfoCtrl,
                        maxLines: 4,
                        isRequired: false,
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
              MaterialPageRoute(builder: (_) => const ScholarshipFormStep3()),
            ),
          ),
          const AppBottomNavBar(activeIndex: 1),
        ],
      ),
    );
  }
}
