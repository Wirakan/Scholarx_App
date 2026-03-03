import 'package:flutter/material.dart';

// shared core imports (absolute paths) make navigation between
// features easier and avoid fragile relative path bugs.
import '/coreApp/themeApp/app_colors.dart';
import '/coreApp/themeApp/app_text_style.dart';
import '/coreApp/constants/app_strings.dart';
import '/coreApp/widgets/custom_app_bar.dart';
import '/coreApp/widgets/form_input.dart';
import '/coreApp/widgets/primary_button.dart';
import '/features/student/models/scholarship_form_model.dart';

class Step1PersonalScreen extends StatefulWidget {
  const Step1PersonalScreen({
    super.key,
    required this.formData,
    required this.onNext,
  });

  final ScholarshipFormModel formData;
  final ValueChanged<ScholarshipFormModel> onNext;

  @override
  State<Step1PersonalScreen> createState() => _Step1PersonalScreenState();
}

class _Step1PersonalScreenState extends State<Step1PersonalScreen> {
  late final TextEditingController _studentId;
  late final TextEditingController _fullName;
  late final TextEditingController _phone;
  late final TextEditingController _email;
  late final TextEditingController _address;

  @override
  void initState() {
    super.initState();
    final d = widget.formData;
    _studentId = TextEditingController(text: d.studentId);
    _fullName = TextEditingController(text: d.fullName);
    _phone = TextEditingController(text: d.phone);
    _email = TextEditingController(text: d.email);
    _address = TextEditingController(text: d.address);
  }

  @override
  void dispose() {
    _studentId.dispose();
    _fullName.dispose();
    _phone.dispose();
    _email.dispose();
    _address.dispose();
    super.dispose();
  }

  void _handleNext() {
    final updated = widget.formData.copyWith(
      studentId: _studentId.text,
      fullName: _fullName.text,
      phone: _phone.text,
      email: _email.text,
      address: _address.text,
    );
    widget.onNext(updated);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // ① Orange header
          ScholarshipHeader(title: AppStrings.appName),

          // ② White step bar
          const StepIndicatorBar(currentStep: 0),

          // ③ Scrollable content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 100),
              child: Column(
                children: [
                  AlertBanner(message: AppStrings.step1Alert),

                  SectionCard(
                    icon: '👤',
                    title: AppStrings.sectionPersonal,
                    children: [
                      FormField(
                        label: AppStrings.fieldStudentId,
                        required: true,
                        child: AppTextInput(
                          controller: _studentId,
                          hint: AppStrings.hintStudentId,
                        ),
                      ),
                      FormField(
                        label: AppStrings.fieldFullName,
                        required: true,
                        child: AppTextInput(
                          controller: _fullName,
                          hint: AppStrings.hintFullName,
                        ),
                      ),
                      Row2(
                        left: FormField(
                          label: AppStrings.fieldPhone,
                          required: true,
                          child: AppTextInput(
                            controller: _phone,
                            hint: AppStrings.hintPhone,
                            keyboardType: TextInputType.phone,
                          ),
                        ),
                        right: FormField(
                          label: AppStrings.fieldEmail,
                          required: true,
                          child: AppTextInput(
                            controller: _email,
                            hint: AppStrings.hintEmail,
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SectionCard(
                    icon: '🏠',
                    title: AppStrings.sectionAddress,
                    children: [
                      FormField(
                        label: AppStrings.fieldAddress,
                        required: true,
                        child: AppTextInput(
                          controller: _address,
                          hint: AppStrings.hintAddress,
                          maxLines: 3,
                          keyboardType: TextInputType.multiline,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // ④ Fixed footer
      bottomNavigationBar: FooterButtons(
        nextLabel: AppStrings.btnNext,
        onNext: _handleNext,
      ),
    );
  }
}
