import 'package:flutter/material.dart';
import '../core/colors.dart';
import '../screens/dashboard_screen.dart';
import '../screens/application_list_screen.dart';

class AdminBottomNav extends StatelessWidget {
  final int currentIndex;

  const AdminBottomNav({super.key, required this.currentIndex});

  void _onTap(BuildContext context, int index) {
    if (index == currentIndex) return;
    if (index == 2) return; // เพิ่มทุน — TODO

    Widget screen;
    switch (index) {
      case 0:
        screen = const DashboardScreen();
        break;
      case 1:
        screen = const ApplicationListScreen();
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => screen,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 16,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 72,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Nav items row
              Positioned.fill(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _NavItem(
                      icon: Icons.home_rounded,
                      label: 'หน้าแรก',
                      active: currentIndex == 0,
                      onTap: () => _onTap(context, 0),
                    ),
                    _NavItem(
                      icon: Icons.description_rounded,
                      label: 'ใบสมัคร',
                      active: currentIndex == 1,
                      onTap: () => _onTap(context, 1),
                    ),
                    // ช่องว่างกลางสำหรับปุ่ม +
                    SizedBox(
                      width: 72,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: const [
                          SizedBox(height: 44), // เว้นที่ให้ปุ่ม
                          Text(
                            'เพิ่มทุน',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF9CA3AF),
                            ),
                          ),
                          SizedBox(height: 4),
                        ],
                      ),
                    ),
                    _NavItem(
                      icon: Icons.workspace_premium_rounded,
                      label: 'ทุน',
                      active: currentIndex == 3,
                      onTap: () => _onTap(context, 3),
                    ),
                    _NavItem(
                      icon: Icons.notifications_rounded,
                      label: 'แจ้งเตือน',
                      active: currentIndex == 4,
                      onTap: () => _onTap(context, 4),
                    ),
                  ],
                ),
              ),

              // ปุ่ม + กลาง โผล่เหนือ nav bar + label อยู่ข้างล่างใน stack
              Positioned(
                top: -30,
                left: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () => _onTap(context, 2),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 68,
                        height: 68,
                        decoration: BoxDecoration(
                          color: SXColor.primary,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: SXColor.primary.withOpacity(0.45),
                              blurRadius: 14,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.add, color: Colors.white, size: 34),
                      ),

                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Nav Item ─────────────────────────────────────────────────────────────────
class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 72,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: active ? SXColor.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 22,
                color: active ? Colors.white : const Color(0xFF9CA3AF),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                color: active ? SXColor.primary : const Color(0xFF9CA3AF),
              ),
            ),
          ],
        ),
      ),
    );
  }
}