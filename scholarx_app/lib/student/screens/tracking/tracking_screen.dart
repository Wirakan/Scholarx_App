import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/coreApp/themeApp/app_colors.dart';
import '/coreApp/themeApp/app_text_style.dart';
import '/student/providers/tracking_provider.dart';

// ─────────────────────────────────────────────
//  DATA MODEL
// ─────────────────────────────────────────────
enum TrackingStatus { reviewing, approved, rejected, special }

class TrackingItem {
  final String id;
  final String title;
  final String appliedDate;
  final String updatedDate;
  final int amount;
  final TrackingStatus status;

  const TrackingItem({
    required this.id,
    required this.title,
    required this.appliedDate,
    required this.updatedDate,
    required this.amount,
    required this.status,
  });

  TrackingItem copyWith({
    String? id,
    String? title,
    String? appliedDate,
    String? updatedDate,
    int? amount,
    TrackingStatus? status,
  }) {
    return TrackingItem(
      id: id ?? this.id,
      title: title ?? this.title,
      appliedDate: appliedDate ?? this.appliedDate,
      updatedDate: updatedDate ?? this.updatedDate,
      amount: amount ?? this.amount,
      status: status ?? this.status,
    );
  }
}

// ─────────────────────────────────────────────
//  MAIN SCREEN
// ─────────────────────────────────────────────
class TrackingScreen extends StatefulWidget {
  final TrackingItem? highlightItem;
  final bool showBottomNav;
  final void Function(int index)? onNavTap;

  const TrackingScreen({
    super.key,
    this.highlightItem,
    this.showBottomNav = true,
    this.onNavTap,
  });

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  _FilterTab _activeTab = _FilterTab.all;

  List<TrackingItem> _filtered(List<TrackingItem> all) {
    if (_activeTab == _FilterTab.all) return all;
    return all.where((e) {
      switch (_activeTab) {
        case _FilterTab.reviewing:
          return e.status == TrackingStatus.reviewing;
        case _FilterTab.approved:
          return e.status == TrackingStatus.approved;
        case _FilterTab.rejected:
          return e.status == TrackingStatus.rejected;
        default:
          return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TrackingProvider>(
      builder: (context, trackingProvider, _) {
        final allItems = trackingProvider.items;
        final filtered = _filtered(allItems);

        return Scaffold(
          backgroundColor: AppColors.background,
          body: Column(
            children: [
              // ── HEADER ── ใช้ MediaQuery เหมือน notification_screen
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryLight],
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
                      style: AppTextStyle.heading2.copyWith(
                        color: AppColors.surface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'คำขอของฉันทั้งหมด ${allItems.length} รายการ',
                      style: AppTextStyle.body.copyWith(
                        color: AppColors.surface.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),

              // ── FILTER TABS ──
              Container(
                width: double.infinity,
                color: AppColors.surface,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
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
                                horizontal: 16, vertical: 8),
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
                              style: AppTextStyle.label.copyWith(
                                fontSize: 13,
                                color: active
                                    ? AppColors.surface
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
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 12),
                        itemBuilder: (ctx, i) {
                          final item = filtered[i];
                          final isHighlighted =
                              widget.highlightItem?.id == item.id;
                          return _TrackingCard(
                            item: item,
                            isHighlighted: isHighlighted,
                          );
                        },
                      ),
              ),

              // ── BOTTOM NAV ──
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
//  TRACKING CARD
// ─────────────────────────────────────────────
class _TrackingCard extends StatelessWidget {
  final TrackingItem item;
  final bool isHighlighted;

  const _TrackingCard({required this.item, this.isHighlighted = false});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: isHighlighted
            ? Border.all(color: AppColors.primary, width: 2)
            : null,
        boxShadow: isHighlighted
            ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                )
              ]
            : null,
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
                  item.title,
                  style: AppTextStyle.title.copyWith(fontSize: 15),
                ),
              ),
              const SizedBox(width: 8),
              _StatusBadge(status: item.status),
            ],
          ),
          const SizedBox(height: 4),
          Text('ยื่นเมื่อ: ${item.appliedDate}',
              style: AppTextStyle.caption),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatAmount(item.amount),
                style: AppTextStyle.heading3.copyWith(
                  color: AppColors.primary,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Icon(Icons.more_vert,
                  color: AppColors.textTertiary, size: 22),
            ],
          ),
        ],
      ),
    );
  }

  String _formatAmount(int amount) {
    if (amount >= 1000) {
      return amount.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]},',
      );
    }
    return amount.toString();
  }
}

// ─────────────────────────────────────────────
//  STATUS BADGE
// ─────────────────────────────────────────────
class _StatusBadge extends StatelessWidget {
  final TrackingStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    String label;

    switch (status) {
      case TrackingStatus.reviewing:
        bg = const Color(0xFFFFF3E0);
        fg = const Color(0xFFE65100);
        label = 'กำลังพิจารณา';
        break;
      case TrackingStatus.approved:
        bg = const Color(0xFFE8F5E9);
        fg = AppColors.success;
        label = 'อนุมัติ';
        break;
      case TrackingStatus.rejected:
        bg = const Color(0xFFFFEBEE);
        fg = AppColors.error;
        label = 'ปฏิเสธ';
        break;
      case TrackingStatus.special:
        bg = const Color(0xFFE3F2FD);
        fg = AppColors.info;
        label = 'พิเศษ';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
          color: bg, borderRadius: BorderRadius.circular(6)),
      child: Text(
        label,
        style: AppTextStyle.overline.copyWith(fontSize: 12, color: fg),
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
          Icon(Icons.inbox_outlined,
              size: 56, color: AppColors.textTertiary),
          const SizedBox(height: 12),
          Text(
            'ไม่มีรายการในหมวดนี้',
            style:
                AppTextStyle.body.copyWith(color: AppColors.textTertiary),
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
      _NavDef(Icons.fact_check_rounded, Icons.fact_check_outlined,
          'Tracking'),
      _NavDef(Icons.notifications_rounded, Icons.notifications_outlined,
          'Alerts'),
      _NavDef(Icons.person_rounded, Icons.person_outlined, 'Profile'),
    ];
    const activeIndex = 2;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
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
              padding: const EdgeInsets.symmetric(
                  horizontal: 8, vertical: 4),
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
                          child: Icon(items[i].activeIcon,
                              color: AppColors.surface, size: 22),
                        )
                      : Icon(items[i].inactiveIcon,
                          color: AppColors.textTertiary, size: 24),
                  const SizedBox(height: 4),
                  Text(
                    items[i].label,
                    style: AppTextStyle.micro.copyWith(
                      fontWeight: isActive
                          ? FontWeight.w700
                          : FontWeight.w400,
                      color: isActive
                          ? AppColors.primary
                          : AppColors.textTertiary,
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
  final IconData activeIcon;
  final IconData inactiveIcon;
  final String label;
  const _NavDef(this.activeIcon, this.inactiveIcon, this.label);
}