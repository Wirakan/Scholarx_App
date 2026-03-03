import 'package:flutter/material.dart';
import '/coreApp/themeApp/app_colors.dart';
import '/coreApp/themeApp/app_text_style.dart';
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
}

// ─────────────────────────────────────────────
//  MOCK DATA
// ─────────────────────────────────────────────
const _mockItems = [
  TrackingItem(
    id: 'AP011001',
    title: 'ทุนด้านเทคโนโลยีดิจิทัล',
    appliedDate: '12 ม.ค. 2569',
    updatedDate: '20 ม.ค. 2569',
    amount: 10000,
    status: TrackingStatus.reviewing,
  ),
  TrackingItem(
    id: 'AP011002',
    title: 'ทุนผู้ช่วยเพื่อพัฒนาทักษะวิชาชีพ',
    appliedDate: '05 มี.ค. 2568',
    updatedDate: '24 มี.ค. 2568',
    amount: 25000,
    status: TrackingStatus.approved,
  ),
  TrackingItem(
    id: 'AP011003',
    title: 'ทุนพัฒนาผู้นำเยาวชนรุ่นใหม่',
    appliedDate: '23 มิ.ย. 2568',
    updatedDate: '30 ส.ค. 2568',
    amount: 30000,
    status: TrackingStatus.approved,
  ),
  TrackingItem(
    id: 'AP011004',
    title: 'ทุนส่งเสริมโอกาสทางการศึกษา',
    appliedDate: '10 พ.ย. 2568',
    updatedDate: '09 มิ.ย. 2568',
    amount: 40000,
    status: TrackingStatus.approved,
  ),
];

// ─────────────────────────────────────────────
//  MAIN SCREEN
// ─────────────────────────────────────────────
class TrackingScreen extends StatefulWidget {
  /// When set, this item is highlighted / pre-selected on open
  final TrackingItem? highlightItem;

  /// Set false when used as a tab inside IndexedStack (bottom nav provided by parent)
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

  List<TrackingItem> get _filtered {
    if (_activeTab == _FilterTab.all) return _mockItems;
    return _mockItems.where((e) {
      switch (_activeTab) {
        case _FilterTab.reviewing:
          return e.status == TrackingStatus.reviewing;
        case _FilterTab.approved:
          return e.status == TrackingStatus.approved;
        case _FilterTab.rejected:
          return e.status == TrackingStatus.rejected;
        case _FilterTab.special:
          return e.status == TrackingStatus.special;
        default:
          return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
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
                  style: AppTextStyle.heading2.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  'คำขอของฉันทั้งหมด ${_mockItems.length} รายการ',
                  style: AppTextStyle.body.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),

          // ── WHITE FILTER TABS ──
          Container(
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
            child: _filtered.isEmpty
                ? _EmptyState()
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (ctx, i) {
                      final item = _filtered[i];
                      final isHighlighted = widget.highlightItem?.id == item.id;
                      return _TrackingCard(
                        item: item,
                        isHighlighted: isHighlighted,
                      );
                    },
                  ),
          ),

          // ── BOTTOM NAV ──
          if (widget.showBottomNav) _BottomNavBar(onNavTap: widget.onNavTap),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  FILTER TAB ENUM
// ─────────────────────────────────────────────
enum _FilterTab { all, reviewing, approved, rejected, special }

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
      case _FilterTab.special:
        return 'พิเศษ';
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: isHighlighted
            ? Border.all(color: AppColors.primary, width: 2)
            : null,
        boxShadow: isHighlighted
            ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: AppTextStyle.title.copyWith(fontSize: 15),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'ยื่นเมื่อ: ${item.appliedDate}',
                      style: AppTextStyle.caption,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _formatAmount(item.amount),
                style: AppTextStyle.heading3.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Status badge
          _StatusBadge(status: item.status),
          const SizedBox(height: 10),
          // Updated date
          Text(
            'อัปเดตล่าสุด: ${item.updatedDate}',
            style: AppTextStyle.caption,
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
        fg = const Color(0xFF2E7D32);
        label = 'อนุมัติ';
        break;
      case TrackingStatus.rejected:
        bg = const Color(0xFFFFEBEE);
        fg = const Color(0xFFC62828);
        label = 'ปฏิเสธ';
        break;
      case TrackingStatus.special:
        bg = const Color(0xFFE3F2FD);
        fg = const Color(0xFF1565C0);
        label = 'พิเศษ';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: fg),
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
  final IconData activeIcon;
  final IconData inactiveIcon;
  final String label;
  const _NavDef(this.activeIcon, this.inactiveIcon, this.label);
}
