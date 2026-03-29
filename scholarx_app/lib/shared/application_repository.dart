import 'package:flutter/foundation.dart';

enum ApplicationStatus { pending, reviewing, approved, rejected }

extension ApplicationStatusX on ApplicationStatus {
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
}

class ApplicationRecord {
  final String id;
  final String scholarshipId;
  final String scholarshipName;
  final int amount;

  final String studentId;
  final String fullName;
  final String phone;
  final String email;
  final String address;

  final String fatherName;
  final String fatherPhone;
  final String fatherJob;
  final String fatherIncome;

  final String motherName;
  final String motherPhone;
  final String motherJob;
  final String motherIncome;

  final String familyStatus;
  final String siblingCount;
  final String applicantOrder;
  final String applicantIncome;
  final String totalFamilyIncome;
  final String familyNote;

  final String guardianName;
  final String guardianRelation;
  final String guardianPhone;
  final String guardianJob;
  final String guardianIncome;

  final List<String> uploadedDocuments;

  final String faculty;
  final String major;
  final String year;
  final double gpa;
  final String reason;

  final DateTime appliedAt;
  final DateTime updatedAt;
  final ApplicationStatus status;

  /// false = ยังมี noti ใหม่ให้นักศึกษาเห็น
  /// true  = นักศึกษาเปิดอ่านแล้ว
  final bool studentNotified;

  const ApplicationRecord({
    required this.id,
    required this.scholarshipId,
    required this.scholarshipName,
    required this.amount,
    required this.studentId,
    required this.fullName,
    required this.phone,
    required this.email,
    required this.address,
    required this.fatherName,
    required this.fatherPhone,
    required this.fatherJob,
    required this.fatherIncome,
    required this.motherName,
    required this.motherPhone,
    required this.motherJob,
    required this.motherIncome,
    required this.familyStatus,
    required this.siblingCount,
    required this.applicantOrder,
    required this.applicantIncome,
    required this.totalFamilyIncome,
    required this.familyNote,
    required this.guardianName,
    required this.guardianRelation,
    required this.guardianPhone,
    required this.guardianJob,
    required this.guardianIncome,
    required this.uploadedDocuments,
    required this.faculty,
    required this.major,
    required this.year,
    required this.gpa,
    required this.reason,
    required this.appliedAt,
    DateTime? updatedAt,
    this.status = ApplicationStatus.reviewing,
    this.studentNotified = false,
  }) : updatedAt = updatedAt ?? appliedAt;

  String get formattedAppliedDate {
    const months = [
      '',
      'ม.ค.',
      'ก.พ.',
      'มี.ค.',
      'เม.ย.',
      'พ.ค.',
      'มิ.ย.',
      'ก.ค.',
      'ส.ค.',
      'ก.ย.',
      'ต.ค.',
      'พ.ย.',
      'ธ.ค.',
    ];
    return '${appliedAt.day} ${months[appliedAt.month]} ${appliedAt.year + 543}';
  }

