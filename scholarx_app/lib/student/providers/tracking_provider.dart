import 'package:flutter/material.dart';
import '/student/screens/tracking/tracking_screen.dart';

class TrackingProvider extends ChangeNotifier {
  final List<TrackingItem> _items = [
    const TrackingItem(
      id: 'AP011001',
      title: 'ทุนด้านเทคโนโลยีดิจิทัล',
      appliedDate: '12 ม.ค. 2569',
      updatedDate: '20 ม.ค. 2569',
      amount: 10000,
      status: TrackingStatus.reviewing,
    ),
    const TrackingItem(
      id: 'AP011003',
      title: 'ทุนพัฒนาผู้นำเยาวชนรุ่นใหม่',
      appliedDate: '23 มิ.ย. 2568',
      updatedDate: '30 ส.ค. 2568',
      amount: 30000,
      status: TrackingStatus.reviewing,
    ),
    const TrackingItem(
      id: 'AP011004',
      title: 'ทุนส่งเสริมโอกาสทางการศึกษา',
      appliedDate: '10 พ.ย. 2568',
      updatedDate: '09 มิ.ย. 2568',
      amount: 40000,
      status: TrackingStatus.approved,
    ),
  ];

  List<TrackingItem> get items => List.unmodifiable(_items);

  // เฉพาะรายการที่ยังรอพิจารณา
  List<TrackingItem> get pendingItems =>
      _items.where((e) => e.status == TrackingStatus.reviewing).toList();

  /// เรียกจาก NotificationProvider เมื่อมีการเปลี่ยนสถานะ
  void updateStatusByTitle({
    required String scholarshipName,
    required TrackingStatus newStatus,
  }) {
    bool changed = false;
    for (int i = 0; i < _items.length; i++) {
      if (_items[i].title == scholarshipName) {
        _items[i] = TrackingItem(
          id: _items[i].id,
          title: _items[i].title,
          appliedDate: _items[i].appliedDate,
          updatedDate: _nowDateThai(),
          amount: _items[i].amount,
          status: newStatus,
        );
        changed = true;
      }
    }
    if (changed) notifyListeners();
  }

  String _nowDateThai() {
    final now = DateTime.now();
    const thaiMonths = [
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
    return '${now.day} ${thaiMonths[now.month]} ${now.year + 543}';
  }
}