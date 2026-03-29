// lib/core/store/application_store.dart
//
// Shared store กลางระหว่าง admin และ student
// ใช้ ChangeNotifier เพื่อ rebuild widget อัตโนมัติเมื่อ status เปลี่ยน
//
// วิธีใช้:
//   1. ครอบ MaterialApp ด้วย ChangeNotifierProvider<ApplicationStore>
//   2. อ่านข้อมูล : context.watch<ApplicationStore>().applications
//   3. อัพเดท    : context.read<ApplicationStore>().updateStatus(id, newStatus)
//   4. Logout    : context.read<ApplicationStore>().showLogoutMenu(context)

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '/screens/splash_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  STATUS ENUM  (ใช้ร่วมกันทั้ง admin และ student)
// ─────────────────────────────────────────────────────────────────────────────
enum ApplicationStatus {
  pending, // รอดำเนินการ
  reviewing, // กำลังพิจารณา
  approved, // อนุมัติ
  rejected, // ปฏิเสธ
}

extension ApplicationStatusLabel on ApplicationStatus {
  /// ป้ายภาษาไทยสำหรับแสดงผล
  String get label {
    switch (this) {
      case ApplicationStatus.pending:
        return 'รอดำเนินการ';
      case ApplicationStatus.reviewing:
        return 'กำลังพิจารณา';
      case ApplicationStatus.approved:
        return 'อนุมัติ';
      case ApplicationStatus.rejected:
        return 'ปฏิเสธ';
    }
  }

