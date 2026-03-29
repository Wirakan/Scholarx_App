import 'package:flutter/material.dart';
import '/coreApp/themeApp/app_colors.dart';
import '/coreApp/themeApp/app_text_style.dart';
import '/shared/application_repository.dart';
import '/student/models/student_model.dart';

// ─────────────────────────────────────────────
//  MAIN SCREEN
// ─────────────────────────────────────────────
class TrackingScreen extends StatefulWidget {
  final bool showBottomNav;
  final void Function(int index)? onNavTap;

  const TrackingScreen({super.key, this.showBottomNav = true, this.onNavTap});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  _FilterTab _activeTab = _FilterTab.all;
  final _studentId = StudentModel.mock.studentId;

  List<ApplicationRecord> get _filtered {
    final repo = ApplicationRepository.instance;
    final all = repo.byStudent(_studentId);
    if (_activeTab == _FilterTab.all) return all;
    return all.where((r) {
      switch (_activeTab) {
        case _FilterTab.reviewing:
          return r.status == ApplicationStatus.reviewing;
        case _FilterTab.approved:
          return r.status == ApplicationStatus.approved;
        case _FilterTab.rejected:
          return r.status == ApplicationStatus.rejected;
        default:
          return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ApplicationRepository.instance,
      builder: (context, _) {
        final allItems = ApplicationRepository.instance.byStudent(_studentId);
        final filtered = _filtered;
        return Scaffold(
          backgroundColor: AppColors.background,
          body: Column(
            children: [
              // ── ORANGE HEADER ──
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFEB591A), Color(0xFFFF7A3D)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(20, 56, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ติดตามทุน',
                      style: AppTextStyle.heading2.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'คำขอของฉันทั้งหมด ${allItems.length} รายการ',
                      style: AppTextStyle.body.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),

              // ── FILTER TABS ──
              Container(
                width: double.infinity,
                color: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _FilterTab.values.map((tab) {
                      final active = tab == _activeTab;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () => setState(() => _activeTab = tab),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: active
                                  ? AppColors.primary
                                  : Colors.transparent,
                              border: Border.all(
                                color: active
                                    ? AppColors.primary
                                    : AppColors.border,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              tab.label,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: active
                                    ? Colors.white
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

              // ── LIST ──
              Expanded(
                child: filtered.isEmpty
                    ? _EmptyState()
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (ctx, i) =>
                            _TrackingCard(record: filtered[i]),
                      ),
              ),

              if (widget.showBottomNav)
                _BottomNavBar(onNavTap: widget.onNavTap),
            ],
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────
//  FILTER TAB ENUM
// ─────────────────────────────────────────────
enum _FilterTab { all, reviewing, approved, rejected }

extension _FilterTabX on _FilterTab {
  String get label {
    switch (this) {
      case _FilterTab.all:
        return 'ทั้งหมด';
      case _FilterTab.reviewing:
        return 'กำลังพิจารณา';
      case _FilterTab.approved:
        return 'อนุมัติ';
      case _FilterTab.rejected:
        return 'ปฏิเสธ';
    }
  }
}

// ─────────────────────────────────────────────
//  TRACKING CARD — อ่านจาก ApplicationRecord จริง
// ─────────────────────────────────────────────
class _TrackingCard extends StatelessWidget {
  final ApplicationRecord record;
  const _TrackingCard({required this.record});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  record.scholarshipName,
                  style: AppTextStyle.title.copyWith(fontSize: 15),
                ),
              ),
              const SizedBox(width: 8),
              _StatusBadge(status: record.status),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'ยื่นเมื่อ: ${record.formattedAppliedDate}',
            style: AppTextStyle.caption,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatAmount(record.amount),
                style: AppTextStyle.heading3.copyWith(
                  color: AppColors.primary,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(record.id, style: AppTextStyle.caption),
            ],
          ),
        ],
      ),
    );
  }

  String _formatAmount(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
  }
}

// ─────────────────────────────────────────────
//  STATUS BADGE
// ─────────────────────────────────────────────
class _StatusBadge extends StatelessWidget {
  final ApplicationStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;

    switch (status) {
      case ApplicationStatus.pending:
        bg = const Color(0xFFFFF3E0);
        fg = const Color(0xFFE65100);
        break;
      case ApplicationStatus.reviewing:
        bg = const Color(0xFFFFF3E0);
        fg = const Color(0xFFE65100);
        break;
      case ApplicationStatus.approved:
        bg = const Color(0xFFE8F5E9);
        fg = const Color(0xFF2E7D32);
        break;
      case ApplicationStatus.rejected:
        bg = const Color(0xFFFFEBEE);
        fg = const Color(0xFFC62828);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status.label,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: fg),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  EMPTY STATE
// ─────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inbox_outlined, size: 56, color: AppColors.textTertiary),
          const SizedBox(height: 12),
          Text(
            'ไม่มีรายการในหมวดนี้',
            style: AppTextStyle.body.copyWith(color: AppColors.textTertiary),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  BOTTOM NAV BAR
// ─────────────────────────────────────────────
class _BottomNavBar extends StatelessWidget {
  final void Function(int index)? onNavTap;
  const _BottomNavBar({this.onNavTap});

  @override
  Widget build(BuildContext context) {
    const items = [
      _NavDef(Icons.home_rounded, Icons.home_outlined, 'Home'),
      _NavDef(Icons.school_rounded, Icons.school_outlined, 'Scholar'),
      _NavDef(Icons.fact_check_rounded, Icons.fact_check_outlined, 'Tracking'),
      _NavDef(
        Icons.notifications_rounded,
        Icons.notifications_outlined,
        'Alerts',
      ),
      _NavDef(Icons.person_rounded, Icons.person_outlined, 'Profile'),
    ];
    const activeIndex = 2;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (i) {
          final isActive = i == activeIndex;
          return GestureDetector(
            onTap: () {
              if (onNavTap != null) {
                onNavTap!(i);
              } else {
                Navigator.of(context).pop(i);
              }
            },
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  isActive
                      ? Container(
                          width: 48,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            items[i].activeIcon,
                            color: Colors.white,
                            size: 22,
                          ),
                        )
                      : Icon(
                          items[i].inactiveIcon,
                          color: const Color(0xFF9E9E9E),
                          size: 24,
                        ),
                  const SizedBox(height: 4),
                  Text(
                    items[i].label,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                      color: isActive
                          ? AppColors.primary
                          : const Color(0xFF9E9E9E),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _NavDef {
  final IconData activeIcon, inactiveIcon;
  final String label;
  const _NavDef(this.activeIcon, this.inactiveIcon, this.label);
}
