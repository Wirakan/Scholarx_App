// การเปลี่ยนแปลงจากของเดิม:
//   - import provider
//   - _ProfileHeader รับ unreadCount และแสดง badge บน bell icon
//   - bell icon onPressed → switch ไป tab notification (index 3)

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/coreApp/themeApp/app_colors.dart';
import '/coreApp/themeApp/app_text_style.dart';
import '/coreApp/constants/app_strings.dart';
import '../../components/student_card.dart';
import '/student/models/student_model.dart';
import '/student/models/notification_model.dart';
import '/student/models/scholarship_detail_model.dart';
import '/student/providers/notification_provider.dart';
import '/student/screens/profile/student_profile_screen.dart';
import '/student/screens/scholar/scholar_screen.dart';
import '/student/models/scholarship_model.dart';
import '/student/screens/tracking/tracking_screen.dart';
import '/student/screens/noti/notification_screen.dart';
import '/student/screens/noti/notification_detail_screen.dart';
import '/student/screens/scholar/scholarship_detail.dart';
import '/student/providers/tracking_provider.dart';

class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({super.key});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  int _selectedIndex = 0;
  NotificationModel? _selectedNotification;
  int _testStatusIndex = 0; 

  final StudentModel _student = mockStudent;

  List<ScholarshipModel> get _scholarships => ScholarshipModel.mockList;

  Future<void> _openScholarDetail(ScholarshipModel scholarship) async {
    setState(() => _selectedIndex = 1);
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ScholarshipDetailScreen(scholarship: scholarship),
      ),
    );
  }

  void _switchToTracking() {
    setState(() => _selectedIndex = 2);
  }

  void _goToNotifications() {
    setState(() {
      _selectedIndex = 3;
      _selectedNotification = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    // อ่าน unreadCount สำหรับ badge — ไม่ต้องครอบทั้งหน้า ใช้ Consumer เฉพาะจุด
    return Scaffold(
      backgroundColor: AppColors.background,

      // test admin notice work or not แก้ปุ่ม
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final trackingProvider = context.read<TrackingProvider>();
          final pending = trackingProvider.pendingItems;

          // ไม่มีรายการที่รอพิจารณาแล้ว
          if (pending.isEmpty) return;

          const cycle = [
            ApplicationStatus.approved,
            ApplicationStatus.rejected,
          ];

          final status = cycle[_testStatusIndex % cycle.length];
          final name   = pending[_testStatusIndex % pending.length].title;
          _testStatusIndex++;

          context.read<NotificationProvider>().addStatusNotification(
            scholarshipName: name,
            status: status,
          );
        },
        child: const Icon(Icons.add),
      ),

      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _HomeTab(
            student: _student,
            scholarships: _scholarships,
            onGoToScholar: () => setState(() => _selectedIndex = 1),
            onGoToNotifications: _goToNotifications,
            onGoToTracking: _switchToTracking,
            onOpenScholarDetail: _openScholarDetail,
          ),
          const ScholarScreen(),
          TrackingScreen(
            showBottomNav: false,
            onNavTap: (i) => setState(() => _selectedIndex = i),
          ),
          _selectedNotification != null
              ? NotificationDetailScreen(
                  notification: _selectedNotification!,
                  onBack: () => setState(() => _selectedNotification = null),
                )
              : NotificationScreen(
                  onOpenDetail: (model) =>
                      setState(() => _selectedNotification = model),
                ),
          StudentProfileScreen(student: _student),
        ],
      ),
      bottomNavigationBar: Consumer<NotificationProvider>(
        builder: (context, provider, _) => _BottomNav(
          selectedIndex: _selectedIndex,
          unreadCount: provider.unreadCount,
          onTap: (i) => setState(() {
            _selectedIndex = i;
            if (i == 3) _selectedNotification = null;
          }),
        ),
      ),
    );
  }
}

// ─── Home Tab ─────────────────────────────────────────────────────────────────

class _HomeTab extends StatelessWidget {
  final StudentModel student;
  final List<ScholarshipModel> scholarships;
  final VoidCallback onGoToScholar;
  final VoidCallback onGoToNotifications;
  final VoidCallback onGoToTracking;
  final void Function(ScholarshipModel) onOpenScholarDetail;

