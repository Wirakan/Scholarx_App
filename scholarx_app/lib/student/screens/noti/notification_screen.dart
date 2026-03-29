import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/coreApp/themeApp/app_colors.dart';
import '/coreApp/themeApp/app_text_style.dart';
import '/student/models/notification_model.dart';
import '/student/providers/notification_provider.dart';

class NotificationScreen extends StatefulWidget {
  final void Function(NotificationModel)? onOpenDetail;
  const NotificationScreen({super.key, this.onOpenDetail});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  int _selectedTab = 0;

  // สีสำหรับ announcement (purple) — ไม่มีใน AppColors จึงเก็บไว้เป็น local const
  static const Color _purple = Color(0xFF7B2FF7);
  static const Color _purpleBg = Color(0xFFF3EEFF);
  static const Color _purpleChip = Color(0xFFEEE0FF);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationProvider>().markAllRead();
    });
  }

  List<NotificationItem> _filtered(List<NotificationItem> all) {
    if (_selectedTab == 1) {
      return all.where((n) => n.type == NotificationType.status).toList();
    } else if (_selectedTab == 2) {
      return all.where((n) => n.type == NotificationType.announcement).toList();
    }
    return all;
  }

  Map<String, List<NotificationItem>> _grouped(List<NotificationItem> items) {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final weekStart = todayStart.subtract(const Duration(days: 6));

    final grouped = <String, List<NotificationItem>>{
      'วันนี้': [],
      'สัปดาห์นี้': [],
      'เก่ากว่า': [],
    };

    for (final item in items) {
      final d = item.createdAt;
      if (d.isAfter(todayStart) || _isSameDay(d, todayStart)) {
        grouped['วันนี้']!.add(item);
      } else if (d.isAfter(weekStart)) {
        grouped['สัปดาห์นี้']!.add(item);
      } else {
        grouped['เก่ากว่า']!.add(item);
      }
    }

    grouped.removeWhere((_, v) => v.isEmpty);
    return grouped;
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  String _timeAgo(DateTime date) {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final diff = now.difference(date);

    if (date.isAfter(todayStart) || _isSameDay(date, todayStart)) {
      final h = date.hour.toString().padLeft(2, '0');
      final m = date.minute.toString().padLeft(2, '0');
      return '$h:$m น.';
    } else if (diff.inDays == 1) {
      return '1 วันที่แล้ว';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} วันที่แล้ว';
    }
    return '${(diff.inDays / 7).floor()} สัปดาห์ที่แล้ว';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationProvider>(
      builder: (context, provider, _) {
        final filtered = _filtered(provider.notifications);
        final grouped = _grouped(filtered);

        return Scaffold(
          backgroundColor: AppColors.background,
          body: Column(
            children: [
              _buildHeader(provider.notifications.length),
              _buildTabs(),
              Expanded(
                child: grouped.isEmpty
                    ? Center(
                        child: Text(
                          'ไม่มีการแจ้งเตือน',
                          style: AppTextStyle.body.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),
                      )
                    : ListView(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        children: [
                          for (final entry in grouped.entries) ...[
                            _buildGroupHeader(entry.key),
                            const SizedBox(height: 8),
                            for (final item in entry.value)
                              _buildNotificationCard(item),
                            const SizedBox(height: 8),
                          ],
                        ],
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(int totalCount) {
    return Container(
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
            'การแจ้งเตือน',
            style: AppTextStyle.heading2.copyWith(color: AppColors.surface),
          ),
          const SizedBox(height: 4),
          Text(
            'การแจ้งเตือนทั้งหมด $totalCount รายการ',
            style: AppTextStyle.body.copyWith(
              color: AppColors.surface.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    const labels = ['ทั้งหมด', 'ข้อความ', 'กิจกรรม'];
    return Container(
      width: double.infinity,
      color: AppColors.surface,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: List.generate(labels.length, (i) {
            final selected = _selectedTab == i;
            return GestureDetector(
              onTap: () => setState(() => _selectedTab = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(right: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                decoration: BoxDecoration(
                  color: selected ? AppColors.primary : Colors.transparent,
                  border: selected
                      ? null
                      : Border.all(color: AppColors.border, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  labels[i],
                  style: AppTextStyle.label.copyWith(
                    color: selected ? AppColors.surface : AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildGroupHeader(String label) {
    return Text(label, style: AppTextStyle.title.copyWith(fontSize: 15));
  }

  Widget _buildNotificationCard(NotificationItem item) {
    final isStatus = item.type == NotificationType.status;

    final notificationModel = (isStatus && item.status != null)
        ? NotificationModel(
            id: item.id,
            scholarshipName: item.title,
            status: item.status!,
            createdAt: item.createdAt,
            isRead: item.isRead,
          )
        : null;

    return GestureDetector(
      onTap: () {
        context.read<NotificationProvider>().markRead(item.id);
        if (notificationModel != null) {
          widget.onOpenDetail?.call(notificationModel);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: item.isRead ? AppColors.surface : AppColors.primaryBg,
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
            // ── icon circle ──
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: isStatus ? AppColors.primaryBg : _purpleBg,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isStatus ? Icons.assignment_outlined : Icons.campaign_outlined,
                color: isStatus ? AppColors.primary : _purple,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // ── chip ──
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: isStatus ? AppColors.primaryBg : _purpleChip,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          isStatus
                              ? (item.statusLabel ?? 'อัปเดตสถานะ')
                              : 'ประกาศ!',
                          style: AppTextStyle.overline.copyWith(
                            color: isStatus ? AppColors.primary : _purple,
                          ),
                        ),
                      ),
                      // ── dot + time ──
                      Row(
                        children: [
                          if (!item.isRead)
                            Container(
                              width: 7,
                              height: 7,
                              margin: const EdgeInsets.only(right: 5),
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                          Text(
                            _timeAgo(item.createdAt),
                            style: AppTextStyle.caption,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.title,
                    style: AppTextStyle.body.copyWith(
                      height: 1.4,
                      fontWeight:
                          item.isRead ? FontWeight.normal : FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}