  ApplicationRecord copyWith({
    String? id,
    String? scholarshipId,
    String? scholarshipName,
    int? amount,
    String? studentId,
    String? fullName,
    String? phone,
    String? email,
    String? address,
    String? fatherName,
    String? fatherPhone,
    String? fatherJob,
    String? fatherIncome,
    String? motherName,
    String? motherPhone,
    String? motherJob,
    String? motherIncome,
    String? familyStatus,
    String? siblingCount,
    String? applicantOrder,
    String? applicantIncome,
    String? totalFamilyIncome,
    String? familyNote,
    String? guardianName,
    String? guardianRelation,
    String? guardianPhone,
    String? guardianJob,
    String? guardianIncome,
    List<String>? uploadedDocuments,
    String? faculty,
    String? major,
    String? year,
    double? gpa,
    String? reason,
    DateTime? appliedAt,
    DateTime? updatedAt,
    ApplicationStatus? status,
    bool? studentNotified,
  }) {
    return ApplicationRecord(
      id: id ?? this.id,
      scholarshipId: scholarshipId ?? this.scholarshipId,
      scholarshipName: scholarshipName ?? this.scholarshipName,
      amount: amount ?? this.amount,
      studentId: studentId ?? this.studentId,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      fatherName: fatherName ?? this.fatherName,
      fatherPhone: fatherPhone ?? this.fatherPhone,
      fatherJob: fatherJob ?? this.fatherJob,
      fatherIncome: fatherIncome ?? this.fatherIncome,
      motherName: motherName ?? this.motherName,
      motherPhone: motherPhone ?? this.motherPhone,
      motherJob: motherJob ?? this.motherJob,
      motherIncome: motherIncome ?? this.motherIncome,
      familyStatus: familyStatus ?? this.familyStatus,
      siblingCount: siblingCount ?? this.siblingCount,
      applicantOrder: applicantOrder ?? this.applicantOrder,
      applicantIncome: applicantIncome ?? this.applicantIncome,
      totalFamilyIncome: totalFamilyIncome ?? this.totalFamilyIncome,
      familyNote: familyNote ?? this.familyNote,
      guardianName: guardianName ?? this.guardianName,
      guardianRelation: guardianRelation ?? this.guardianRelation,
      guardianPhone: guardianPhone ?? this.guardianPhone,
      guardianJob: guardianJob ?? this.guardianJob,
      guardianIncome: guardianIncome ?? this.guardianIncome,
      uploadedDocuments: uploadedDocuments ?? this.uploadedDocuments,
      faculty: faculty ?? this.faculty,
      major: major ?? this.major,
      year: year ?? this.year,
      gpa: gpa ?? this.gpa,
      reason: reason ?? this.reason,
      appliedAt: appliedAt ?? this.appliedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      status: status ?? this.status,
      studentNotified: studentNotified ?? this.studentNotified,
    );
  }
}

class ApplicationRepository extends ChangeNotifier {
  ApplicationRepository._();
  static final ApplicationRepository instance = ApplicationRepository._();

  final List<ApplicationRecord> _items = [];

  List<ApplicationRecord> get all {
    final copy = List<ApplicationRecord>.from(_items);
    copy.sort((a, b) => b.appliedAt.compareTo(a.appliedAt));
    return List.unmodifiable(copy);
  }

  int get totalCount => _items.length;
  int get pendingCount =>
      _items.where((e) => e.status == ApplicationStatus.pending).length;
  int get approvedCount =>
      _items.where((e) => e.status == ApplicationStatus.approved).length;

  /// สร้าง ID ที่ unique โดยใช้ timestamp เพื่อหลีกเลี่ยงการซ้ำ
  String generateId() {
    final now = DateTime.now();
    final seq = (_items.length + 1).toString().padLeft(4, '0');
    return 'AP${now.year}$seq';
  }

  /// เพิ่ม record ใหม่ (ใช้ทั้งใน add และ submit)
  void add(ApplicationRecord record) {
    final exists = _items.any((e) => e.id == record.id);
    if (exists) return;

    _items.insert(
      0,
      record.copyWith(updatedAt: DateTime.now(), studentNotified: false),
    );
    notifyListeners();
  }

  /// alias ของ add — ใช้ใน Step5 เพื่อความชัดเจน
  void submit(ApplicationRecord record) => add(record);

  ApplicationRecord? findById(String id) {
    try {
      return _items.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  List<ApplicationRecord> byStudent(String studentId) {
    final items = _items.where((e) => e.studentId == studentId).toList();
    items.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return items;
  }

  bool updateStatus(String id, ApplicationStatus newStatus) {
    final index = _items.indexWhere((e) => e.id == id);
    if (index == -1) return false;

    final old = _items[index];
    _items[index] = old.copyWith(
      status: newStatus,
      updatedAt: DateTime.now(),
      studentNotified: false, // รีเซ็ตให้ noti เด้งใหม่
    );
    notifyListeners();
    return true;
  }

  bool markNotified(String id) {
    final index = _items.indexWhere((e) => e.id == id);
    if (index == -1) return false;

    final old = _items[index];
    if (old.studentNotified) return true;

    _items[index] = old.copyWith(studentNotified: true);
    notifyListeners();
    return true;
  }

  void clearAll() {
    _items.clear();
    notifyListeners();
  }
}
