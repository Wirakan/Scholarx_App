import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  // ── Design tokens ──
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

  // ── Hero gradient based on selected role ──
  LinearGradient get _heroGradient {
    if (_selectedRole == 'admin') {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [lightPurple, primaryPurple, darkPurple],
      );
    }
    return const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [lightOrange, primaryOrange, darkOrange],
    );
  }

  Color get _heroIconColor {
    if (_selectedRole == 'admin') return primaryPurple;
    return primaryOrange;
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 24),
                  _buildTitle(),
                  const SizedBox(height: 28),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'เลือกบทบาท',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey,
                        letterSpacing: 1.0,
                      ),
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
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          _buildContinueButton(),
        ],
      ),
    );
  }

  // ── Hero Section (animated gradient) ──
  Widget _buildHeroSection() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      height: 280,
      width: double.infinity,
      decoration: BoxDecoration(gradient: _heroGradient),
      child: Stack(
        children: [
          Positioned(top: -40, right: -30, child: _buildDecorativeCircle(180)),
          Positioned(bottom: 20, left: -20, child: _buildDecorativeCircle(100)),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
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
                  child: Icon(
                    _selectedRole == 'admin'
                        ? Icons.shield_rounded
                        : Icons.school_rounded,
                    color: _heroIconColor,
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
              TextSpan(text: 'ฉันคือ'),
              TextSpan(
                text: '...',
                style: TextStyle(color: primaryOrange),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'เลือกบทบาทของคุณเพื่อใช้งานระบบ',
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

  // ── Role Card with gradient support ──
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

  // ── Continue Button ──
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
            backgroundColor: enabled ? Colors.black : Colors.grey.shade300,
            foregroundColor: Colors.white,
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