  const _HomeTab({
    required this.student,
    required this.scholarships,
    required this.onGoToScholar,
    required this.onGoToNotifications,
    required this.onGoToTracking,
    required this.onOpenScholarDetail,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: _ProfileHeader(
            student: student,
            onBellTap: onGoToNotifications,
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
          sliver: SliverToBoxAdapter(
            child: Column(
              children: [
                _GuideBanner(onTap: onGoToScholar),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _ActionCard(
                        title: AppStrings.applyScholarship,
                        subtitle: AppStrings.openScholarships,
                        icon: Icons.emoji_events_rounded,
                        color: AppColors.primary,
                        onTap: onGoToScholar,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ActionCard(
                        title: AppStrings.trackScholarship,
                        subtitle: AppStrings.trackScholarshipSub,
                        icon: Icons.receipt_long_rounded,
                        color: const Color(0xFF5C4EE5),
                        onTap: onGoToTracking,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppStrings.announcementAndNews,
                        style: AppTextStyle.h2),
                    GestureDetector(
                      onTap: onGoToScholar,
                      child: Text(
                        'ดูทั้งหมด',
                        style: AppTextStyle.label
                            .copyWith(color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((ctx, i) {
              final s = scholarships[i];
              final cardItem = ScholarshipCardItem(
                id: s.id,
                title: s.title,
                category: s.categoryLabel,
                categoryColor: '#E8591A',
                description: s.description,
                updatedAt: s.deadline,
              );
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: StudentCard(
                  item: cardItem,
                  onTap: () => onOpenScholarDetail(s),
                ),
              );
            }, childCount: scholarships.length),
          ),
        ),
      ],
    );
  }
}

// ─── Profile Header ───────────────────────────────────────────────────────────

class _ProfileHeader extends StatelessWidget {
  final StudentModel student;
  final VoidCallback onBellTap;

  const _ProfileHeader({
    required this.student,
    required this.onBellTap,
  });

  @override
  Widget build(BuildContext context) {
    // Consumer เฉพาะส่วน bell เพื่อไม่ให้ rebuild ทั้ง header โดยไม่จำเป็น
    return Container(
      color: AppColors.primary,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12,
        left: 20,
        right: 20,
        bottom: 20,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white.withOpacity(0.25),
            child:
                const Icon(Icons.person, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.fullName,
                  style:
                      AppTextStyle.h3.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 2),
                Text(
                  student.studentId,
                  style: AppTextStyle.body.copyWith(
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          // Bell icon + badge
          Consumer<NotificationProvider>(
            builder: (context, provider, _) {
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.notifications_none_rounded,
                      color: Colors.white,
                      size: 26,
                    ),
                    onPressed: onBellTap,
                  ),
                  if (provider.hasUnread)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        decoration: const BoxDecoration(
                          color: Colors.yellow,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${provider.unreadCount}',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

// ─── Guide Banner ─────────────────────────────────────────────────────────────

class _GuideBanner extends StatelessWidget {
  final VoidCallback? onTap;
  const _GuideBanner({this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF8C55), Color(0xFFE8591A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('แนะนำ',
                      style:
                          AppTextStyle.badge.copyWith(color: Colors.white)),
                ),
                const SizedBox(height: 8),
                Text(AppStrings.applyGuide,
                    style:
                        AppTextStyle.titleCard.copyWith(color: Colors.white)),
                const SizedBox(height: 4),
                Text(
                  AppStrings.applyGuideDesc,
                  style: AppTextStyle.caption.copyWith(
                    color: Colors.white.withOpacity(0.85),
                  ),
                ),
                const SizedBox(height: 14),
                GestureDetector(
                  onTap: onTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(AppStrings.startNow,
                        style: AppTextStyle.label
                            .copyWith(color: AppColors.primary)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const Icon(Icons.menu_book_rounded,
              color: Colors.white, size: 64),
        ],
      ),
    );
  }
}

// ─── Action Card ──────────────────────────────────────────────────────────────

class _ActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(height: 10),
            Text(title,
                style:
                    AppTextStyle.titleCard.copyWith(color: Colors.white)),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: AppTextStyle.caption.copyWith(
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Bottom Nav ───────────────────────────────────────────────────────────────

class _BottomNav extends StatelessWidget {
  final int selectedIndex;
  final int unreadCount;
  final void Function(int) onTap;

  const _BottomNav({
    required this.selectedIndex,
    required this.unreadCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const items = [
      (Icons.home_rounded, Icons.home_outlined, AppStrings.home),
      (Icons.school_rounded, Icons.school_outlined, AppStrings.scholar),
      (
        Icons.fact_check_rounded,
        Icons.fact_check_outlined,
        AppStrings.document,
      ),
      (
        Icons.notifications_rounded,
        Icons.notifications_outlined,
        AppStrings.notification,
      ),
      (Icons.person_rounded, Icons.person_outlined, AppStrings.profile),
    ];

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border:
            Border(top: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: SafeArea(
        child: Row(
          children: List.generate(items.length, (i) {
            final isSelected = i == selectedIndex;
            final isNotifTab = i == 3;

            return Expanded(
              child: GestureDetector(
                onTap: () => onTap(i),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ── pill highlight เมื่อ selected ──
                      Stack(
  clipBehavior: Clip.none,
  children: [
    isSelected
        ? Container(
            width: 48,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(items[i].$1, color: Colors.white, size: 22),
          )
        : Icon(items[i].$2, color: const Color(0xFF9E9E9E), size: 24),
    // badge แดงบน notification tab
    if (isNotifTab && unreadCount > 0 && !isSelected)
      Positioned(
        right: -4,
        top: -4,
        child: Container(
          padding: const EdgeInsets.all(2),
          constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
          decoration: const BoxDecoration(
            color: Color(0xFFE53935),
            shape: BoxShape.circle,
          ),
          child: Text(
            unreadCount > 9 ? '9+' : '$unreadCount',
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
  ],
),
                      const SizedBox(height: 4),
                      Text(
                        items[i].$3,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w400,
                          color: isSelected
                              ? AppColors.primary
                              : const Color(0xFF9E9E9E),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

// ─── Placeholder Tab ──────────────────────────────────────────────────────────

class _PlaceholderTab extends StatelessWidget {
  final String label;
  const _PlaceholderTab({required this.label});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(label,
            style: AppTextStyle.h3.copyWith(color: Colors.white)),
        elevation: 0,
      ),
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.construction_rounded,
                color: AppColors.textTertiary, size: 48),
            const SizedBox(height: 12),
            Text('Coming Soon',
                style:
                    AppTextStyle.h3.copyWith(color: AppColors.textTertiary)),
          ],
        ),
      ),
    );
  }
}
