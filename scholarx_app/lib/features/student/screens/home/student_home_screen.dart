import 'package:flutter/material.dart';
import '/coreApp/themeApp/app_colors.dart';
import '/coreApp/themeApp/app_text_style.dart';
import '/coreApp/constants/app_strings.dart';
import '/features/components/student_card.dart';
import '/features/student/models/student_model.dart';
import '/features/student/screens/profile/student_profile_screen.dart';
import '/features/student/screens/scholar/scholar_screen.dart';
import '/features/student/screens/notification/notification_screen.dart';

// features/student/screens/home/student_home_screen.dart
// แก้ไขจากเดิม: เพิ่ม import ScholarScreen + เปลี่ยน _PlaceholderTab ของ Scholar + onTap ของ action card

class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({super.key});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  int _selectedIndex = 0;
  final StudentModel _student = StudentModel.mock;

  static const List<ScholarshipCardItem> _scholarships = [
    ScholarshipCardItem(
      title: 'ทุนการศึกษาเพื่อความเป็นเลิศทางวิชาการ',
      category: 'สำหรับนักศึกษาระดับปริญญาตรี',
      categoryColor: '#E8591A',
      description:
          'สนับสนุนค่าเล่าเรียนและค่าครองชีพ สำหรับนักศึกษาที่มีผลการเรียนดี และมีความประพฤติดี',
      updatedAt: '1 ม.ค. 2569',
    ),
    ScholarshipCardItem(
      title: 'ประกาศผลผู้ได้รับทุน รอบที่ 1',
      category: 'ประจำปีการศึกษา 2569',
      categoryColor: '#E8591A',
      description:
          'ผู้สมัครสามารถตรวจสอบรายชื่อผู้ได้รับทุนและขั้นตอนต่อไปได้ในแอป',
      updatedAt: '1 ม.ค. 2569',
    ),
    ScholarshipCardItem(
      title: 'ทุนด้านเทคโนโลยีดิจิทัล',
      category: 'ทุนเฉพาะทาง Digital / IT / Engineering',
      categoryColor: '#E8591A',
      description:
          'มอบทุนให้แก่นักศึกษาที่มีความสนใจด้านเทคโนโลยี นวัตกรรม และการพัฒนาดิจิทัล',
      updatedAt: '1 ม.ค. 2569',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _HomeTab(
            student: _student,
            scholarships: _scholarships,
            onGoToScholar: () =>
                setState(() => _selectedIndex = 1), // ← ส่ง callback
          ),
          const ScholarScreen(), // ← เปลี่ยนจาก _PlaceholderTab เป็น ScholarScreen
          const _PlaceholderTab(label: 'Document'),
          const NotificationScreen(),
          StudentProfileScreen(student: _student),
        ],
      ),
      bottomNavigationBar: _BottomNav(
        selectedIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
      ),
    );
  }
}

// ─── Home Tab ─────────────────────────────────────────────────────────────────
class _HomeTab extends StatelessWidget {
  final StudentModel student;
  final List<ScholarshipCardItem> scholarships;
  final VoidCallback onGoToScholar; // ← เพิ่ม parameter

  const _HomeTab({
    required this.student,
    required this.scholarships,
    required this.onGoToScholar, // ← เพิ่ม
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _ProfileHeader(student: student)),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
          sliver: SliverToBoxAdapter(
            child: Column(
              children: [
                _GuideBanner(onTap: onGoToScholar), // ← ส่ง onTap
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _ActionCard(
                        title: AppStrings.applyScholarship,
                        subtitle: AppStrings.openScholarships,
                        icon: Icons.emoji_events_rounded,
                        color: AppColors.primary,
                        onTap: onGoToScholar, // ← navigate ไป Scholar tab
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ActionCard(
                        title: AppStrings.trackScholarship,
                        subtitle: AppStrings.trackScholarshipSub,
                        icon: Icons.receipt_long_rounded,
                        color: const Color(0xFF5C4EE5),
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppStrings.announcementAndNews,
                      style: AppTextStyle.h2,
                    ),
                    GestureDetector(
                      onTap: onGoToScholar,
                      child: Text(
                        'ดูทั้งหมด',
                        style: AppTextStyle.label.copyWith(
                          color: AppColors.primary,
                        ),
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
            delegate: SliverChildBuilderDelegate(
              (ctx, i) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: StudentCard(
                  item: scholarships[i],
                  onTap: onGoToScholar, // ← กด "ดูรายละเอียด" → ไปหน้า Scholar
                ),
              ),
              childCount: scholarships.length,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Profile Header ───────────────────────────────────────────────────────────
class _ProfileHeader extends StatelessWidget {
  final StudentModel student;
  const _ProfileHeader({required this.student});

  @override
  Widget build(BuildContext context) {
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
            child: const Icon(Icons.person, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.fullName,
                  style: AppTextStyle.h3.copyWith(color: Colors.white),
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
          Stack(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.notifications_none_rounded,
                  color: Colors.white,
                  size: 26,
                ),
                onPressed: () {},
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.yellow,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Guide Banner ─────────────────────────────────────────────────────────────
class _GuideBanner extends StatelessWidget {
  final VoidCallback? onTap; // ← เพิ่ม onTap
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
        borderRadius: BorderRadius.circular(20),
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
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    'แนะนำ',
                    style: AppTextStyle.badge.copyWith(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  AppStrings.applyGuide,
                  style: AppTextStyle.titleCard.copyWith(color: Colors.white),
                ),
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
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      AppStrings.startNow,
                      style: AppTextStyle.label.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const Icon(Icons.menu_book_rounded, color: Colors.white, size: 64),
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
          borderRadius: BorderRadius.circular(16),
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
            Text(
              title,
              style: AppTextStyle.titleCard.copyWith(color: Colors.white),
            ),
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
  final void Function(int) onTap;

  const _BottomNav({required this.selectedIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    const items = [
      (Icons.home_rounded, Icons.home_outlined, AppStrings.home),
      (Icons.school_rounded, Icons.school_outlined, AppStrings.scholar),
      (
        Icons.description_rounded,
        Icons.description_outlined,
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
        border: Border(top: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: SafeArea(
        child: Row(
          children: List.generate(items.length, (i) {
            final isSelected = i == selectedIndex;
            return Expanded(
              child: GestureDetector(
                onTap: () => onTap(i),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isSelected ? items[i].$1 : items[i].$2,
                        color: isSelected
                            ? AppColors.primary
                            : const Color(0xFF9E9E9E),
                        size: 24,
                      ),
                      const SizedBox(height: 3),
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
        title: Text(
          label,
          style: AppTextStyle.h3.copyWith(color: Colors.white),
        ),
        elevation: 0,
      ),
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.construction_rounded,
              color: AppColors.textTertiary,
              size: 48,
            ),
            const SizedBox(height: 12),
            Text(
              'Coming Soon',
              style: AppTextStyle.h3.copyWith(color: AppColors.textTertiary),
            ),
          ],
        ),
      ),
    );
  }
}
