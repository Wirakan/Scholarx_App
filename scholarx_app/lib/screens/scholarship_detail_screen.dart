import 'package:flutter/material.dart';

class ScholarshipDetailScreen extends StatelessWidget {
  const ScholarshipDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            const SizedBox(width: 16),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ทุนด้านเทคโนโลยีดิจิทัล',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'ทุนเฉพาะทาง Digital / IT / Engineering',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ],
        ),
        titleSpacing: 12,
        toolbarHeight: 96,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // รายละเอียดทุน
                  _SectionCard(
                    title: 'รายละเอียดทุน',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _DetailText('ระดับการศึกษา: ปริญญาตรี'),
                        const SizedBox(height: 8),
                        _DetailText('สาขาที่เกี่ยวข้อง:'),
                        _BulletItem('เทคโนโลยีสารสนเทศ'),
                        _BulletItem('วิศวกรรมคอมพิวเตอร์'),
                        _BulletItem('วิทยาการคอมพิวเตอร์'),
                        _BulletItem('ดิจิทัลมีเดีย / AI / Data'),
                        const SizedBox(height: 8),
                        _DetailText('สิทธิประโยชน์:'),
                        _BulletItem(
                          'ทุนการศึกษาสูงสุด 10,000 บาท / ปีการศึกษา',
                        ),
                        _BulletItem('สนับสนุนค่าเรียนและอุปกรณ์ด้านเทคโนโลยี'),
                        _BulletItem('เข้าร่วมกิจกรรมพัฒนาทักษะดิจิทัล'),
                        const SizedBox(height: 8),
                        _DetailText('ระยะเวลารับสมัคร: 1 ก.พ. – 31 มี.ค. 2569'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // คุณสมบัติ
                  _SectionCard(
                    title: 'คุณสมบัติ',
                    child: Column(
                      children: [
                        _CheckItem('เป็นนักศึกษาระดับปริญญาตรี'),
                        _CheckItem(
                          'กำลังศึกษาในสาขาที่เกี่ยวข้องกับเทคโนโลยีดิจิทัล',
                        ),
                        _CheckItem('เกรดเฉลี่ยสะสม ไม่ต่ำกว่า 2.75'),
                        _CheckItem('มีความสนใจหรือผลงานด้านเทคโนโลยีดิจิทัล'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // เอกสารที่ต้องใช้
                  _SectionCard(
                    title: 'เอกสารที่ต้องใช้',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _BulletItem('สำเนาบัตรประจำตัวประชาชน'),
                        _BulletItem('รูปถ่ายหน้าตรง (พื้นหลังสุภาพ)'),
                        _BulletItem('ใบแสดงผลการเรียน (Transcript)'),
                        _BulletItem('สำเนาสมุดบัญชีธนาคาร'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          // ปุ่มสมัคร
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF5722),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                onPressed: () {},
                child: const Text(
                  'สมัครทุนนี้',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          // Bottom Navigation Bar
          _BottomNavBar(),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _DetailText extends StatelessWidget {
  final String text;
  const _DetailText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 14, color: Colors.black87),
    );
  }
}

class _BulletItem extends StatelessWidget {
  final String text;
  const _BulletItem(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 14)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckItem extends StatelessWidget {
  final String text;
  const _CheckItem(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: Color(0xFFFF5722), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(icon: Icons.home_outlined, label: 'Home'),
          // consistent scholar icon across screens
          _NavItem(
            icon: Icons.school_outlined,
            label: 'Scholar',
            isActive: true,
          ),
          _NavItem(icon: Icons.description_outlined, label: 'Tracking'),
          _NavItem(icon: Icons.notifications_outlined, label: 'Alert'),
          _NavItem(icon: Icons.person_outline, label: 'Profile'),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;

  const _NavItem({
    required this.icon,
    required this.label,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? const Color(0xFFFF5722) : Colors.grey;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: color, fontSize: 11)),
      ],
    );
  }
}
