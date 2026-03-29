import 'package:flutter/material.dart';
import '../core/colors.dart';
import '../core/text_styles.dart';
import '../core/models.dart';
import 'confirm_sheet.dart';
import '/shared/application_repository.dart';
import '/screens/splash_screen.dart';

class SubmittedApplicationDetailScreen extends StatefulWidget {
  final String applicationId;

  const SubmittedApplicationDetailScreen({
    super.key,
    required this.applicationId,
  });

  @override
  State<SubmittedApplicationDetailScreen> createState() =>
      _SubmittedApplicationDetailScreenState();
}

class _SubmittedApplicationDetailScreenState
    extends State<SubmittedApplicationDetailScreen> {
  late String _currentStatus;

  @override
  void initState() {
    super.initState();
    final record = ApplicationRepository.instance.findById(
      widget.applicationId,
    );
    _currentStatus = record?.status.label ?? 'กำลังพิจารณา';
    ApplicationRepository.instance.addListener(_onRepoChanged);
  }

  @override
  void dispose() {
    ApplicationRepository.instance.removeListener(_onRepoChanged);
    super.dispose();
  }

  void _onRepoChanged() {
    if (!mounted) return;
    final record = ApplicationRepository.instance.findById(
      widget.applicationId,
    );
    if (record == null) return;

    final newStatus = record.status.label;
    if (newStatus != _currentStatus) {
      setState(() => _currentStatus = newStatus);
    }
  }

  ApplicationStatus? _fromLabel(String label) {
    switch (label) {
      case 'กำลังพิจารณา':
        return ApplicationStatus.reviewing;
      case 'อนุมัติ':
        return ApplicationStatus.approved;
      case 'ปฏิเสธ':
        return ApplicationStatus.rejected;
      default:
        return null;
    }
  }

  void _applyStatus(String newLabel) {
    setState(() => _currentStatus = newLabel);
    final newStatus = _fromLabel(newLabel);
    if (newStatus != null) {
      ApplicationRepository.instance.updateStatus(
        widget.applicationId,
        newStatus,
      );
    }
  }

  Color get _statusColor {
    switch (_currentStatus) {
      case 'กำลังพิจารณา':
        return const Color(0xFF60A5FA);
      case 'อนุมัติ':
        return SXColor.success;
      case 'ปฏิเสธ':
        return SXColor.error;
      default:
        return SXColor.textSecondary;
    }
  }

  Color get _statusBg {
    switch (_currentStatus) {
      case 'กำลังพิจารณา':
        return const Color(0xFFEFF6FF);
      case 'อนุมัติ':
        return SXColor.successBg;
      case 'ปฏิเสธ':
        return SXColor.errorBg;
      default:
        return SXColor.neutralBg;
    }
  }

  void _showMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(
                Icons.logout_rounded,
                color: Colors.redAccent,
              ),
              title: const Text(
                'ออกจากระบบ',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushAndRemoveUntil(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => const SplashScreen(),
                    transitionsBuilder: (_, anim, __, child) =>
                        FadeTransition(opacity: anim, child: child),
                    transitionDuration: const Duration(milliseconds: 600),
                  ),
                  (route) => false,
                );
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _showStatusPicker(BuildContext context) {
    final options = [ 'กำลังพิจารณา', 'อนุมัติ', 'ปฏิเสธ'];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: SXColor.border,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('เปลี่ยนสถานะ', style: SXText.sectionHeader),
            const SizedBox(height: 12),
            ...options.map(
              (s) => ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  s,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: s == _currentStatus
                        ? SXColor.primary
                        : SXColor.textPrimary,
                  ),
                ),
                trailing: s == _currentStatus
                    ? Icon(Icons.check, color: SXColor.primary, size: 18)
                    : null,
                onTap: () {
                  Navigator.pop(context);
                  _applyStatus(s);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final record = ApplicationRepository.instance.findById(
      widget.applicationId,
    );

    if (record == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: SXColor.primary,
          title: const Text(
            'รายละเอียดใบสมัคร',
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: const Center(
          child: Text(
            'ไม่พบข้อมูลใบสมัคร',
            style: TextStyle(fontSize: 16, color: SXColor.textSecondary),
          ),
        ),
      );
    }

    final applicant = Applicant(
      id: record.id,
      name: record.fullName,
      studentId: record.studentId,
      scholarship: record.scholarshipName,
      faculty: record.faculty,
      major: record.major,
      year: record.year,
      gpa: record.gpa,
      address: record.address,
      email: record.email,
      date: record.formattedAppliedDate,
      status: record.status.label,
      reason: record.reason,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: SXColor.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'รายละเอียดใบสมัคร',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu_rounded, color: Colors.white),
            onPressed: () => _showMenu(context),
          ),
        ],
      ),
      backgroundColor: SXColor.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _SectionCard(
              title: 'ข้อมูลผู้สมัคร',
              trailing: GestureDetector(
                onTap: () => _showStatusPicker(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _statusBg,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _currentStatus,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: _statusColor,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 16,
                        color: _statusColor,
                      ),
                    ],
                  ),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: SXColor.primary,
                        child: Text(
                          record.fullName.isNotEmpty ? record.fullName[0] : '?',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(record.fullName, style: SXText.label),
                            const SizedBox(height: 4),
                            Text(record.studentId, style: SXText.caption),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _InfoCol(label: 'คณะ', value: record.faculty),
                      _InfoCol(label: 'สาขา', value: record.major),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _InfoCol(label: 'ชั้นปี', value: record.year),
                      _InfoCol(
                        label: 'GPA',
                        value: record.gpa.toStringAsFixed(2),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _InfoCol(label: 'เบอร์โทร', value: record.phone),
                      _InfoCol(label: 'อีเมล', value: record.email),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _InfoFull(label: 'ที่อยู่', value: record.address),
                ],
              ),
            ),
            const SizedBox(height: 12),

            _SectionCard(
              title: 'ข้อมูลทุนที่สมัคร',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _InfoFull(label: 'ชื่อทุน', value: record.scholarshipName),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _InfoCol(label: 'รหัสใบสมัคร', value: record.id),
                      _InfoCol(
                        label: 'วันที่สมัคร',
                        value: record.formattedAppliedDate,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _InfoFull(
                    label: 'จำนวนเงินทุน',
                    value: '${record.amount} บาท',
                  ),
                  const SizedBox(height: 10),
                  _InfoFull(label: 'เหตุผลในการสมัคร', value: record.reason),
                ],
              ),
            ),
            const SizedBox(height: 12),

            _SectionCard(
              title: 'ข้อมูลบิดา',
              child: Column(
                children: [
                  Row(
                    children: [
                      _InfoCol(label: 'ชื่อ', value: record.fatherName),
                      _InfoCol(label: 'เบอร์โทร', value: record.fatherPhone),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _InfoCol(label: 'อาชีพ', value: record.fatherJob),
                      _InfoCol(label: 'รายได้', value: record.fatherIncome),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            _SectionCard(
              title: 'ข้อมูลมารดา',
              child: Column(
                children: [
                  Row(
                    children: [
                      _InfoCol(label: 'ชื่อ', value: record.motherName),
                      _InfoCol(label: 'เบอร์โทร', value: record.motherPhone),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _InfoCol(label: 'อาชีพ', value: record.motherJob),
                      _InfoCol(label: 'รายได้', value: record.motherIncome),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            _SectionCard(
              title: 'ข้อมูลครอบครัว',
              child: Column(
                children: [
                  Row(
                    children: [
                      _InfoCol(
                        label: 'สถานภาพครอบครัว',
                        value: record.familyStatus,
                      ),
                      _InfoCol(
                        label: 'จำนวนพี่น้อง',
                        value: record.siblingCount,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _InfoCol(
                        label: 'ลำดับของผู้สมัคร',
                        value: record.applicantOrder,
                      ),
                      _InfoCol(
                        label: 'รายได้ผู้สมัคร',
                        value: record.applicantIncome,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _InfoFull(
                    label: 'รายได้รวมครอบครัว',
                    value: record.totalFamilyIncome,
                  ),
                  if (record.familyNote.trim().isNotEmpty) ...[
                    const SizedBox(height: 10),
                    _InfoFull(
                      label: 'ข้อมูลเพิ่มเติม',
                      value: record.familyNote,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 12),

            _SectionCard(
              title: 'ข้อมูลผู้อุปการะ',
              child: Column(
                children: [
                  Row(
                    children: [
                      _InfoCol(label: 'ชื่อ', value: record.guardianName),
                      _InfoCol(
                        label: 'ความสัมพันธ์',
                        value: record.guardianRelation,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _InfoCol(label: 'เบอร์โทร', value: record.guardianPhone),
                      _InfoCol(label: 'อาชีพ', value: record.guardianJob),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _InfoFull(label: 'รายได้', value: record.guardianIncome),
                ],
              ),
            ),
            const SizedBox(height: 12),

            _SectionCard(
              title: 'เอกสารที่อัปโหลด',
              child: Column(
                children: record.uploadedDocuments.isEmpty
                    ? [
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            'ไม่มีเอกสารแนบ',
                            style: TextStyle(color: SXColor.textSecondary),
                          ),
                        ),
                      ]
                    : record.uploadedDocuments
                          .map((doc) => _DocRow(doc))
                          .toList(),
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
        decoration: BoxDecoration(
          color: SXColor.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => showRejectSheet(
                  context,
                  applicant,
                  onConfirm: () => _applyStatus('ปฏิเสธ'),
                ),
                icon: const Icon(Icons.close, size: 16),
                label: const Text('ปฏิเสธ'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: SXColor.error,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: () => showApproveSheet(
                  context,
                  applicant,
                  onConfirm: () => _applyStatus('อนุมัติ'),
                ),
                icon: const Icon(Icons.check, size: 16),
                label: const Text('อนุมัติใบสมัคร'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: SXColor.success,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? trailing;

  const _SectionCard({required this.title, required this.child, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: SXColor.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(title, style: SXText.sectionHeader)),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _InfoCol extends StatelessWidget {
  final String label;
  final String value;

  const _InfoCol({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(right: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: SXText.caption),
            const SizedBox(height: 4),
            Text(value.isEmpty ? '-' : value, style: SXText.body),
          ],
        ),
      ),
    );
  }
}

class _InfoFull extends StatelessWidget {
  final String label;
  final String value;

  const _InfoFull({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: SXText.caption,
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 4),
            Text(
              value.isEmpty ? '-' : value,
              style: SXText.body.copyWith(height: 1.5),
              textAlign: TextAlign.left,
          ),
        ],
      ),
      ),
    );
  }
}

class _DocRow extends StatelessWidget {
  final String fileName;

  const _DocRow(this.fileName);

  IconData get _icon {
    final lower = fileName.toLowerCase();
    if (lower.endsWith('.pdf')) return Icons.picture_as_pdf_rounded;
    if (lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.png')) {
      return Icons.image_rounded;
    }
    return Icons.insert_drive_file_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: SXColor.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: SXColor.border),
      ),
      child: Row(
        children: [
          Icon(_icon, color: SXColor.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              fileName,
              style: SXText.body,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
