import 'package:flutter/material.dart';
import '../widgets/scholarx_logo.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  // ── Design tokens (เดียวกับ SelectRoleScreen) ──
  static const Color primaryOrange = Color(0xFFFF6B1A);
  static const Color lightOrange = Color(0xFFFFB347);
  static const Color darkOrange = Color(0xFFD94A00);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // ── Hero gradient (เดียวกับ SelectRole) ──
          _buildHeroSection(),

          // ── Content ส่วนล่าง ──
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  _buildTitle(),
                  const SizedBox(height: 32),
                  const Text(
                    'เลือกบทบาท',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // ── ปุ่มนักศึกษา ──
                  _buildRoleButton(
                    context,
                    icon: Icons.school_rounded,
                    title: 'นักศึกษา',
                    subtitle: 'ค้นหาทุน / สมัครทุน / ติดตามสถานะ',
                    color: primaryOrange,
                    onTap: () => Navigator.pushNamed(context, '/student/login'),
                  ),
                  // ── ปุ่มผู้ดูแลระบบ ──
                  _buildRoleButton(
                    context,
                    icon: Icons.shield_rounded,
                    title: 'ผู้ดูแลระบบ',
                    subtitle: 'จัดการข้อมูล / อนุมัติคำร้อง / ดูรายงาน',
                    color: const Color(0xFF6B3FA0),
                    onTap: () => Navigator.pushNamed(context, '/admin/splash'),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Hero Section: gradient + decorative circles + logo ──
  Widget _buildHeroSection() {
    return Container(
      height: 280,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [lightOrange, primaryOrange, darkOrange],
        ),
      ),
      child: Stack(
        children: [
          // วงกลม decorative ขวาบน
          Positioned(top: -40, right: -30, child: _buildDecorativeCircle(180)),
          // วงกลม decorative ซ้ายล่าง
          Positioned(bottom: 20, left: -20, child: _buildDecorativeCircle(100)),
          // Logo + app name กลาง
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.school_rounded,
                    color: primaryOrange,
                    size: 36,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'ScholarX',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
                const Text(
                  'FOR EN STUDENT',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDecorativeCircle(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.12),
      ),
    );
  }

  // ── Title + subtitle ──
  Widget _buildTitle() {
    return Column(
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: const TextSpan(
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1A1A1A),
            ),
            children: [
              TextSpan(text: 'Welcome To '),
              TextSpan(
                text: 'ScholarX',
                style: TextStyle(color: primaryOrange),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'การเรียนของคุณควรมีการสนับสนุนที่ใช่\nค้นพบโอกาสใหม่ ๆ ที่ช่วยให้คุณเข้าใกล้อนาคตที่ต้องการ',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13.5,
            color: Colors.grey,
            fontWeight: FontWeight.w600,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  // ── Role Card (style เดียวกับ SelectRole — tap ไปยัง route โดยตรง ไม่มี state) ──
  Widget _buildRoleButton(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFEEEEEE), width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon box
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            // Title + subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            // Arrow icon แทน checkbox (ไม่มี selection state)
            Icon(Icons.arrow_forward_ios_rounded, color: color, size: 16),
          ],
        ),
      ),
    );
  }
}
