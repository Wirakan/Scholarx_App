import 'package:flutter/material.dart';

import '/coreApp/themeApp/app_colors.dart';
import '/coreApp/themeApp/app_text_style.dart';
import '/coreApp/constants/app_strings.dart';
import '/coreApp/widgets/custom_app_bar.dart';
import '/coreApp/widgets/form_input.dart';
import '/coreApp/widgets/primary_button.dart';
import '/features/student/models/scholarship_form_model.dart';

class _DocItem {
  final String key;
  final String label;
  const _DocItem(this.key, this.label);
}

const _docs = [
  _DocItem('idCard',     AppStrings.docIdCard),
  _DocItem('photo',      AppStrings.docPhoto),
  _DocItem('transcript', AppStrings.docTranscript),
  _DocItem('bankBook',   AppStrings.docBankBook),
];

class Step4DocumentScreen extends StatefulWidget {
  const Step4DocumentScreen({
    super.key,
    required this.formData,
    required this.onNext,
    required this.onBack,
  });

  final ScholarshipFormModel formData;
  final ValueChanged<ScholarshipFormModel> onNext;
  final VoidCallback onBack;

  @override
  State<Step4DocumentScreen> createState() => _Step4DocumentScreenState();
}

class _Step4DocumentScreenState extends State<Step4DocumentScreen> {
  late Map<String, String?> _files;

  @override
  void initState() {
    super.initState();
    final d = widget.formData;
    _files = {
      'idCard':     d.idCardFile,
      'photo':      d.photoFile,
      'transcript': d.transcriptFile,
      'bankBook':   d.bankBookFile,
    };
  }

  void _pickFile(String key) {
    // In real app: use file_picker package
    // Simulate picking a file
    setState(() => _files[key] = '${key}_document.pdf');
  }

  void _removeFile(String key) => setState(() => _files[key] = null);

  void _handleNext() {
    widget.onNext(widget.formData.copyWith(
      idCardFile:     _files['idCard'],
      photoFile:      _files['photo'],
      transcriptFile: _files['transcript'],
      bankBookFile:   _files['bankBook'],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          ScholarshipHeader(title: AppStrings.appName),
          const StepIndicatorBar(currentStep: 3),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 100),
              child: Column(
                children: [
                  AlertBanner(message: AppStrings.step4Alert),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.cardBg,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 4),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: List.generate(_docs.length, (i) {
                        final doc  = _docs[i];
                        final file = _files[doc.key];
                        final isLast = i == _docs.length - 1;
                        return Column(
                          children: [
                            _DocUploadRow(
                              label: doc.label,
                              fileName: file,
                              onPick: () => _pickFile(doc.key),
                              onRemove: () => _removeFile(doc.key),
                            ),
                            if (!isLast) ...[
                              const SizedBox(height: 14),
                              const Divider(height: 1, color: Color(0xFFF3F4F6)),
                              const SizedBox(height: 14),
                            ],
                          ],
                        );
                      }),
                    ),
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

class _DocUploadRow extends StatelessWidget {
  const _DocUploadRow({
    required this.label,
    required this.fileName,
    required this.onPick,
    required this.onRemove,
  });

  final String label;
  final String? fileName;
  final VoidCallback onPick;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(children: [
            TextSpan(text: label, style: AppTextStyle.uploadTitle),
            const TextSpan(text: '*', style: TextStyle(color: AppColors.primary, fontSize: 14)),
          ]),
        ),
        const SizedBox(height: 3),
        Text(AppStrings.uploadSizeHint, style: AppTextStyle.uploadHint),
        const SizedBox(height: 8),
        if (fileName != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.primaryBorder),
            ),
            child: Row(
              children: [
                const Text('📄 ', style: TextStyle(fontSize: 13)),
                Expanded(child: Text(fileName!, style: AppTextStyle.uploadedFile)),
                GestureDetector(
                  onTap: onRemove,
                  child: const Text('🗑️', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          )
        else
          Row(
            children: [
              Expanded(
                child: _UploadBtn(
                  label: AppStrings.btnSelectFile,
                  onTap: onPick,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _UploadBtn(
                  label: AppStrings.btnCamera,
                  onTap: onPick,
                ),
              ),
            ],
          ),
      ],
    );
  }
}

class _UploadBtn extends StatelessWidget {
  const _UploadBtn({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.primary, width: 1.5),
        ),
        alignment: Alignment.center,
        child: Text(label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            )),
      ),
    );
  }
}
