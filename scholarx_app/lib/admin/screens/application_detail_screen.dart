import 'package:flutter/material.dart';
import '../core/colors.dart';
import '../core/text_styles.dart';
import '../core/models.dart';
import 'confirm_sheet.dart';
import '/shared/application_repository.dart';
import '/screens/splash_screen.dart';

class ApplicationDetailScreen extends StatefulWidget {
  final Applicant applicant;
  final String? applicationId;

  const ApplicationDetailScreen({
    super.key,
    required this.applicant,
    this.applicationId,
  });

  @override
  State<ApplicationDetailScreen> createState() =>
      _ApplicationDetailScreenState();
}

class _ApplicationDetailScreenState extends State<ApplicationDetailScreen> {
  late String _currentStatus;

  @override
  void initState() {
    super.initState();
    if (widget.applicationId != null) {
      final record =
          ApplicationRepository.instance.findById(widget.applicationId!);
      _currentStatus = record?.status.label ?? widget.applicant.status;
    } else {
      _currentStatus = widget.applicant.status;
    }
    // ฟัง repo เพื่อ sync status เมื่อมีการเปลี่ยนแปลงจากภายนอก
    ApplicationRepository.instance.addListener(_onRepoChanged);
  }

  @override
  void dispose() {
    ApplicationRepository.instance.removeListener(_onRepoChanged);
    super.dispose();
  }

  void _onRepoChanged() {
    if (!mounted || widget.applicationId == null) return;
    final record =
        ApplicationRepository.instance.findById(widget.applicationId!);
    if (record == null) return;
    final newLabel = record.status.label;
    if (newLabel != _currentStatus) {
      setState(() => _currentStatus = newLabel);
    }
  }