  /// แปลง string (จากฐานข้อมูล/mock) กลับเป็น enum
  static ApplicationStatus fromLabel(String label) {
    switch (label) {
      case 'รอดำเนินการ':
        return ApplicationStatus.pending;
      case 'กำลังพิจารณา':
        return ApplicationStatus.reviewing;
      case 'อนุมัติ':
        return ApplicationStatus.approved;
      case 'ปฏิเสธ':
        return ApplicationStatus.rejected;
      default:
        return ApplicationStatus.pending;
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  APPLICATION MODEL  (ใช้ร่วมกัน)
// ─────────────────────────────────────────────────────────────────────────────
class ApplicationModel {
  final String id; // รหัสใบสมัคร เช่น 'AP011001'
  final String studentId; // รหัสนักศึกษา เช่น '663040127-7'
  final String studentName;
  final String email;
  final String faculty;
  final String major;
  final String year;
  final double gpa;
  final String address;
  final String scholarshipId;
  final String scholarshipTitle;
  final double amount;
  final String appliedDate;
  final String reason;
  ApplicationStatus status;

  ApplicationModel({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.email,
    required this.faculty,
    required this.major,
    required this.year,
    required this.gpa,
    required this.address,
    required this.scholarshipId,
    required this.scholarshipTitle,
    required this.amount,
    required this.appliedDate,
    required this.reason,
    this.status = ApplicationStatus.pending,
  });

  /// คัดลอกพร้อมเปลี่ยน status
  ApplicationModel copyWithStatus(ApplicationStatus newStatus) {
    return ApplicationModel(
      id: id,
      studentId: studentId,
      studentName: studentName,
      email: email,
      faculty: faculty,
      major: major,
      year: year,
      gpa: gpa,
      address: address,
      scholarshipId: scholarshipId,
      scholarshipTitle: scholarshipTitle,
      amount: amount,
      appliedDate: appliedDate,
      reason: reason,
      status: newStatus,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  APPLICATION STORE
// ─────────────────────────────────────────────────────────────────────────────
class ApplicationStore extends ChangeNotifier {
  // ── Mock data ──────────────────────────────────────────────────────────────
  final List<ApplicationModel> _applications = [
    ApplicationModel(
      id: 'AP011001',
      studentId: 'usr_001',
      studentName: 'ธนวัตน์ ประเสริฐ',
      email: 'thanawat@kkumail.com',
      faculty: 'วิศวกรรมศาสตร์',
      major: 'วิศวกรรมคอมพิวเตอร์',
      year: 'ปี 3',
      gpa: 3.85,
      address: '123 ถ.มิตรภาพ ต.ในเมือง อ.เมือง จ.ขอนแก่น 40000',
      scholarshipId: 'sch_002',
      scholarshipTitle: 'ทุนด้านเทคโนโลยีดิจิทัล',
      amount: 10000,
      appliedDate: '12 ม.ค. 2569',
      reason:
          'ต้องการพัฒนาทักษะด้านเทคโนโลยีและนวัตกรรม เพื่อสร้างประโยชน์แก่สังคม',
      status: ApplicationStatus.reviewing,
    ),
    ApplicationModel(
      id: 'AP011003',
      studentId: 'usr_001',
      studentName: 'ธนวัตน์ ประเสริฐ',
      email: 'thanawat@kkumail.com',
      faculty: 'วิศวกรรมศาสตร์',
      major: 'วิศวกรรมคอมพิวเตอร์',
      year: 'ปี 3',
      gpa: 3.85,
      address: '123 ถ.มิตรภาพ ต.ในเมือง อ.เมือง จ.ขอนแก่น 40000',
      scholarshipId: 'sch_005',
      scholarshipTitle: 'ทุนพัฒนาผู้นำเยาวชนรุ่นใหม่',
      amount: 30000,
      appliedDate: '23 มิ.ย. 2568',
      reason: 'ต้องการพัฒนาภาวะผู้นำและทักษะการทำงานเป็นทีม',
      status: ApplicationStatus.reviewing,
    ),
    ApplicationModel(
      id: 'AP011004',
      studentId: 'usr_001',
      studentName: 'ธนวัตน์ ประเสริฐ',
      email: 'thanawat@kkumail.com',
      faculty: 'วิศวกรรมศาสตร์',
      major: 'วิศวกรรมคอมพิวเตอร์',
      year: 'ปี 3',
      gpa: 3.85,
      address: '123 ถ.มิตรภาพ ต.ในเมือง อ.เมือง จ.ขอนแก่น 40000',
      scholarshipId: 'sch_006',
      scholarshipTitle: 'ทุนส่งเสริมโอกาสทางการศึกษา',
      amount: 40000,
      appliedDate: '10 พ.ย. 2568',
      reason: 'ต้องการโอกาสทางการศึกษาเพื่อพัฒนาตนเองและสังคม',
      status: ApplicationStatus.approved,
    ),
    ApplicationModel(
      id: 'AP011005',
      studentId: 'usr_002',
      studentName: 'สมหญิง ใจดี',
      email: 'somying@kkumail.com',
      faculty: 'วิทยาศาสตร์',
      major: 'คณิตศาสตร์',
      year: 'ปี 2',
      gpa: 3.60,
      address: '456 ถ.หน้าเมือง ต.พระลับ อ.เมือง จ.ขอนแก่น 40000',
      scholarshipId: 'sch_001',
      scholarshipTitle: 'ทุนการศึกษาเพื่อความเป็นเลิศทางวิชาการ',
      amount: 20000,
      appliedDate: '15 ม.ค. 2569',
      reason: 'มีผลการเรียนดีและต้องการสนับสนุนค่าเล่าเรียน',
      status: ApplicationStatus.pending,
    ),
    ApplicationModel(
      id: 'AP011006',
      studentId: 'usr_003',
      studentName: 'วิชัย รักเรียน',
      email: 'wichai@kkumail.com',
      faculty: 'บริหารธุรกิจ',
      major: 'การตลาด',
      year: 'ปี 4',
      gpa: 3.20,
      address: '789 ถ.ชาตะผดุง ต.ในเมือง อ.เมือง จ.ขอนแก่น 40000',
      scholarshipId: 'sch_003',
      scholarshipTitle: 'ทุนสนับสนุนนวัตกรรมและเทคโนโลยี',
      amount: 60000,
      appliedDate: '20 ม.ค. 2569',
      reason: 'ต้องการทุนวิจัยเพื่อพัฒนานวัตกรรมด้านการตลาดดิจิทัล',
      status: ApplicationStatus.pending,
    ),
  ];

  // ── Getters ────────────────────────────────────────────────────────────────

  /// ใบสมัครทั้งหมด (admin ใช้)
  List<ApplicationModel> get applications => List.unmodifiable(_applications);

  /// ใบสมัครของนักศึกษาคนใดคนหนึ่ง (student tracking ใช้)
  List<ApplicationModel> applicationsForStudent(String studentId) {
    return _applications.where((a) => a.studentId == studentId).toList();
  }

  /// หาใบสมัครจาก id
  ApplicationModel? findById(String id) {
    try {
      return _applications.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }

  // ── Mutations ──────────────────────────────────────────────────────────────

  /// อัพเดทสถานะ → แจ้ง listener ทั้งหมด (admin detail + student tracking)
  void updateStatus(String applicationId, ApplicationStatus newStatus) {
    final index = _applications.indexWhere((a) => a.id == applicationId);
    if (index == -1) return;
    _applications[index] = _applications[index].copyWithStatus(newStatus);
    notifyListeners();
  }

  /// เพิ่มใบสมัครใหม่ (เมื่อ student กดสมัครทุน)
  void addApplication(ApplicationModel application) {
    _applications.add(application);
    notifyListeners();
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  /// นับจำนวนตามสถานะ (dashboard ใช้)
  int countByStatus(ApplicationStatus status) {
    return _applications.where((a) => a.status == status).length;
  }

  int get totalCount => _applications.length;

  // ── Logout ─────────────────────────────────────────────────────────────────

  /// แสดง Bottom Sheet เมนู logout เหมือน DashboardScreen
  /// ใช้งาน: context.read<ApplicationStore>().showLogoutMenu(context)
  void showLogoutMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(
                Icons.logout_rounded,
                color: Colors.redAccent,
              ),
              title: const Text(
                'ออกจากระบบ',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              onTap: () {
                Navigator.pop(context); // ปิด bottom sheet ก่อน
                logout(context);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  /// นำทางกลับ SplashScreen พร้อมล้าง navigation stack ทั้งหมด
  /// เรียกตรงก็ได้ถ้าไม่ต้องการ bottom sheet
  void logout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const SplashScreen(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 600),
      ),
      (route) => false, // ล้าง stack ทั้งหมด
    );
  }
}
