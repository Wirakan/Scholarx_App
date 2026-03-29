import 'package:flutter/material.dart';
import '/coreApp/themeApp/app_colors.dart';
import '/coreApp/themeApp/app_text_style.dart';
import '/coreApp/widgets/scholarship_form_widget.dart';
import '/features/student/screens/tracking/tracking_screen.dart';

class ScholarshipFormSuccess extends StatelessWidget {
  const ScholarshipFormSuccess({super.key});

  static const _newItem = TrackingItem(
    id: 'AP011001',
    title: 'ทุนด้านเทคโนโลยีดิจิทัล',
    appliedDate: '12 ม.ค. 2569',
    updatedDate: '20 ม.ค. 2569',
    amount: 10000,
    status: TrackingStatus.reviewing,
  );

  // Pop ทุก route จนถึง root แล้วส่ง result กลับให้ StudentHomeScreen
  // เพื่อ switch ไป tab index 2 (Tracking)
  void _goHome(BuildContext context, {bool openTracking = false}) {
    Navigator.of(context).popUntil((route) => route.isFirst);
    if (openTracking) {
      // ส่ง result กลับให้ StudentHomeScreen ผ่าน Navigator result
      Navigator.of(context).pop(2); // 2 = tracking tab index
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const FormHeader(
            title: 'สมัครขอทุนการศึกษา',
            subtitle: 'กรุณากรอกข้อมูลการสมัคร',
          ),
          const StepIndicatorBar(currentStep: 6),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: AppColors.primaryBg,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_circle_outline,
                        color: AppColors.primary,
                        size: 42,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'การสมัครสำเร็จ!',
                      style: AppTextStyle.heading2.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'ใบสมัครของคุณเข้าสู่ระบบเรียบร้อยแล้ว',
                      style: AppTextStyle.body.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),

                    // Application details card
                  Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.center, // ← จัดกลาง
                            children: [
                              Text(
                                'หมายเลขการสมัคร:',
                                style: AppTextStyle.caption.copyWith(fontSize: 14),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'AP011001',
                                style: AppTextStyle.heading2.copyWith(
                                  fontSize: 19,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const Divider(
                            height: 24,
                            color: AppColors.border,
                          ), // ← สีอ่อน
                          _InfoRow('ทุนที่สมัคร', 'ทุนด้านเทคโนโลยีดิจิทัล'),
                          const SizedBox(height: 10),
                          _InfoRow('จำนวนเงิน', '10,000'),
                          const SizedBox(height: 10),
                          _InfoRow('วันที่สมัคร', '12 ม.ค. 2569'),
                          const SizedBox(height: 10),
                          _InfoRow('เวลาที่สมัคร', '14:00'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Notice banner
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBg,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.notifications_outlined,
                            color: AppColors.primary,
                            size: 18,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'โปรดติดตามการแจ้งเตือน ระบบจะใช้เวลาโดยประมาณ 7-14 วัน',
                              style: AppTextStyle.caption.copyWith(
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    // ── ติดตามทุน → TrackingScreen (push on top) ──
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const TrackingScreen(highlightItem: _newItem),
                            ),
                            (route) => route.isFirst,
                          );
                        },
                        icon: const Icon(Icons.receipt_long_outlined, size: 18),
                        label: const Text('ติดตามทุน'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                          textStyle: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // ── กลับหน้าหลัก → StudentHomeScreen tab 2 (Tracking) ──
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // Pop ทุก route กลับถึง StudentHomeScreen
                          // แล้วส่ง tabIndex=2 เป็น result เพื่อ switch tab
                          Navigator.of(context).popUntil((r) => r.isFirst);
                        },
                        icon: const Icon(Icons.home_outlined, size: 18),
                        label: const Text('กลับหน้าหลัก'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(color: AppColors.primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
          const AppBottomNavBar(activeIndex: 1),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyle.body.copyWith(color: AppColors.textSecondary),
        ),
        Text(value, style: AppTextStyle.bodyMedium),
      ],
    );
  }
}
