import 'package:flutter/material.dart';
import '/shared/application_repository.dart';

enum NotificationType { status, announcement }

class NotificationModel {
  final String id;
  final String scholarshipName;
  final ApplicationStatus status;
  final DateTime createdAt;
  final bool isRead;
  final NotificationType type;
  final String? customTitle;
  final String? customMessage;

  const NotificationModel({
    required this.id,
    required this.scholarshipName,
    required this.status,
    required this.createdAt,
    this.isRead = false,
    this.type = NotificationType.status,
    this.customTitle,
    this.customMessage,
  });

  String get title {
    if (customTitle != null && customTitle!.trim().isNotEmpty) {
      return customTitle!;
    }

    switch (status) {
      case ApplicationStatus.pending:
        return 'ส่งใบสมัครสำเร็จ';
      case ApplicationStatus.reviewing:
        return 'ใบสมัครของคุณกำลังอยู่ระหว่างการพิจารณา';
      case ApplicationStatus.approved:
        return 'ใบสมัครของคุณได้รับการอนุมัติ';
      case ApplicationStatus.rejected:
        return 'ใบสมัครของคุณไม่ผ่านการพิจารณา';
    }
  }

  String get message {
    if (customMessage != null && customMessage!.trim().isNotEmpty) {
      return customMessage!;
    }

    switch (status) {
      case ApplicationStatus.pending:
        return 'ระบบได้รับใบสมัครทุน $scholarshipName ของคุณเรียบร้อยแล้ว';
      case ApplicationStatus.reviewing:
        return 'ขณะนี้ใบสมัครทุน $scholarshipName ของคุณกำลังอยู่ระหว่างการตรวจสอบ';
      case ApplicationStatus.approved:
        return 'ขอแสดงความยินดี ใบสมัครทุน $scholarshipName ของคุณได้รับการอนุมัติแล้ว';
      case ApplicationStatus.rejected:
        return 'ขออภัย ใบสมัครทุน $scholarshipName ของคุณไม่ผ่านการพิจารณา';
    }
  }

  String get statusLabel {
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

  IconData get icon {
    if (type == NotificationType.announcement) {
      return Icons.campaign_outlined;
    }

    switch (status) {
      case ApplicationStatus.pending:
        return Icons.schedule_outlined;
      case ApplicationStatus.reviewing:
        return Icons.access_time_filled_rounded;
      case ApplicationStatus.approved:
        return Icons.check_circle_outline_rounded;
      case ApplicationStatus.rejected:
        return Icons.cancel_outlined;
    }
  }

  Color get iconColor {
    if (type == NotificationType.announcement) {
      return const Color(0xFF7B2FF7);
    }

    switch (status) {
      case ApplicationStatus.pending:
        return const Color(0xFFFF6B35);
      case ApplicationStatus.reviewing:
        return const Color(0xFFFF6B35);
      case ApplicationStatus.approved:
        return const Color(0xFF16A34A);
      case ApplicationStatus.rejected:
        return const Color(0xFFDC2626);
    }
  }
}
