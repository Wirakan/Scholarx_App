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
        case _FilterTab.all:
          return true;
      }
    }).toList();
  }

  String _timeAgo(DateTime date) {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final diff = now.difference(date);

    if (_isSameDay(date, todayStart) || date.isAfter(todayStart)) {
      return '${date.hour.toString().padLeft(2, '0')}:'
          '${date.minute.toString().padLeft(2, '0')} น.';
    } else if (diff.inDays == 1) {
      return '1 วันที่แล้ว';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} วันที่แล้ว';
    } else {
      return '${(diff.inDays / 7).floor()} สัปดาห์ที่แล้ว';
    }
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ApplicationRepository.instance,
      builder: (context, _) {
        final allItems = ApplicationRepository.instance.byStudent(_studentId);
        final filtered = _filtered;

        return Scaffold(
          backgroundColor: const Color(0xFFF5F5F5),
          body: Column(
            children: [
              _buildHeader(allItems.length),
              _buildTabs(),
              Expanded(
                child: filtered.isEmpty
                    ? const _EmptyState()
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 0),
                        itemBuilder: (context, index) {
                          return _TrackingCard(
                            record: filtered[index],
                            timeAgo: _timeAgo(filtered[index].updatedAt),
                          );
                        },
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

  Widget _buildHeader(int count) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFF5722), Color(0xFFFF7043)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 20,
        left: 20,
        right: 20,
        bottom: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ติดตามทุน',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'คำขอของฉันทั้งหมด $count รายการ',
            style: AppTextStyle.body.copyWith(
              color: Colors.white.withOpacity(0.92),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                        ? const Color(0xFFEB591A)
                        : Colors.transparent,
                    border: Border.all(
                      color: active
                          ? const Color(0xFFEB591A)
                          : const Color(0xFFE0E0E0),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    tab.label,
                    style:
                        const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ).copyWith(
                          color: active
                              ? Colors.white
                              : const Color(0xFF757575),
                        ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
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
//  TRACKING CARD
// ─────────────────────────────────────────────
class _TrackingCard extends StatelessWidget {
  final ApplicationRecord record;
  final String timeAgo;

  const _TrackingCard({required this.record, required this.timeAgo});

  Color _statusColor(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.pending:
        return const Color(0xFFE07A5F);
      case ApplicationStatus.reviewing:
        return const Color(0xFFE07A5F);
      case ApplicationStatus.approved:
        return const Color(0xFF16A34A);
      case ApplicationStatus.rejected:
        return const Color(0xFFDC2626);
    }
  }

  IconData _statusIcon(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.pending:
        return Icons.assignment_outlined;
      case ApplicationStatus.reviewing:
        return Icons.assignment_outlined;
      case ApplicationStatus.approved:
        return Icons.check_circle_outline_rounded;
      case ApplicationStatus.rejected:
        return Icons.cancel_outlined;
    }
  }

  Color _statusBg(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.pending:
        return const Color(0xFFFFF7ED);
      case ApplicationStatus.reviewing:
        return const Color(0xFFFFF7ED);
      case ApplicationStatus.approved:
        return const Color(0xFFF0FDF4);
      case ApplicationStatus.rejected:
        return const Color(0xFFFEF2F2);
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(record.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: _statusBg(record.status),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _statusIcon(record.status),
              color: statusColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              record.status.label,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: statusColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      timeAgo,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  record.scholarshipName,
                  style: AppTextStyle.title.copyWith(
                    fontSize: 14.5,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'ยื่นเมื่อ: ${record.formattedAppliedDate}',
                  style: AppTextStyle.caption.copyWith(
                    color: const Color(0xFF757575),
                    fontSize: 12.5,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _formatAmount(record.amount),
                        style: AppTextStyle.heading3.copyWith(
                          color: AppColors.primary,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Text(
                      record.id,
                      style: AppTextStyle.caption.copyWith(
                        color: const Color(0xFF9E9E9E),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
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
//  EMPTY STATE
// ─────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  const _EmptyState();

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