  Color get _statusColor {
    switch (_currentStatus) {
      case 'รอดำเนินการ':
        return SXColor.warning;
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
      case 'รอดำเนินการ':
        return SXColor.warningBg;
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

  void _applyStatus(String newLabel) {
    setState(() => _currentStatus = newLabel);
    if (widget.applicationId != null) {
      final newStatus = _fromLabel(newLabel);
      if (newStatus != null) {
        ApplicationRepository.instance.updateStatus(
          widget.applicationId!,
          newStatus,
        );
      }
    }
  }

  ApplicationStatus? _fromLabel(String label) {
    switch (label) {
      case 'รอดำเนินการ':
        return ApplicationStatus.pending;
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
    final allOptions = ['รอดำเนินการ', 'กำลังพิจารณา', 'อนุมัติ', 'ปฏิเสธ'];
    // snapshot ค่า _currentStatus ก่อน เพื่อใช้ใน StatefulBuilder
    final currentSnapshot = _currentStatus;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setSheetState) => Container(
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
              ...allOptions.map(
                (s) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    s,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: s == currentSnapshot
                          ? SXColor.primary
                          : SXColor.textPrimary,
                    ),
                  ),
                  trailing: s == currentSnapshot
                      ? Icon(Icons.check, color: SXColor.primary, size: 18)
                      : null,
                  onTap: () {
                    Navigator.pop(ctx);
                    _applyStatus(s);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // อ่าน record ตรงจาก repo — ไม่ใช้ ListenableBuilder เพื่อหลีกเลี่ยง
    // mouse_tracker assertion error ที่เกิดเมื่อ widget tree rebuild ระหว่าง gesture
    final record = widget.applicationId != null
        ? ApplicationRepository.instance.findById(widget.applicationId!)
        : null;

    final a = widget.applicant;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: SXColor.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'การจัดการใบสมัคร',
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── ข้อมูลผู้สมัคร ──────────────────────────────
            Container(
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'ข้อมูลผู้สมัคร',
                        style: SXText.sectionHeader,
                      ),
                      GestureDetector(
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
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 36,
                        backgroundColor: SXColor.primaryBg,
                        child: Text(
                          a.name.isNotEmpty ? a.name[0] : '?',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: SXColor.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              a.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: SXColor.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(a.studentId, style: SXText.caption),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.email_outlined,
                                  size: 13,
                                  color: SXColor.textSecondary,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    a.email,
                                    style: SXText.caption,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: SXColor.border, height: 1),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _InfoCol(label: 'คณะ', value: a.faculty),
                      _InfoCol(label: 'สาขา', value: a.major),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _InfoCol(label: 'ชั้นปี', value: a.year),
                      _InfoCol(
                        label: 'เกรดเฉลี่ย',
                        value: a.gpa.toStringAsFixed(2),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text('ที่อยู่', style: SXText.caption),
                  const SizedBox(height: 4),
                  Text(a.address, style: SXText.body),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // ─── รายละเอียดครอบครัว ──
            if (record != null) ...[
              _SectionCard(
                title: 'ข้อมูลครอบครัว',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _InfoCol(label: 'ชื่อบิดา', value: record.fatherName),
                        _InfoCol(label: 'อาชีพบิดา', value: record.fatherJob),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _InfoCol(
                          label: 'รายได้บิดา',
                          value: record.fatherIncome,
                        ),
                        _InfoCol(
                          label: 'เบอร์บิดา',
                          value: record.fatherPhone,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _InfoCol(label: 'ชื่อมารดา', value: record.motherName),
                        _InfoCol(
                          label: 'อาชีพมารดา',
                          value: record.motherJob,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _InfoCol(
                          label: 'รายได้มารดา',
                          value: record.motherIncome,
                        ),
                        _InfoCol(
                          label: 'เบอร์มารดา',
                          value: record.motherPhone,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _InfoCol(
                      label: 'สภาพครอบครัว',
                      value: record.familyStatus,
                    ),
                    const SizedBox(height: 4),
                    _InfoCol(
                      label: 'รายได้รวม/ปี',
                      value: record.totalFamilyIncome,
                    ),
                    if (record.familyNote.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text('ข้อมูลเพิ่มเติม', style: SXText.caption),
                      const SizedBox(height: 4),
                      Text(record.familyNote, style: SXText.body),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _SectionCard(
                title: 'ข้อมูลผู้อุปการะ',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _InfoCol(label: 'อาชีพ', value: record.guardianJob),
                        _InfoCol(label: 'รายได้', value: record.guardianIncome),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _InfoCol(label: 'เบอร์โทร', value: record.guardianPhone),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],

            // ─── รายละเอียดการสมัคร ──────────────────────────
            _SectionCard(
              title: 'รายละเอียดการสมัคร',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('ทุนที่สมัคร', style: SXText.caption),
                  const SizedBox(height: 4),
                  Text(
                    a.scholarship,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: SXColor.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _InfoCol(label: 'วันที่สมัคร', value: a.date),
                      _InfoCol(label: 'รหัสใบสมัคร', value: a.id),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text('เหตุผลในการสมัคร:', style: SXText.caption),
                  const SizedBox(height: 4),
                  Text(a.reason, style: SXText.body.copyWith(height: 1.6)),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // ─── เอกสาร ──────────────────────────────────────
            _SectionCard(
              title: 'เอกสารที่อัปโหลดแล้ว',
              child: Column(
                children: (record?.uploadedDocuments.isNotEmpty == true
                        ? record!.uploadedDocuments
                        : const [
                            'สำเนาบัตรประชาชน.pdf',
                            'รูปถ่ายหน้าตรง.JPEG',
                            'ใบแสดงผลการเรียน.pdf',
                            'สำเนาสมุดบัญชีธนาคาร.JPEG',
                          ])
                    .map((f) => _DocRow(f))
                    .toList(),
              ),
            ),
            const SizedBox(height: 80),
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
                  a,
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
                  a,
                  onConfirm: () => _applyStatus('อนุมัติ'),
                ),
                icon: const Icon(Icons.check, size: 16),
                label: const Text('อนุมัติ'),
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

// ─── Local Widgets ─────────────────────────────────────────
class _InfoCol extends StatelessWidget {
  final String label;
  final String value;
  const _InfoCol({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: SXText.caption),
          const SizedBox(height: 2),
          Text(value.isNotEmpty ? value : '-', style: SXText.label),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  const _SectionCard({required this.title, required this.child});

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
          Text(title, style: SXText.sectionHeader),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _DocRow extends StatelessWidget {
  final String name;
  const _DocRow(this.name);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: SXColor.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: SXColor.border),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.insert_drive_file_outlined,
            size: 16,
            color: SXColor.textSecondary,
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(name, style: SXText.body)),
          const Icon(
            Icons.download_outlined,
            size: 18,
            color: SXColor.primary,
          ),
        ],
      ),
    );
  }
}