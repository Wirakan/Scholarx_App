import 'package:flutter/material.dart';
import '../core/colors.dart';
import '../core/text_styles.dart';
import '../core/models.dart';
import '../widgets/applicant_card.dart';
import 'application_list_screen.dart';
import 'application_detail_screen.dart';
import '../widgets/admin_bottom_nav.dart';
import '/shared/application_repository.dart';
import '/screens/splash_screen.dart';
import 'submitted_application_detail_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

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

  Applicant _toApplicant(ApplicationRecord r) {
    return Applicant(
      id: r.id,
      name: r.fullName,
      studentId: r.studentId,
      scholarship: r.scholarshipName,
      faculty: r.faculty,
      major: r.major,
      year: r.year,
      gpa: r.gpa,
      address: r.address,
      email: r.email,
      date: r.formattedAppliedDate,
      status: r.status.label,
      reason: r.reason,
    );
  }

void _openDetail(BuildContext context, Applicant a, String? applicationId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) {
          if (applicationId != null) {
            return SubmittedApplicationDetailScreen(
              applicationId: applicationId,
            );
          }

          return ApplicationDetailScreen(
            applicant: a,
            applicationId: applicationId,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ApplicationRepository.instance,
      builder: (context, _) {
        final repo = ApplicationRepository.instance;
        final repoRecs = repo.all;
        final repoApps = repoRecs.map(_toApplicant).toList();

        // ยอดรวม = repo + mock เดิม
        final totalCount = repo.totalCount + mockApplicants.length;
        final pendingCount =
            repo.pendingCount +
            mockApplicants.where((a) => a.status == 'รอดำเนินการ').length;
        final approvedCount =
            repo.approvedCount +
            mockApplicants.where((a) => a.status == 'อนุมัติ').length;

        // ใบสมัครล่าสุด: repo records ก่อน แล้วตามด้วย mock
        final recentApplicants = [
          ...repoApps,
          ...mockApplicants,
        ].take(3).toList();

        const openScholarships = 6;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: SXColor.primary,
            automaticallyImplyLeading: false,
            elevation: 0,
            title: const Text(
              'ภาพรวมระบบทุนการศึกษา',
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
          bottomNavigationBar: const AdminBottomNav(currentIndex: 0),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Stat Cards ──────────────────────────────────────
                Row(
                  children: [
                    _StatCard(
                      label: 'ใบสมัครทั้งหมด',
                      value: '$totalCount',
                      icon: Icons.description,
                      iconColor: SXColor.primary,
                    ),
                    const SizedBox(width: 12),
                    _StatCard(
                      label: 'รอดำเนินการ',
                      value: '$pendingCount',
                      icon: Icons.access_time_rounded,
                      iconColor: SXColor.warning,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _StatCard(
                      label: 'อนุมัติ',
                      value: '$approvedCount',
                      icon: Icons.check_circle_rounded,
                      iconColor: SXColor.success,
                    ),
                    const SizedBox(width: 12),
                    _StatCard(
                      label: 'ทุนที่เปิดรับสมัคร',
                      value: '$openScholarships',
                      icon: Icons.workspace_premium_rounded,
                      iconColor: Colors.blue,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // ── ใบสมัครล่าสุด ────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('ใบสมัครล่าสุด', style: SXText.sectionHeader),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ApplicationListScreen(),
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'ดูทั้งหมด',
                            style: TextStyle(
                              fontSize: 13,
                              color: SXColor.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward,
                            size: 16,
                            color: SXColor.primary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...recentApplicants.map((a) {
                  // ค้นหา record จาก repo ด้วย findById
                  final record = ApplicationRepository.instance.findById(a.id);
                  return ApplicantCard(
                    applicant: a,
                    onTap: () => _openDetail(context, a, record?.id),
                  );
                }),
                const SizedBox(height: 24),

                // ── ใกล้ครบกำหนด ──────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('ใกล้ครบกำหนด', style: SXText.sectionHeader),
                    GestureDetector(
                      onTap: () {},
                      child: Row(
                        children: [
                          Text(
                            'ดูทั้งหมด',
                            style: TextStyle(
                              fontSize: 13,
                              color: SXColor.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward,
                            size: 16,
                            color: SXColor.primary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const _DeadlineCard(
                  days: 28,
                  scholarship: 'ทุนด้านเทคโนโลยีดิจิทัล',
                  applicants: 10,
                  date: '20 ม.ค. 2569',
                ),
                const SizedBox(height: 8),
                const _DeadlineCard(
                  days: 45,
                  scholarship: 'ทุนการศึกษาเพื่อความเป็นเลิศทางวิชาการ',
                  applicants: 15,
                  date: '31 มี.ค. 2569',
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─── Stat Card ──────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color iconColor;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
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
                Text(label, style: SXText.caption),
                Icon(icon, color: iconColor, size: 22),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: SXColor.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Deadline Card ────────────────────────────────────────────
class _DeadlineCard extends StatefulWidget {
  final int days;
  final String scholarship;
  final int applicants;
  final String date;

  const _DeadlineCard({
    required this.days,
    required this.scholarship,
    required this.applicants,
    required this.date,
  });

  @override
  State<_DeadlineCard> createState() => _DeadlineCardState();
}

class _DeadlineCardState extends State<_DeadlineCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: SXColor.surface,
          borderRadius: BorderRadius.circular(14),
          border: _hovered
              ? Border.all(color: SXColor.primary, width: 1.5)
              : Border.all(color: Colors.transparent),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Column(
              children: [
                Text(
                  '${widget.days}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: SXColor.primary,
                  ),
                ),
                const Text(
                  'วัน',
                  style: TextStyle(
                    fontSize: 11,
                    color: SXColor.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.scholarship, style: SXText.label),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.person_outline,
                        size: 13,
                        color: SXColor.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'ผู้สมัคร ${widget.applicants} คน',
                        style: SXText.caption,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Text(widget.date, style: SXText.caption),
          ],
        ),
      ),
    );
  }
}
