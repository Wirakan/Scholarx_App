import 'package:flutter/material.dart';
import '/shared/application_repository.dart';
import '/student/models/student_model.dart';
import '/student/models/notification_model.dart';
import 'notification_detail_screen.dart';

class NotificationScreen extends StatefulWidget {
  final void Function(NotificationModel)? onOpenDetail;

  const NotificationScreen({super.key, this.onOpenDetail});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  int _selectedTab = 0;
  final String _studentId = StudentModel.mock.studentId;

  List<_NotifItem> _buildItems() {
    final repo = ApplicationRepository.instance;
    final records = repo.byStudent(_studentId);

    final statusItems = records.map((record) {
      return _NotifItem.status(record);
    }).toList();

    final activityItems = <_NotifItem>[
      _NotifItem.announcement(
        id: 'ann-1',
        title: 'ทุน ASEAN Future Leaders เปิดรับสมัครแล้ว สมัครได้เลย',
        message:
            'เปิดรับสมัครทุน ASEAN Future Leaders สำหรับนักศึกษาที่มีผลการเรียนดีและมีศักยภาพด้านผู้นำ สามารถตรวจสอบคุณสมบัติและยื่นใบสมัครได้ในระบบ',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      _NotifItem.announcement(
        id: 'ann-2',
        title:
            'เงื่อนไขของทุน AI & Robotics Engineering มีการอัปเดต กรุณาตรวจสอบรายละเอียดล่าสุด',
        message:
            'มีการอัปเดตคุณสมบัติผู้สมัครและเอกสารที่ต้องใช้สำหรับทุน AI & Robotics Engineering กรุณาเปิดดูรายละเอียดก่อนส่งใบสมัคร',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
      _NotifItem.announcement(
        id: 'ann-3',
        title: 'กำหนดการสัมภาษณ์ทุนการศึกษาประจำภาคเรียนนี้ถูกประกาศแล้ว',
        message:
            'ผู้สมัครที่ผ่านการคัดกรองเบื้องต้นสามารถตรวจสอบวัน เวลา และสถานที่สัมภาษณ์ได้จากหน้ารายละเอียดทุนหรือประกาศในระบบ',
        createdAt: DateTime.now().subtract(const Duration(days: 8)),
      ),
    ];

    final all = [...statusItems, ...activityItems];
    all.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return all;
  }

  List<_NotifItem> get _filteredItems {
    final all = _buildItems();

    if (_selectedTab == 1) {
      return all.where((item) => item.isStatus).toList();
    }

    if (_selectedTab == 2) {
      return all.where((item) => !item.isStatus).toList();
    }

    return all;
  }

  Map<String, List<_NotifItem>> _grouped(List<_NotifItem> items) {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final weekStart = todayStart.subtract(const Duration(days: 6));

    final grouped = <String, List<_NotifItem>>{
      'วันนี้': [],
      'สัปดาห์นี้': [],
    };

    for (final item in items) {
      final updatedAt = item.createdAt;

      if (_isSameDay(updatedAt, todayStart) || updatedAt.isAfter(todayStart)) {
        grouped['วันนี้']!.add(item);
      } else if (updatedAt.isAfter(weekStart)) {
        grouped['สัปดาห์นี้']!.add(item);
      }
    }

    grouped.removeWhere((key, value) => value.isEmpty);
    return grouped;
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
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

  String _statusLabel(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.pending:
        return 'รอดำเนินการ';
      case ApplicationStatus.reviewing:
        return 'กำลังพิจารณา';
      case ApplicationStatus.approved:
        return 'อนุมัติแล้ว';
      case ApplicationStatus.rejected:
        return 'ไม่ผ่านการพิจารณา';
    }
  }

  Color _statusColor(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.pending:
        return const Color(0xFFF59E0B);
      case ApplicationStatus.reviewing:
        return const Color(0xFFF59E0B);
      case ApplicationStatus.approved:
        return const Color(0xFF16A34A);
      case ApplicationStatus.rejected:
        return const Color(0xFFDC2626);
    }
  }

  IconData _statusIcon(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.pending:
        return Icons.schedule_outlined;
      case ApplicationStatus.reviewing:
        return Icons.hourglass_top_rounded;
      case ApplicationStatus.approved:
        return Icons.check_circle_outline_rounded;
      case ApplicationStatus.rejected:
        return Icons.cancel_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ApplicationRepository.instance,
      builder: (context, _) {
        final all = _buildItems();
        final grouped = _grouped(_filteredItems);

        return Scaffold(
          backgroundColor: const Color(0xFFF5F5F5),
          body: Column(
            children: [
              _buildHeader(all.length),
              _buildTabs(),
              Expanded(
                child: grouped.isEmpty
                    ? const Center(
                        child: Text(
                          'ไม่มีการแจ้งเตือน',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      )
                    : ListView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        children: [
                          for (final entry in grouped.entries) ...[
                            _buildGroupHeader(entry.key),
                            const SizedBox(height: 8),
                            for (final item in entry.value) _buildCard(item),
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
            'การแจ้งเตือนทั้งหมด $count รายการ',
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    const labels = ['ทั้งหมด', 'ข้อความ', 'กิจกรรม'];

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(labels.length, (index) {
            final selected = _selectedTab == index;

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedTab = index;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: selected
                        ? const Color(0xFFEB591A)
                        : Colors.transparent,
                    border: Border.all(
                      color: selected
                          ? const Color(0xFFEB591A)
                          : const Color(0xFFE0E0E0),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    labels[index],
                    style:
                        const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ).copyWith(
                          color: selected
                              ? Colors.white
                              : const Color(0xFF757575),
                        ),
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
    return Text(
      label,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildCard(_NotifItem item) {
    if (item.isStatus && item.record != null) {
      final record = item.record!;
      final notifModel = NotificationModel(
        id: record.id,
        scholarshipName: record.scholarshipName,
        status: record.status,
        createdAt: record.updatedAt,
        isRead: record.studentNotified,
        type: NotificationType.status,
      );

      final statusColor = _statusColor(record.status);

      return GestureDetector(
        onTap: () {
          ApplicationRepository.instance.markNotified(record.id);

          if (widget.onOpenDetail != null) {
            widget.onOpenDetail!(notifModel);
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    NotificationDetailScreen(notification: notifModel),
              ),
            );
          }
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: record.studentNotified
                ? Colors.white
                : const Color(0xFFFFF8F6),
            borderRadius: BorderRadius.circular(14),
            border: record.studentNotified
                ? null
                : Border.all(color: const Color(0xFFFF5722).withOpacity(0.3)),
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
                decoration: const BoxDecoration(
                  color: Color(0xFFFFF0EC),
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
                                  _statusLabel(record.status),
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
                          _timeAgo(record.updatedAt),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'ใบสมัคร ${record.scholarshipName} — ${_statusLabel(record.status)}',
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: Colors.black87,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              if (!record.studentNotified)
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(top: 4, left: 4),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF5722),
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      );
    }

    final notifModel = NotificationModel(
      id: item.id!,
      scholarshipName: item.title ?? 'ประกาศ',
      status: ApplicationStatus.pending,
      createdAt: item.createdAt,
      isRead: item.isRead,
      type: NotificationType.announcement,
      customTitle: item.title,
      customMessage: item.message,
    );

    return GestureDetector(
      onTap: () {
        if (widget.onOpenDetail != null) {
          widget.onOpenDetail!(notifModel);
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  NotificationDetailScreen(notification: notifModel),
            ),
          );
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
              decoration: const BoxDecoration(
                color: Color(0xFFF3EEFF),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.campaign_outlined,
                color: Color(0xFF7B2FF7),
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
                                color: const Color(0xFFEEE0FF),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'ประกาศ!',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF7B2FF7),
                                ),
                              ),
                            ),
                          ],
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
                    item.title ?? '',
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

class _NotifItem {
  final ApplicationRecord? record;
  final bool isStatus;

  final String? id;
  final String? title;
  final String? message;
  final DateTime createdAt;
  final bool isRead;

  const _NotifItem({
    required this.record,
    required this.isStatus,
    required this.id,
    required this.title,
    required this.message,
    required this.createdAt,
    required this.isRead,
  });

  factory _NotifItem.status(ApplicationRecord record) {
    return _NotifItem(
      record: record,
      isStatus: true,
      id: record.id,
      title: 'ใบสมัคร ${record.scholarshipName}',
      message: null,
      createdAt: record.updatedAt,
      isRead: record.studentNotified,
    );
  }

  factory _NotifItem.announcement({
    required String id,
    required String title,
    required String message,
    required DateTime createdAt,
    bool isRead = true,
  }) {
    return _NotifItem(
      record: null,
      isStatus: false,
      id: id,
      title: title,
      message: message,
      createdAt: createdAt,
      isRead: isRead,
    );
  }
}
