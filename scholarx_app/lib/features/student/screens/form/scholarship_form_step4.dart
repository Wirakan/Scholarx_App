import 'package:flutter/material.dart';
import '/coreApp/themeApp/app_colors.dart';
import '/coreApp/themeApp/app_text_style.dart';
import '/coreApp/widgets/scholarship_form_widget.dart';
import 'scholarship_form_step5.dart';

// Document upload status
enum _UploadStatus { empty, uploading, done }

class _DocItem {
  final String title;
  final bool isRequired;
  _UploadStatus status;
  String? fileName;
  double progress;

  _DocItem({
    required this.title,
    this.isRequired = true,
    this.status = _UploadStatus.empty,
    this.fileName,
    this.progress = 0,
  });
}

class ScholarshipFormStep4 extends StatefulWidget {
  const ScholarshipFormStep4({super.key});

  @override
  State<ScholarshipFormStep4> createState() => _ScholarshipFormStep4State();
}

class _ScholarshipFormStep4State extends State<ScholarshipFormStep4> {
  final List<_DocItem> _docs = [
    _DocItem(
      title: 'สำเนาบัตรประชาชน',
      status: _UploadStatus.done,
      fileName: 'id_card_scan.jpg',
    ),
    _DocItem(
      title: 'รูปถ่ายหน้าตรง (พื้นหลังสุภาพ)',
      status: _UploadStatus.uploading,
      progress: 0.8,
    ),
    _DocItem(
      title: 'ใบแสดงผลการเรียน (Transcript)',
      status: _UploadStatus.empty,
    ),
    _DocItem(
      title: 'สำเนาสมุดบัญชีธนาคาร',
      status: _UploadStatus.done,
      fileName: 'bank_copy.pdf',
    ),
  ];

  void _simulateUpload(int index) {
    setState(() {
      _docs[index].status = _UploadStatus.uploading;
      _docs[index].progress = 0.3;
    });
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _docs[index].status = _UploadStatus.done;
          _docs[index].fileName = 'document_${index + 1}.pdf';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const FormHeader(
            title: 'แนบเอกสาร',
            subtitle: 'อัปโหลดเอกสารประกอบการสมัครให้ครบถ้วน',
          ),
          const StepIndicatorBar(currentStep: 4),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF3E0),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: AppColors.primary,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'โปรดอัปโหลดให้ครบก่อนดำเนินการต่อ',
                            style: AppTextStyle.caption.copyWith(
                              color: AppColors.primaryDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                    child: RichText(
                      text: TextSpan(
                        text: 'แนบเอกสาร',
                        style: AppTextStyle.title,
                        children: const [
                          TextSpan(
                            text: ' *',
                            style: TextStyle(color: AppColors.error),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ..._docs.asMap().entries.map(
                    (e) => _DocUploadCard(
                      item: e.value,
                      onUpload: () => _simulateUpload(e.key),
                      onDelete: () => setState(() {
                        e.value.status = _UploadStatus.empty;
                        e.value.fileName = null;
                      }),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          FormBottomButtons(
            onNext: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ScholarshipFormStep5()),
            ),
          ),
          const AppBottomNavBar(activeIndex: 1),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Individual document upload card
// ─────────────────────────────────────────────
class _DocUploadCard extends StatelessWidget {
  final _DocItem item;
  final VoidCallback onUpload;
  final VoidCallback onDelete;

  const _DocUploadCard({
    required this.item,
    required this.onUpload,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: item.title,
              style: AppTextStyle.bodyMedium,
              children: item.isRequired
                  ? [
                      const TextSpan(
                        text: '*',
                        style: TextStyle(color: AppColors.error),
                      ),
                    ]
                  : [],
            ),
          ),
          Text(
            'PNG, JPG หรือ PDF  ขนาดสูงสุด 5MB',
            style: AppTextStyle.caption,
          ),
          const SizedBox(height: 10),
          if (item.status == _UploadStatus.done && item.fileName != null)
            _DoneRow(fileName: item.fileName!, onDelete: onDelete)
          else if (item.status == _UploadStatus.uploading)
            _UploadingRow(progress: item.progress)
          else
            _UploadButtons(onUpload: onUpload),
        ],
      ),
    );
  }
}

class _DoneRow extends StatelessWidget {
  final String fileName;
  final VoidCallback onDelete;

  const _DoneRow({required this.fileName, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              fileName,
              style: AppTextStyle.body.copyWith(color: AppColors.textSecondary),
            ),
          ),
          GestureDetector(
            onTap: onDelete,
            child: Icon(
              Icons.delete_outline,
              color: AppColors.textTertiary,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class _UploadingRow extends StatelessWidget {
  final double progress;
  const _UploadingRow({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.border,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            minHeight: 8,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'กำลังอัปโหลด... ${(progress * 100).toInt()}%',
          style: AppTextStyle.caption.copyWith(color: AppColors.primary),
        ),
      ],
    );
  }
}

class _UploadButtons extends StatelessWidget {
  final VoidCallback onUpload;
  const _UploadButtons({required this.onUpload});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onUpload,
            icon: const Icon(Icons.folder_open_outlined, size: 16),
            label: const Text('เลือกไฟล์'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 10),
              textStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onUpload,
            icon: const Icon(Icons.camera_alt_outlined, size: 16),
            label: const Text('ถ่ายภาพ'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 10),
              textStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
