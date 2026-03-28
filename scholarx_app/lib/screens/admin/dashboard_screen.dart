import 'package:flutter/material.dart';
import '../coreApp/colors.dart';
import '../coreApp/text_styles.dart';
import '../coreApp/models.dart';
import '../widgets/admin/admin_app_bar.dart';
import '../widgets/admin/applicant_card.dart';
import 'application_list_screen.dart';
import 'application_detail_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SXAppBar(title: 'ภาพรวมระบบทุนการศึกษา'),
      backgroundColor: SXColor.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stat cards
            Row(
              children: [
                _StatCard(icon: Icons.description_outlined, label: 'ใบสมัครทั้งหมด', value: '248', iconColor: SXColor.error, iconBg: SXColor.errorBg),
                const SizedBox(width: 10),
                _StatCard(icon: Icons.access_time, label: 'รอดำเนินการ', value: '45', iconColor: SXColor.warning, iconBg: SXColor.warningBg),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _StatCard(icon: Icons.check_circle_outline, label: 'อนุมัติ', value: '15', iconColor: SXColor.success, iconBg: SXColor.successBg),
                const SizedBox(width: 10),
                _StatCard(icon: Icons.people_outline, label: 'ทุนที่เปิดรับสมัคร', value: '6', iconColor: SXColor.primary, iconBg: SXColor.primaryBg),
              ],
            ),
            const SizedBox(height: 20),

            // Recent Applications header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('ใบสมัครล่าสุด', style: SXText.sectionHeader),
                GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ApplicationListScreen())),
                  child: Row(
                    children: [
                      Text('ดูทั้งหมด', style: TextStyle(fontSize: 13, color: SXColor.primary, fontWeight: FontWeight.w700)),
                      Icon(Icons.arrow_forward, size: 16, color: SXColor.primary),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...mockApplicants.take(3).map((a) => ApplicantCard(
              applicant: a,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ApplicationDetailScreen(applicant: a))),
            )),

            const SizedBox(height: 20),
            // Deadline section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('ใกล้ครบกำหนด', style: SXText.sectionHeader),
                Text('ดูทั้งหมด', style: TextStyle(fontSize: 13, color: SXColor.primary, fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 12),
            _DeadlineCard(days: 28, scholarship: 'ทุนด้านเทคโนโลยีดิจิทัล', quota: 'รับ 10 ทน'),
            const SizedBox(height: 😎,
            _DeadlineCard(days: 28, scholarship: 'ทุนด้านเทคโนโลยีดิจิทัล', quota: 'รับ 10 ทน'),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;
  final Color iconBg;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.iconColor,
    required this.iconBg,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: SXColor.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: SXColor.border),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(😎,
              decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: SXColor.textPrimary)),
                Text(label, style: SXText.caption),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DeadlineCard extends StatelessWidget {
  final int days;
  final String scholarship;
  final String quota;

  const _DeadlineCard({required this.days, required this.scholarship, required this.quota});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: SXColor.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: SXColor.border),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: SXColor.errorBg, borderRadius: BorderRadius.circular(10)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('$days', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: SXColor.error)),
                const Text('วัน', style: TextStyle(fontSize: 10, color: SXColor.error)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(scholarship, style: SXText.label),
              Text(quota, style: SXText.caption),
            ],
          ),
        ],
      ),
    );
  }
}