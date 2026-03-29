// ════════════════════════════════════════════════════════════
//  scholarship_form_step4.dart  (UPDATED)
// ════════════════════════════════════════════════════════════
import 'package:flutter/material.dart' hide FormState;
import '/coreApp/themeApp/app_colors.dart';
import '/coreApp/themeApp/app_text_style.dart';
import '/coreApp/widgets/scholarship_form_widget.dart';
import 'scholarship_form_step5.dart';

enum _UploadStatus { empty, uploading, done }

class _DocItem {
  final String title;
  final bool isRequired;
  _UploadStatus status;
  String? fileName;

  _DocItem({
    required this.title,
    this.isRequired = true,
    this.status = _UploadStatus.empty,
    this.fileName,
  });
}

class ScholarshipFormStep4 extends StatefulWidget {
  // ── รับทุก field จาก Step 1-3 ──
  final String scholarshipId, scholarshipName;
  final int amount;
  final String studentId, fullName, phone, email, address;
  final String fatherName, fatherPhone, fatherJob, fatherIncome;
  final String motherName, motherPhone, motherJob, motherIncome;
  final String familyStatus, siblingCount, applicantOrder;
  final String applicantIncome, totalFamilyIncome, familyNote;
  final String guardianName, guardianRelation, guardianPhone;
  final String guardianJob, guardianIncome;

  const ScholarshipFormStep4({
    super.key,
    required this.scholarshipId,
    required this.scholarshipName,
    required this.amount,
    required this.studentId,
    required this.fullName,
    required this.phone,
    required this.email,
    required this.address,
    required this.fatherName,
    required this.fatherPhone,
    required this.fatherJob,
    required this.fatherIncome,
    required this.motherName,
    required this.motherPhone,
    required this.motherJob,
    required this.motherIncome,
    required this.familyStatus,
    required this.siblingCount,
    required this.applicantOrder,
    required this.applicantIncome,
    required this.totalFamilyIncome,
    required this.familyNote,
    required this.guardianName,
    required this.guardianRelation,
    required this.guardianPhone,
    required this.guardianJob,
    required this.guardianIncome,
  });

  @override
  State<ScholarshipFormStep4> createState() => _ScholarshipFormStep4State();
}

class _ScholarshipFormStep4State extends State<ScholarshipFormStep4> {
  final List<_DocItem> _docs = [
    _DocItem(title: 'สำเนาบัตรประชาชน', fileName: 'id_card_scan.jpg'),
    _DocItem(
      title: 'รูปถ่ายหน้าตรง (พื้นหลังสุภาพ)',
      fileName: 'face_image.jpg',
    ),
    _DocItem(title: 'ใบแสดงผลการเรียน (Transcript)'),
    _DocItem(title: 'สำเนาสมุดบัญชีธนาคาร', fileName: 'bank_copy.pdf'),
  ];

  void _simulateUpload(int index) {
    setState(() => _docs[index].status = _UploadStatus.uploading);
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _docs[index].status = _UploadStatus.done;
          _docs[index].fileName ??= 'document_${index + 1}.pdf';
        });
      }
    });
  }

  void _goNext() {
    // รวม filename ของเอกสารที่ upload แล้ว
    final uploaded = _docs
        .where((d) => d.status == _UploadStatus.done && d.fileName != null)
        .map((d) => d.fileName!)
        .toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ScholarshipFormStep5(
          formData: ScholarshipFormData(
            scholarshipId: widget.scholarshipId,
            scholarshipName: widget.scholarshipName,
            amount: widget.amount,
            studentId: widget.studentId,
            fullName: widget.fullName,
            phone: widget.phone,
            email: widget.email,
            address: widget.address,
            fatherName: widget.fatherName,
            fatherPhone: widget.fatherPhone,
            fatherJob: widget.fatherJob,
            fatherIncome: widget.fatherIncome,
            motherName: widget.motherName,
            motherPhone: widget.motherPhone,
            motherJob: widget.motherJob,
            motherIncome: widget.motherIncome,
            familyStatus: widget.familyStatus,
            siblingCount: widget.siblingCount,
            applicantOrder: widget.applicantOrder,
            applicantIncome: widget.applicantIncome,
            totalFamilyIncome: widget.totalFamilyIncome,
            familyNote: widget.familyNote,
            guardianName: widget.guardianName,
            guardianRelation: widget.guardianRelation,
            guardianPhone: widget.guardianPhone,
            guardianJob: widget.guardianJob,
            guardianIncome: widget.guardianIncome,
            uploadedDocuments: uploaded,
          ),
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
          FormBottomButtons(onNext: _goNext),
          const AppBottomNavBar(activeIndex: 1),
        ],
      ),
    );
  }
}

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
            const LinearProgressIndicator()
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
