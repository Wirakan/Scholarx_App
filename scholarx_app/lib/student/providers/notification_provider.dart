//   1. ครอบ app ด้วย MultiProvider ใน main.dart (ดูไฟล์ main.dart)
//   2. เรียก addNotification() จาก confirm_sheet.dart ตอน admin อนุมัติ/ปฏิเสธ
//   3. อ่าน notifications / unreadCount ใน notification_screen.dart และ student_home_screen.dart

import 'package:flutter/material.dart';
import '/student/models/notification_model.dart';
import '/student/providers/tracking_provider.dart';
import '/student/screens/tracking/tracking_screen.dart';

class NotificationProvider extends ChangeNotifier {
  final TrackingProvider _trackingProvider;

  NotificationProvider(this._trackingProvider);

  final List<NotificationItem> _notifications = [
    // Mock data เริ่มต้น — ลบออกได้เมื่อต่อ API จริง
    NotificationItem(
      id: 'mock_1',
      type: NotificationType.status,
      title: 'ใบสมัครของคุณสำหรับทุนด้านเทคโนโลยีดิจิทัล กำลังอยู่ระหว่างการพิจารณา',
      statusLabel: 'กำลังพิจารณา',
      status: ApplicationStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    NotificationItem(
      id: 'mock_2',
      type: NotificationType.announcement,
      title: 'ทุน ASEAN Future Leaders เปิดรับสมัครแล้ว สมัครได้เลย',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    NotificationItem(
      id: 'mock_3',
      type: NotificationType.announcement,
      title: 'เงื่อนไขของทุน AI & Robotics Engineering มีการอัปเดต กรุณาตรวจสอบรายละเอียดล่าสุด',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  // ── Public getters ─────────────────────────────────────────────────────────

  List<NotificationItem> get notifications => List.unmodifiable(_notifications);

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  bool get hasUnread => unreadCount > 0;

  // ── Actions ────────────────────────────────────────────────────────────────

  /// เรียกจาก confirm_sheet.dart เมื่อ admin อนุมัติหรือปฏิเสธ
  void addStatusNotification({
    required String scholarshipName,
    required ApplicationStatus status,
  }) {
    final label = switch (status) {
      ApplicationStatus.approved => 'อนุมัติแล้ว',
      ApplicationStatus.rejected => 'ไม่ผ่านการพิจารณา',
      ApplicationStatus.pending => 'กำลังพิจารณา',
    };

    final title = switch (status) {
      ApplicationStatus.approved =>
        'ใบสมัครทุน "$scholarshipName" ได้รับการอนุมัติแล้ว',
      ApplicationStatus.rejected =>
        'ใบสมัครทุน "$scholarshipName" ไม่ผ่านการพิจารณา',
      ApplicationStatus.pending =>
        'ใบสมัครทุน "$scholarshipName" อยู่ระหว่างการพิจารณา',
    };

    _add(NotificationItem(
      id: _newId(),
      type: NotificationType.status,
      title: title,
      statusLabel: label,
      status: status,
      createdAt: DateTime.now(),
    ));

    // ── sync สถานะไปยัง TrackingProvider ──
    final trackingStatus = switch (status) {
      ApplicationStatus.approved => TrackingStatus.approved,
      ApplicationStatus.rejected => TrackingStatus.rejected,
      ApplicationStatus.pending => TrackingStatus.reviewing,
    };
    _trackingProvider.updateStatusByTitle(
      scholarshipName: scholarshipName,
      newStatus: trackingStatus,
    );
  }

  /// เรียกจากฝั่ง admin เมื่อเพิ่มทุนใหม่หรือส่งประกาศ
  void addAnnouncement({required String title}) {
    _add(NotificationItem(
      id: _newId(),
      type: NotificationType.announcement,
      title: title,
      createdAt: DateTime.now(),
    ));
  }

  /// มาร์กทุกอันว่าอ่านแล้ว — เรียกเมื่อ user เปิดหน้า notification
  void markAllRead() {
    bool changed = false;
    for (int i = 0; i < _notifications.length; i++) {
      if (!_notifications[i].isRead) {
        _notifications[i] = _notifications[i].copyWith(isRead: true);
        changed = true;
      }
    }
    if (changed) notifyListeners();
  }

  /// มาร์กรายการเดียว
  void markRead(String id) {
    final idx = _notifications.indexWhere((n) => n.id == id);
    if (idx != -1 && !_notifications[idx].isRead) {
      _notifications[idx] = _notifications[idx].copyWith(isRead: true);
      notifyListeners();
    }
  }

  // ── Private helpers ────────────────────────────────────────────────────────

  void _add(NotificationItem item) {
    _notifications.insert(0, item);
    notifyListeners();
  }

  String _newId() => 'notif_${DateTime.now().millisecondsSinceEpoch}';
}