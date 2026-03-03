import 'package:flutter/material.dart';

import '/coreApp/themeApp/app_colors.dart';
import '/coreApp/themeApp/app_text_style.dart';
import '/coreApp/constants/app_strings.dart';
import '/coreApp/constants/app_assets.dart';
import '/coreApp/widgets/custom_app_bar.dart';
import '/coreApp/widgets/form_input.dart';
import '/coreApp/widgets/primary_button.dart';
import '/features/student/models/scholarship_form_model.dart';

class Step3GuardianScreen extends StatefulWidget {
  const Step3GuardianScreen({
    super.key,
    required this.formData,
    required this.onNext,
    required this.onBack,
  });

  final ScholarshipFormModel formData;
  final ValueChanged<ScholarshipFormModel> onNext;
  final VoidCallback onBack;

  @override
  State<Step3GuardianScreen> createState() => _Step3GuardianScreenState();
}

class _Step3GuardianScreenState extends State<Step3GuardianScreen> {
  late final TextEditingController _name;
  late final TextEditingController _phone;
  String? _relation, _job, _income;

  @override
  void initState() {
    super.initState();
    final d = widget.formData;
    _name     = TextEditingController(text: d.guardianName);
    _phone    = TextEditingController(text: d.guardianPhone);
    _relation = d.guardianRelation;
    _job      = d.guardianJob;
    _income   = d.guardianIncome;
  }

  @override
  void dispose() {
    _name.dispose(); _phone.dispose();
    super.dispose();
  }

  void _handleNext() {
    widget.onNext(widget.formData.copyWith(
      guardianName:     _name.text,
      guardianPhone:    _phone.text,
      guardianRelation: _relation,
      guardianJob:      _job,
      guardianIncome:   _income,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          ScholarshipHeader(title: AppStrings.appName),
          const StepIndicatorBar(currentStep: 2),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 100),
              child: Column(
                children: [
                  AlertBanner(message: AppStrings.step3Alert),
                  SectionCard(
                    icon: '👤',
                    title: AppStrings.sectionGuardian,
                    children: [
                      FormField(
                        label: AppStrings.fieldGuardianName,
                        child: AppTextInput(controller: _name, hint: AppStrings.hintGuardianName),
                      ),
                      FormField(
                        label: AppStrings.fieldGuardianRelation,
                        child: AppDropdown(
                          value: _relation,
                          items: AppAssets.relationOptions,
                          onChanged: (v) => setState(() => _relation = v),
                        ),
                      ),
                      Row2(
                        left: FormField(
                          label: AppStrings.fieldPhone,
                          child: AppTextInput(controller: _phone, keyboardType: TextInputType.phone),
                        ),
                        right: FormField(
                          label: AppStrings.fieldJob,
                          child: AppDropdown(
                            value: _job,
                            items: AppAssets.jobOptions,
                            onChanged: (v) => setState(() => _job = v),
                          ),
                        ),
                      ),
                      FormField(
                        label: AppStrings.fieldIncome,
                        child: AppDropdown(
                          value: _income,
                          items: AppAssets.incomeOptions,
                          onChanged: (v) => setState(() => _income = v),
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
      bottomNavigationBar: FooterButtons(
        backLabel: AppStrings.btnBack, onBack: widget.onBack,
        nextLabel: AppStrings.btnNext, onNext: _handleNext,
      ),
    );
  }
}
