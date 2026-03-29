import 'package:flutter/material.dart';

class RoleOption {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;

  const RoleOption({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}

// ----- SelectRoleScreen -----
class SelectRoleScreen extends StatefulWidget {
  const SelectRoleScreen({super.key});

  @override
  State<SelectRoleScreen> createState() => _SelectRoleScreenState();
}

class _SelectRoleScreenState extends State<SelectRoleScreen> {
  // ตัวแปรเก็บ role ที่เลือก (null = ยังไม่เลือก)
  String? _selectedRole;

  // main color
  static const Color primaryOrange = Color(0xFFFF6B1A);
  static const Color lightOrange   = Color(0xFFFFB347);

  // roles
  final List<RoleOption> _roles = const [
    RoleOption(
      id: 'student',
      title: 'นักศึกษา',
      subtitle: 'ค้นหาทุน / สมัครทุน / ติดตามสถานะ',
      icon: Icons.school_rounded,
    ),
    RoleOption(
      id: 'admin',
      title: 'ผู้ดูแลระบบ',
      subtitle: 'จัดการข้อมูล / อนุมัติคำร้อง / ดูรายงาน',
      icon: Icons.shield_rounded,
    ),
  ];

  Color _getSelectedColor(String roleId) {
    if (roleId == 'admin') return const Color(0xFF6B3FA0); // admin:purple
    return primaryOrange; // student:orange
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          //Hero gradient
          _buildHeroSection(),

          // title + cards + btn
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  _buildTitle(),
                  const SizedBox(height: 24),
                  const Text(
                    'เลือกบทบาท',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey,
                      letterSpacing: 1.0,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // วน loop สร้าง card ทุก role //AI
                  ..._roles.map((role) => _buildRoleCard(role)),

                  const SizedBox(height: 28),
                  _buildContinueButton(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---- Widget: Hero Section บนสุด ----
  Widget _buildHeroSection() {
    return Container(
      height: 280,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            lightOrange,   // ส้มอ่อน
            primaryOrange, // ส้มกลาง
            Color(0xFFD94A00), // ส้มเข้ม
          ],
        ),
      ),
      child: Stack(
        children: [
          // วงกลม Decorative ซ้ายบน
          Positioned(
            top: -40,
            right: -30,
            child: _buildDecorativeCircle(180),
          ),
          // วงกลม Decorative ขวาล่าง
          Positioned(
            bottom: 20,
            left: -20,
            child: _buildDecorativeCircle(100),
          ),

          // Logo กลาง
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40), // เว้น status bar
                // กล่อง logo
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
                // ชื่อแอป
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

  // Decorative
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
    // หา label ของ role ที่เลือก
    final selectedLabel = _roles
        .where((r) => r.id == _selectedRole)
        .map((r) => r.title)
        .firstOrNull;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1A1A1A),
            ),
            children: [
              const TextSpan(text: 'ฉันคือ'),
              TextSpan(
                text: selectedLabel != null ? selectedLabel : '....',
                style: TextStyle(
                  color: _selectedRole == 'admin'
                      ? const Color(0xFF6B3FA0)
                      : primaryOrange,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'เลือกบทบาทของคุณเพื่อเข้าใช้งานระบบ',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // Widget: Role Card 
  Widget _buildRoleCard(RoleOption role) {
    // card นี้ถูกเลือกอยู่มั้ย
    final bool isSelected = _selectedRole == role.id;
    final Color selectedColor = _getSelectedColor(role.id);

    return GestureDetector(
      // เมื่อกด card → เปลี่ยน _selectedRole
      onTap: () => setState(() => _selectedRole = role.id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        decoration: BoxDecoration(
          // ถ้าเลือก → พื้นหลังสี, ถ้าไม่เลือก → ขาว
          color: isSelected ? selectedColor : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? selectedColor : const Color(0xFFEEEEEE),
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: selectedColor.withOpacity(0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  )
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withOpacity(0.2)
                    : const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                role.icon,
                color: isSelected ? Colors.white : selectedColor,
                size: 24,
              ),
            ),

            const SizedBox(width: 16),

            // title + subtitle 
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    role.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: isSelected ? Colors.white : const Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    role.subtitle,
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

            // Check box
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? Colors.white : Colors.transparent,
                border: Border.all(
                  color: isSelected ? Colors.white : const Color(0xFFDDDDDD),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Icon(
                      Icons.check,
                      size: 14,
                      color: selectedColor,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  // "ดำเนินการต่อ" btn
  Widget _buildContinueButton() {
    final bool canContinue = _selectedRole != null;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: canContinue ? _onContinue : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1A1A1A),
          disabledBackgroundColor: const Color(0xFFCCCCCC),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          elevation: canContinue ? 4 : 0,
        ),
        child: const Text(
          'ดำเนินการต่อ',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}