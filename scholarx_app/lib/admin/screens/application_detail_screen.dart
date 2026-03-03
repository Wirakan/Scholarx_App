import 'package:flutter/material.dart';
import '../core/colors.dart';
import '../core/text_styles.dart';
import '../core/models.dart';
import '../widgets/sx_app_bar.dart';
import 'confirm_sheet.dart';

class ApplicationDetailScreen extends StatefulWidget {
  final Applicant applicant;
  const ApplicationDetailScreen({super.key, required this.applicant});

  @override
  State<ApplicationDetailScreen> createState() => _ApplicationDetailScreenState();
}

class _ApplicationDetailScreenState extends State<ApplicationDetailScreen> {
  late String _currentStatus;

  final List<String> _statusOptions = ['รอพิจารณา', 'กำลังพิจารณา'];

  @override
  void initState() {
    super.initState();
    _currentStatus = 'รอพิจารณา';
  }

  Color get _statusColor {
    switch (_currentStatus) {
      case 'รอพิจารณา': return SXColor.warning;
      case 'กำลังพิจารณา': return const Color(0xFF60A5FA);
      default: return SXColor.textSecondary;
    }
  }

  Color get _statusBg {
    switch (_currentStatus) {
      case 'รอพิจารณา': return SXColor.warningBg;
      case 'กำลังพิจารณา': return const Color(0xFFEFF6FF);
      default: return SXColor.neutralBg;
    }
  }

  @override
  Widget build(BuildContext context) {
    final a = widget.applicant;
    return Scaffold(
      appBar: const SXAppBar(title: 'การจัดการใบสมัคร', showBack: true),
      backgroundColor: SXColor.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── ข้อมูลผู้สมัคร ───────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: SXColor.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header row: title + status dropdown
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('ข้อมูลผู้สมัคร', style: SXText.sectionHeader),
                      // Status dropdown
                      GestureDetector(
                        onTap: () => _showStatusPicker(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: _statusBg,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Row(
                            children: [
                              Text(_currentStatus, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: _statusColor)),
                              const SizedBox(width: 4),
                              Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: _statusColor),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Avatar + name
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 36,
                        backgroundColor: SXColor.primaryBg,
                        child: Text(
                          a.name[0],
                          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: SXColor.primary),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(a.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: SXColor.textPrimary)),
                          const SizedBox(height: 2),
                          Text(a.studentId, style: SXText.caption),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.email_outlined, size: 13, color: SXColor.textSecondary),
                              const SizedBox(width: 4),
                              Text(a.email, style: SXText.caption),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: SXColor.border, height: 1),
                  const SizedBox(height: 16),

                  // Info grid
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
                      _InfoCol(label: 'เกรดเฉลี่ย', value: a.gpa.toString()),
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

            // ─── รายละเอียดการสมัคร ───────────────────────────────────────
            _SectionCard(
              title: 'รายละเอียดการสมัคร',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('ทุนที่สมัคร', style: SXText.caption),
                  const SizedBox(height: 4),
                  Text(a.scholarship, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: SXColor.primary)),
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

            // ─── เอกสาร ───────────────────────────────────────────────────
            _SectionCard(
              title: 'เอกสารที่อัปโหลดแล้ว',
              child: Column(
                children: const [
                  _DocRow('สำเนาบัตรประชาชน.pdf'),
                  _DocRow('รูปถ่ายหน้าตรง.JPEG'),
                  _DocRow('ใบแสดงผลการเรียน.pdf'),
                  _DocRow('สำเนาสมุดบัญชีธนาคาร.JPEG'),
                ],
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
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 16, offset: const Offset(0, -4))],
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => showRejectSheet(context, a),
                icon: const Icon(Icons.close, size: 16),
                label: const Text('ปฏิเสธ'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: SXColor.error,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: () => showApproveSheet(context, a),
                icon: const Icon(Icons.check, size: 16),
                label: const Text('อนุมัติ'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: SXColor.success,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showStatusPicker(BuildContext context) {
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
                width: 40, height: 4,
                decoration: BoxDecoration(color: SXColor.border, borderRadius: BorderRadius.circular(999)),
              ),
            ),
            const SizedBox(height: 16),
            const Text('เปลี่ยนสถานะ', style: SXText.sectionHeader),
            const SizedBox(height: 12),
            ..._statusOptions.map((s) => ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(s, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: s == _currentStatus ? SXColor.primary : SXColor.textPrimary)),
              trailing: s == _currentStatus ? Icon(Icons.check, color: SXColor.primary, size: 18) : null,
              onTap: () {
                setState(() => _currentStatus = s);
                Navigator.pop(context);
              },
            )),
          ],
        ),
      ),
    );
  }
}

// ─── Local Widgets ─────────────────────────────────────────────────────────────
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
          Text(value, style: SXText.label),
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
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
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
          const Icon(Icons.insert_drive_file_outlined, size: 16, color: SXColor.textSecondary),
          const SizedBox(width: 8),
          Expanded(child: Text(name, style: SXText.body)),
          const Icon(Icons.download_outlined, size: 18, color: SXColor.primary),
        ],
      ),
    );
  }
}