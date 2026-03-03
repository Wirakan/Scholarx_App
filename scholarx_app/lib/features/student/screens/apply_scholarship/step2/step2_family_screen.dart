import 'package:flutter/material.dart';

import '/coreApp/themeApp/app_colors.dart';
import '/coreApp/themeApp/app_text_style.dart';
import '/coreApp/constants/app_strings.dart';
import '/coreApp/constants/app_assets.dart';
import '/coreApp/widgets/custom_app_bar.dart';
import '/coreApp/widgets/form_input.dart';
import '/coreApp/widgets/primary_button.dart';
import '/features/student/models/scholarship_form_model.dart';

class Step2FamilyScreen extends StatefulWidget {
  const Step2FamilyScreen({
    super.key,
    required this.formData,
    required this.onNext,
    required this.onBack,
  });

  final ScholarshipFormModel formData;
  final ValueChanged<ScholarshipFormModel> onNext;
  final VoidCallback onBack;

  @override
  State<Step2FamilyScreen> createState() => _Step2FamilyScreenState();
}

class _Step2FamilyScreenState extends State<Step2FamilyScreen> {
  late final TextEditingController _fatherName;
  late final TextEditingController _fatherPhone;
  late final TextEditingController _motherName;
  late final TextEditingController _motherPhone;
  late final TextEditingController _familyNote;

  String? _fatherJob, _fatherIncome;
  String? _motherJob, _motherIncome;
  String? _familyStatus, _siblings, _siblingOrder;
  String? _applicantIncome, _familyIncome;

  @override
  void initState() {
    super.initState();
    final d = widget.formData;
    _fatherName  = TextEditingController(text: d.fatherName);
    _fatherPhone = TextEditingController(text: d.fatherPhone);
    _motherName  = TextEditingController(text: d.motherName);
    _motherPhone = TextEditingController(text: d.motherPhone);
    _familyNote  = TextEditingController(text: d.familyNote);
    _fatherJob   = d.fatherJob;   _fatherIncome = d.fatherIncome;
    _motherJob   = d.motherJob;   _motherIncome = d.motherIncome;
    _familyStatus = d.familyStatus; _siblings = d.siblings;
    _siblingOrder = d.siblingOrder; _applicantIncome = d.applicantIncome;
    _familyIncome = d.familyIncome;
  }

  @override
  void dispose() {
    _fatherName.dispose(); _fatherPhone.dispose();
    _motherName.dispose(); _motherPhone.dispose(); _familyNote.dispose();
    super.dispose();
  }

  void _handleNext() {
    widget.onNext(widget.formData.copyWith(
      fatherName: _fatherName.text, fatherPhone: _fatherPhone.text,
      fatherJob: _fatherJob, fatherIncome: _fatherIncome,
      motherName: _motherName.text, motherPhone: _motherPhone.text,
      motherJob: _motherJob, motherIncome: _motherIncome,
      familyStatus: _familyStatus, siblings: _siblings,
      siblingOrder: _siblingOrder, applicantIncome: _applicantIncome,
      familyIncome: _familyIncome, familyNote: _familyNote.text,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          ScholarshipHeader(title: AppStrings.appName),
          const StepIndicatorBar(currentStep: 1),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 100),
              child: Column(
                children: [
                  AlertBanner(message: AppStrings.step2Alert),

                  // บิดา
                  SectionCard(
                    icon: '👨',
                    title: AppStrings.sectionFather,
                    children: [
                      FormField(label: AppStrings.fieldFatherName, required: true,
                        child: AppTextInput(controller: _fatherName)),
                      Row2(
                        left: FormField(label: AppStrings.fieldPhone, required: true,
                          child: AppTextInput(controller: _fatherPhone, keyboardType: TextInputType.phone)),
                        right: FormField(label: AppStrings.fieldJob, required: true,
                          child: AppDropdown(value: _fatherJob, items: AppAssets.jobOptions,
                            onChanged: (v) => setState(() => _fatherJob = v))),
                      ),
                      FormField(label: AppStrings.fieldIncome, required: true,
                        child: AppDropdown(value: _fatherIncome, items: AppAssets.incomeOptions,
                          onChanged: (v) => setState(() => _fatherIncome = v))),
                    ],
                  ),

                  // มารดา
                  SectionCard(
                    icon: '👩',
                    title: AppStrings.sectionMother,
                    children: [
                      FormField(label: AppStrings.fieldMotherName, required: true,
                        child: AppTextInput(controller: _motherName)),
                      Row2(
                        left: FormField(label: AppStrings.fieldPhone, required: true,
                          child: AppTextInput(controller: _motherPhone, keyboardType: TextInputType.phone)),
                        right: FormField(label: AppStrings.fieldJob, required: true,
                          child: AppDropdown(value: _motherJob, items: AppAssets.jobOptions,
                            onChanged: (v) => setState(() => _motherJob = v))),
                      ),
                      FormField(label: AppStrings.fieldIncome, required: true,
                        child: AppDropdown(value: _motherIncome, items: AppAssets.incomeOptions,
                          onChanged: (v) => setState(() => _motherIncome = v))),
                    ],
                  ),

                  // สถานะครอบครัว
                  SectionCard(
                    icon: '❤️',
                    title: AppStrings.sectionFamilyStatus,
                    children: [
                      FormField(label: AppStrings.fieldFamilyStatus, required: true,
                        child: AppDropdown(value: _familyStatus, items: AppAssets.familyStatusOptions,
                          onChanged: (v) => setState(() => _familyStatus = v))),
                      Row2(
                        left: FormField(label: AppStrings.fieldSiblingCount, required: true,
                          child: AppDropdown(value: _siblings, items: AppAssets.siblingOptions,
                            onChanged: (v) => setState(() => _siblings = v))),
                        right: FormField(label: AppStrings.fieldSiblingOrder, required: true,
                          child: AppDropdown(value: _siblingOrder, items: AppAssets.siblingOptions,
                            onChanged: (v) => setState(() => _siblingOrder = v))),
                      ),
                      FormField(label: AppStrings.fieldApplicantIncome, required: true,
                        child: AppDropdown(value: _applicantIncome, items: AppAssets.incomeOptions,
                          onChanged: (v) => setState(() => _applicantIncome = v))),
                      FormField(label: AppStrings.fieldFamilyIncome, required: true,
                        child: AppDropdown(value: _familyIncome, items: AppAssets.familyIncomeOptions,
                          onChanged: (v) => setState(() => _familyIncome = v))),
                      FormField(label: AppStrings.fieldNote,
                        child: AppTextInput(controller: _familyNote, hint: AppStrings.hintNote, maxLines: 4)),
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
