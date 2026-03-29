import 'package:flutter/material.dart';
import '/student/models/notification_model.dart';

// ===== MOCK DATA (replace with API/provider) =====
final List<NotificationItem> _mockNotifications = [
  NotificationItem(
    id: '1',
    type: NotificationType.status,
    title: 'ใบสมัครของคุณสำหรับทุนด้านเทคโนโลยีดิจิทัล กำลังอยู่ระหว่างการพิจารณา',
    statusLabel: 'กำลังพิจารณา',
    status: ApplicationStatus.pending,
    createdAt: DateTime.now(),
  ),
  NotificationItem(
    id: '2',
    type: NotificationType.announcement,
    title: 'ทุน ASEAN Future Leaders เปิดรับสมัครแล้ว สมัครได้เลย',
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
  ),
  NotificationItem(
    id: '3',
    type: NotificationType.announcement,
    title: 'เงื่อนไขของทุน AI & Robotics Engineering มีการอัปเดต กรุณาตรวจสอบรายละเอียดล่าสุด',
    createdAt: DateTime.now().subtract(const Duration(days: 3)),
  ),
];

// ===== SCREEN =====
class NotificationScreen extends StatefulWidget {
  final void Function(NotificationModel)? onOpenDetail;
  const NotificationScreen({super.key, this.onOpenDetail});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  int _selectedTab = 0;

  List<NotificationItem> get _filtered {
    if (_selectedTab == 1) {
      return _mockNotifications
          .where((n) => n.type == NotificationType.status)
          .toList();
    } else if (_selectedTab == 2) {
      return _mockNotifications
          .where((n) => n.type == NotificationType.announcement)
          .toList();
    }
    return _mockNotifications;
  }

  Map<String, List<NotificationItem>> _grouped(List<NotificationItem> items) {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final weekStart = todayStart.subtract(const Duration(days: 6));

    final Map<String, List<NotificationItem>> grouped = {
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

    grouped.removeWhere((key, value) => value.isEmpty);
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
    } else {
      return '${(diff.inDays / 7).floor()} สัปดาห์ที่แล้ว';
    }
  }

  @override
  Widget build(BuildContext context) {
    final grouped = _grouped(_filtered);
    final totalCount = _mockNotifications.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          _buildHeader(totalCount),
          _buildTabs(),
          Expanded(
            child: grouped.isEmpty
                ? const Center(
                    child: Text(
                      'ไม่มีการแจ้งเตือน',
                      style: TextStyle(color: Colors.grey),
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
  }

  Widget _buildHeader(int totalCount) {
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
          const Text(
            'การแจ้งเตือน',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'การแจ้งเตือนทั้งหมด $totalCount รายการ',
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    const labels = ['ทั้งหมด', 'ข้อความ', 'กิจกรรม'];
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: List.generate(labels.length, (i) {
          final selected = _selectedTab == i;
          return GestureDetector(
            onTap: () => setState(() => _selectedTab = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFFFF5722)
                    : const Color(0xFFF0F0F0),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                labels[i],
                style: TextStyle(
                  color: selected ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildGroupHeader(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
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
        if (notificationModel != null) {
          widget.onOpenDetail?.call(notificationModel);
        }
      },
      child: Container(
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
                color: isStatus
                    ? const Color(0xFFFFF0EC)
                    : const Color(0xFFF3EEFF),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isStatus
                    ? Icons.assignment_outlined
                    : Icons.campaign_outlined,
                color: isStatus
                    ? const Color(0xFFFF5722)
                    : const Color(0xFF7B2FF7),
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
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: isStatus
                              ? const Color(0xFFFFE5DC)
                              : const Color(0xFFEEE0FF),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          isStatus
                              ? (item.statusLabel ?? 'อัปเดตสถานะ')
                              : 'ประกาศ!',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isStatus
                                ? const Color(0xFFFF5722)
                                : const Color(0xFF7B2FF7),
                          ),
                        ),
                      ),
                      Text(
                        _timeAgo(item.createdAt),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 13.5,
                      color: Colors.black87,
                      height: 1.4,
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