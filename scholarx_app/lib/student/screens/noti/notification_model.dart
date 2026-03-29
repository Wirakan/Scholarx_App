import 'package:flutter/material.dart';

enum ApplicationStatus { pending, approved, rejected }

enum NotificationType { status, announcement }

class NotificationModel {
  final String id;
  final String scholarshipName;
  final ApplicationStatus status;
  final DateTime createdAt;
  final bool isRead;

  const NotificationModel({
    required this.id,
    required this.scholarshipName,
    required this.status,
    required this.createdAt,
    this.isRead = false,
  });

  String get title => switch (status) {
        ApplicationStatus.pending => 'ใบสมัครอยู่ระหว่างการพิจารณา',
        ApplicationStatus.approved => 'อนุมัติเรียบร้อย',
        ApplicationStatus.rejected => 'ไม่ผ่านการพิจารณา',
      };

  String get body => switch (status) {
        ApplicationStatus.pending =>
          'ขอแจ้งให้ทราบว่า ใบสมัครของท่านสำหรับทุน $scholarshipName '
              'ได้เข้าสู่ขั้นตอนถัดไปเรียบร้อยแล้ว ขณะนี้คณะกรรมการกำลังดำเนินการ'
              'พิจารณาผลงานและเอกสารผลการเรียนที่ท่านได้ส่งมา\n\n'
              'โดยปกติ กระบวนการพิจารณาจะใช้เวลาประมาณ 5–7 วันทำการ '
              'ทั้งนี้ ท่านจะได้รับการแจ้งเตือนอีกครั้งเมื่อมีผลการพิจารณาขั้นสุดท้าย '
              'หรือในกรณีที่มีความจำเป็นต้องขอเอกสารเพิ่มเติม',
        ApplicationStatus.approved =>
          'ขอแสดงความยินดี ใบสมัครของท่านได้รับการอนุมัติเรียบร้อยแล้ว '
              'โดยท่านผ่านเกณฑ์การพิจารณาตามที่โครงการกำหนด\n\n'
              'กรุณาตรวจสอบรายละเอียดเพิ่มเติมเกี่ยวกับขั้นตอนถัดไป '
              'หรือเงื่อนไขการรับสิทธิ์ภายในระบบ ทั้งนี้ หากมีข้อสงสัย '
              'สามารถติดต่อเจ้าหน้าที่เพื่อขอข้อมูลเพิ่มเติมได้',
        ApplicationStatus.rejected =>
          'ขอขอบคุณที่ท่านให้ความสนใจและสมัครเข้าร่วมโครงการ '
              'อย่างไรก็ตาม ใบสมัครของท่านไม่ผ่านการพิจารณาในครั้งนี้\n\n'
              'การพิจารณาอ้างอิงจากเกณฑ์และคุณสมบัติที่กำหนด '
              'ทั้งนี้ ท่านสามารถสมัครใหม่ได้ในรอบถัดไป '
              'หรือปรับปรุงข้อมูลเพื่อเพิ่มโอกาสในการพิจารณาในอนาคต',
      };

  IconData get icon => switch (status) {
        ApplicationStatus.pending => Icons.assignment_outlined,
        ApplicationStatus.approved => Icons.check_circle_outline,
        ApplicationStatus.rejected => Icons.cancel_outlined,
      };

  Color get iconColor => switch (status) {
        ApplicationStatus.pending => const Color(0xFFE07A5F),
        ApplicationStatus.approved => const Color(0xFF4CAF50),
        ApplicationStatus.rejected => const Color(0xFFE53935),
      };
}

class NotificationItem {
  final String id;
  final NotificationType type;
  final String title;
  final String? statusLabel;
  final ApplicationStatus? status;
  final DateTime createdAt;
  final bool isRead;

  const NotificationItem({
    required this.id,
    required this.type,
    required this.title,
    this.statusLabel,
    this.status,           
    required this.createdAt,
    this.isRead = false,
  });
}