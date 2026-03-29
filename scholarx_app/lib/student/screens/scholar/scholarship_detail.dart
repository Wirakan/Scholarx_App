import 'package:flutter/material.dart';
import '/coreApp/themeApp/app_colors.dart';
import '/student/models/scholarship_model.dart';
import '/student/screens/form/scholarship_form_step1.dart';

class ScholarshipDetailScreen extends StatelessWidget {
  final ScholarshipModel scholarship;

  const ScholarshipDetailScreen({super.key, required this.scholarship});

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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    scholarship.title,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    scholarship.categoryLabel,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
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
                        _DetailText(scholarship.description),
                        const SizedBox(height: 12),
                        const _DetailText('ระดับการศึกษา: ปริญญาตรี'),
                        const SizedBox(height: 8),
                        const _DetailText('สาขาที่เกี่ยวข้อง:'),
                        const _BulletItem('เทคโนโลยีสารสนเทศ'),
                        const _BulletItem('วิศวกรรมคอมพิวเตอร์'),
                        const _BulletItem('วิทยาการคอมพิวเตอร์'),
                        const _BulletItem('ดิจิทัลมีเดีย / AI / Data'),
                        const SizedBox(height: 8),
                        const _DetailText('สิทธิประโยชน์:'),
                        const _BulletItem(
                          'ทุนการศึกษาสูงสุด 10,000 บาท / ปีการศึกษา',
                        ),
                        const _BulletItem(
                          'สนับสนุนค่าเรียนและอุปกรณ์ด้านเทคโนโลยี',
                        ),
                        const _BulletItem('เข้าร่วมกิจกรรมพัฒนาทักษะดิจิทัล'),
                        const SizedBox(height: 8),
                        _DetailText('เปิดรับถึง: ${scholarship.deadline}'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // คุณสมบัติ
                  const _SectionCard(
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
                  const _SectionCard(
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
                  const SizedBox(height: 12),

                  // อัปเดตล่าสุด
                  _SectionCard(
                    title: 'อัปเดตล่าสุด',
                    child: Text(
                      scholarship.deadline,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
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
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ScholarshipFormStep1(),
                    ),
                  );
                },
                child: const Text(
                  'สมัครทุนนี้',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  SECTION CARD
// ─────────────────────────────────────────────
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
        borderRadius: BorderRadius.circular(8),
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

// ─────────────────────────────────────────────
//  HELPERS
// ─────────────────────────────────────────────
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
          Icon(Icons.check_circle, color: AppColors.primary, size: 20),
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
