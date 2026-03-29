import 'package:flutter/material.dart';
import '../widgets/scholarx_logo.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  static const Color primaryOrange = Color(0xFFFF6B1A);
  static const Color lightOrange = Color(0xFFFFB347);
  static const Color darkOrange = Color(0xFFD94A00);

  static const Color primaryPurple = Color(0xFF7B3FE4);
  static const Color lightPurple = Color(0xFF9B6FFF);
  static const Color darkPurple = Color(0xFF4A1FA0);

  String? _selectedRole;

  void _onContinue() {
    if (_selectedRole == null) return;
    if (_selectedRole == 'student') {
      Navigator.pushNamed(context, '/student/login');
    } else {
      Navigator.pushNamed(context, '/admin/splash');
    }
  }

LinearGradient get _heroGradient {
    if (_selectedRole == 'admin') {
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF5A189A), // ม่วงเข้มมาก (top shadow)
          Color(0xFF7B2CBF), // ม่วงเข้ม
          Color(0xFF9D4EDD), // ⭐ primary
          Color(0xFFBA8CFF), // ม่วงกลาง
          Color(0xFFD8B4FE), // ม่วงอ่อน
          Colors.white,
        ],
        stops: [0.0, 0.30, 0.52, 0.68, 0.82, 0.93],
      );
    }
return const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFF9E2A00), // ส้มเข้มมาก (top shadow)
        Color(0xFFD9480F), // ส้มเข้ม
        Color(0xFFFF6B1A), // ⭐ primary
        Color(0xFFFF9E66), // ส้มกลาง
        Color(0xFFFFD3B3), // ส้มอ่อน
        Colors.white,
      ],
      stops: [0.0, 0.28, 0.48, 0.65, 0.80, 0.93],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeroSection(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 28),
                  const Text(
                    'เลือกบทบาท',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _buildRoleCard(
                    roleKey: 'student',
                    icon: Icons.school_rounded,
                    title: 'นักศึกษา',
                    subtitle: 'ค้นหาทุน / สมัครทุน / ติดตามสถานะ',
                    solidColor: primaryOrange,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [lightOrange, primaryOrange, darkOrange],
                    ),
                  ),
                  _buildRoleCard(
                    roleKey: 'admin',
                    icon: Icons.shield_rounded,
                    title: 'ผู้ดูแลระบบ',
                    subtitle: 'จัดการข้อมูล / อนุมัติคำร้อง / ดูรายงาน',
                    solidColor: primaryPurple,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [lightPurple, primaryPurple, darkPurple],
                    ),
                  ),
                  const SizedBox(height: 28),
                ],
              ),
            ),
          ),
          _buildContinueButton(),
        ],
      ),
    );
  }

  // ── Hero: โลโก้ + "ฉันคือ...." + subtitle ทั้งหมดอยู่กึ่งกลาง ────────
  Widget _buildHeroSection() {
    final screenHeight = MediaQuery.of(context).size.height;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      width: double.infinity,
      height: screenHeight * 0.42,
      decoration: BoxDecoration(gradient: _heroGradient),
      child: Stack(
        children: [
          Positioned(top: -40, right: -30, child: _buildDecorativeCircle(180)),
          Positioned(
            bottom: -10,
            left: -20,
            child: _buildDecorativeCircle(100),
          ),

          // ── Logo อยู่บนสุด ──
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 24),
                child: ScholarXLogo(size: 72, withLabel: false),
              ),
            ),
          ),

          // ── "ฉันคือ...." + subtitle อยู่ล่างติดขอบ hero ──
          Positioned(
            left: 28,
            right: 28,
            bottom: 28,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                      color: Color(0xFF222222),
                    ),
                    children: [
                      const TextSpan(text: 'ฉันคือ'),
TextSpan(
                        text: '....',
                        style: TextStyle(
                          color: _selectedRole == 'admin'
                              ? const Color.fromARGB(255, 144, 112, 201)
                              : _selectedRole == 'student'
                              ? const Color.fromARGB(255, 234, 142, 96)
                              : Colors.black.withOpacity(0.4),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'เลือกบทบาทของคุณเพื่อใช้งานระบบ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 120, 120, 120), // ดำอ่อนสวย,
                    fontWeight: FontWeight.w700,
                    height: 1.4,
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
        color: Colors.white.withOpacity(0.10),
      ),
    );
  }

  Widget _buildRoleCard({
    required String roleKey,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color solidColor,
    required LinearGradient gradient,
  }) {
    final bool isSelected = _selectedRole == roleKey;

    return GestureDetector(
      onTap: () => setState(() => _selectedRole = roleKey),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        decoration: BoxDecoration(
          gradient: isSelected ? gradient : null,
          color: isSelected ? null : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.transparent : const Color(0xFFEEEEEE),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? solidColor.withOpacity(0.35)
                  : Colors.black.withOpacity(0.04),
              blurRadius: isSelected ? 20 : 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withOpacity(0.25)
                    : const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : solidColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected
                          ? Colors.white.withOpacity(0.85)
                          : Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? Colors.white : Colors.transparent,
                border: Border.all(
                  color: isSelected ? Colors.white : Colors.grey.shade300,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Icon(Icons.check_rounded, color: solidColor, size: 16)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    final bool enabled = _selectedRole != null;
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton(
          onPressed: enabled ? _onContinue : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black, // 👈 ดำตลอด
            disabledBackgroundColor: Colors.black, // 👈 ตอน disabled ก็ยังดำ
            foregroundColor: Colors.white,
            disabledForegroundColor: Colors.white70,
            elevation: enabled ? 4 : 0,
            shadowColor: Colors.black.withOpacity(0.4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: const Text(
            'ดำเนินการต่อ',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}
