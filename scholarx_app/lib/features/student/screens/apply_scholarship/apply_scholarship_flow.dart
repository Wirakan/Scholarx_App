import 'package:flutter/material.dart';
import '../../models/scholarship_form_model.dart';
import '../apply_scholarship/step1/step1_personal_screen.dart';
import '../apply_scholarship/step2/step2_family_screen.dart';
import '../apply_scholarship/step3/step3_guardian_screen.dart';
import '../apply_scholarship/step4/step4_document_screen.dart';
import '../apply_scholarship/step5/step5_review_screen.dart';
import '../apply_scholarship/success/success_screen.dart';

/// Widget ที่ควบคุม flow ทั้ง 5 step + success
class ApplyScholarshipFlow extends StatefulWidget {
  const ApplyScholarshipFlow({super.key});

  @override
  State<ApplyScholarshipFlow> createState() => _ApplyScholarshipFlowState();
}

class _ApplyScholarshipFlowState extends State<ApplyScholarshipFlow> {
  int _step = 0;
  bool _done = false;

  ScholarshipFormModel _form = ScholarshipFormModel(
    // Default / prefill values (ลบออกได้ใน production)
    studentId:    '663040127-7',
    fullName:     'ธนวัฒน์ ประเสริฐ',
    phone:        '012-345-67xx',
    email:        'som.s@kkumail.com',
    address:      '123 ถ.มิตรภาพ ต.ในเมือง อ.เมือง จ.ขอนแก่น 40000',
    fatherName:   'สหรัฐ ประเสริฐ',
    fatherPhone:  '098-123-1456',
    fatherJob:    'ค้าขาย',
    fatherIncome: '15,000 - 20,000',
    motherName:   'สุภัทรา ประเสริฐ',
    motherPhone:  '098-765-5555',
    motherJob:    'แม่บ้าน',
    motherIncome: '0 - 15,000',
    familyStatus: 'บิดา - มารดา อยู่ด้วยกัน',
    siblings:     '1',
    siblingOrder: '1',
    applicantIncome: '15,000 - 20,000',
    familyIncome: '200,000 - 300,000',
    familyNote:   'ครอบครัวมีรายได้หลักจากบิดาเพียงคนเดียว',
    guardianName:     'สุดสวย สหชัย',
    guardianRelation: 'ป้า',
    guardianPhone:    '081-212-2243',
    guardianJob:      'พนักงานราชการ',
    guardianIncome:   '15,000 - 30,000',
    idCardFile:   'id_card_scan.jpg',
    bankBookFile: 'bank_copy.pdf',
  );

  void _goTo(int step, ScholarshipFormModel updated) {
    setState(() {
      _form = updated;
      _step = step;
    });
  }

  void _reset() => setState(() { _done = false; _step = 0; });

  @override
  Widget build(BuildContext context) {
    if (_done) {
      return SuccessScreen(onHome: _reset);
    }

    return switch (_step) {
      0 => Step1PersonalScreen(
          formData: _form,
          onNext: (updated) => _goTo(1, updated),
        ),
      1 => Step2FamilyScreen(
          formData: _form,
          onNext: (updated) => _goTo(2, updated),
          onBack: () => setState(() => _step = 0),
        ),
      2 => Step3GuardianScreen(
          formData: _form,
          onNext: (updated) => _goTo(3, updated),
          onBack: () => setState(() => _step = 1),
        ),
      3 => Step4DocumentScreen(
          formData: _form,
          onNext: (updated) => _goTo(4, updated),
          onBack: () => setState(() => _step = 2),
        ),
      4 => Step5ReviewScreen(
          formData: _form,
          onSubmit: () => setState(() => _done = true),
          onBack: () => setState(() => _step = 3),
        ),
      _ => const SizedBox.shrink(),
    };
  }
}
