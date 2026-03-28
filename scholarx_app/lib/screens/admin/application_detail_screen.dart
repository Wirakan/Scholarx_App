import 'package:flutter/material.dart';
import '../coreApp/colors.dart';
import '../coreApp/text_styles.dart';
import '../coreApp/models.dart';
import '../widgets/admin/admin_app_bar.dart';
import 'confirm_sheet.dart';

class ApplicationDetailScreen extends StatelessWidget {
  final Applicant applicant;

  const ApplicationDetailScreen({super.key, required this.applicant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SXAppBar(title: 'การจัดการใบสมัคร', showBack: true),
      backgroundColor: SXColor.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Applicant Info Card
            _SectionCard(
              title: 'ข้อมูลผู้สมัคร',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: SXColor.primary,
                        child: Text(
                          applicant.name[0],
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 22),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(applicant.name, style: SXText.sectionHeader),
                          Text(applicant.studentId, style: SXText.caption),
                          Row(
                            children: [
                              const Icon(Icons.email_outlined, size: 12, color: SXColor.textSecondary),
                              const SizedBox(width: 4),
                              Text(applicant.email, style: SXText.caption),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _InfoGrid(items: [
                    _InfoItem('คณะ', applicant.faculty),
                    _InfoItem('สาขา', applicant.major),
                    _InfoItem('ชั้นปี', applicant.year),
                    _InfoItem('เกรดเฉลี่ย', applicant.gpa.toString()),
                  ]),
                  const SizedBox(height: 12),
                  Row(
                    children: const [
                      Icon(Icons.location_on_outlined, size: 14, color: SXColor.textSecondary),
                      SizedBox(width: 4),
                      Text('ที่อยู่', style: SXText.caption),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(applicant.address, style: SXText.body),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Scholarship Detail Card
            _SectionCard(
              title: 'รายละเอียดการสมัคร',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('ทุนที่สมัคร', style: SXText.caption),
                  const SizedBox(height: 4),
                  Text(
                    applicant.scholarship,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: SXColor.primary),
                  ),
                  const SizedBox(height: 12),
                  _InfoGrid(items: [
                    _InfoItem('วันที่สมัคร', applicant.date),
                    _InfoItem('รหัสใบสมัคร', applicant.id),
                  ]),
                  const SizedBox(height: 12),
                  const Text('เหตุผลในการสมัคร:', style: SXText.caption),
                  const SizedBox(height: 4),
                  Text(applicant.reason, style: SXText.body.copyWith(height: 1.6)),
                  const SizedBox(height: 4),
                  const Text(
                    'อ่านเพิ่มเติม',
                    style: TextStyle(fontSize: 13, color: SXColor.primary, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Documents Card
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
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 16, offset: const Offset(0, -4)),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => showRejectSheet(context, applicant),
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
                onPressed: () => showApproveSheet(context, applicant),
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
}

// ─── Local Widgets ────────────────────────────────────────────────────────────
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
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: SXColor.border),
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

class _InfoItem {
  final String label;
  final String value;
  const _InfoItem(this.label, this.value);
}

class _InfoGrid extends StatelessWidget {
  final List<_InfoItem> items;

  const _InfoGrid({required this.items});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 10,
      children: items
          .map((item) => SizedBox(
                width: (MediaQuery.of(context).size.width - 80) / 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.label, style: SXText.caption),
                    const SizedBox(height: 2),
                    Text(item.value, style: SXText.label),
                  ],
                ),
              ))
          .toList(),
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
applicant.id