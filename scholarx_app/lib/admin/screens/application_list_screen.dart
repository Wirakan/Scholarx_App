import 'package:flutter/material.dart';
import '../core/colors.dart';
import '../core/models.dart';
import '../widgets/sx_app_bar.dart';
import '../widgets/applicant_card.dart';
import 'application_detail_screen.dart';
import '../widgets/admin_bottom_nav.dart';
import '/screens/splash_screen.dart';

// ─── Filter Sheet ─────────────────────────────────────────────────────────────
void showFilterSheet(
  BuildContext context, {
  required String selectedStatus,
  required String selectedCategory,
  required Function(String status, String category) onApply,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => _FilterSheet(
      selectedStatus: selectedStatus,
      selectedCategory: selectedCategory,
      onApply: onApply,
    ),
  );
}

class _FilterSheet extends StatefulWidget {
  final String selectedStatus;
  final String selectedCategory;
  final Function(String status, String category) onApply;

  const _FilterSheet({
    required this.selectedStatus,
    required this.selectedCategory,
    required this.onApply,
  });

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late String _status;
  late String _category;

  final statusOptions = [
    'ทั้งหมด',
    'รอดำเนินการ',
    'กำลังพิจารณา',
    'อนุมัติ',
    'ปฏิเสธ',
  ];
  final categoryOptions = [
    'ทั้งหมด',
    'ทุนเรียนดี',
    'ทุนวิจัย',
    'ทุนกิจกรรม',
    'ทุนผู้ด้อย',
    'ทุนขาดแคลน',
  ];

  @override
  void initState() {
    super.initState();
    _status = widget.selectedStatus;
    _category = widget.selectedCategory;
  }

  Widget _chip(String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8, bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: active ? SXColor.primary : Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: active ? SXColor.primary : SXColor.border),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: active ? Colors.white : SXColor.textPrimary,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 36),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: SXColor.border,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'กรองข้อมูล',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: SXColor.textPrimary,
            ),
          ),
          const SizedBox(height: 16),

          // สถานะใบสมัคร
          const Text(
            'สถานะใบสมัคร',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: SXColor.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            children: statusOptions
                .map(
                  (s) =>
                      _chip(s, _status == s, () => setState(() => _status = s)),
                )
                .toList(),
          ),
          const SizedBox(height: 8),

          // ประเภททุน
          const Text(
            'ประเภททุน',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: SXColor.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            children: categoryOptions
                .map(
                  (c) => _chip(
                    c,
                    _category == c,
                    () => setState(() => _category = c),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 24),

          // Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _status = 'ทั้งหมด';
                      _category = 'ทั้งหมด';
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: SXColor.border),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'รีเซ็ต',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: SXColor.textSecondary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    widget.onApply(_status, _category);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: SXColor.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    textStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  child: const Text('ใช้ตัวกรอง'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Application List Screen ──────────────────────────────────────────────────
class ApplicationListScreen extends StatefulWidget {
  const ApplicationListScreen({super.key});

  @override
  State<ApplicationListScreen> createState() => _ApplicationListScreenState();
}

class _ApplicationListScreenState extends State<ApplicationListScreen> {
  String activeTab = 'ทั้งหมด';
  String activeCategory = 'ทั้งหมด';
  final tabs = ['ทั้งหมด', 'รอดำเนินการ', 'กำลังพิจารณา', 'อนุมัติ', 'ปฏิเสธ'];

  bool get hasActiveFilter =>
      activeTab != 'ทั้งหมด' || activeCategory != 'ทั้งหมด';

  List<Applicant> get filtered {
    return mockApplicants.where((a) {
      final statusMatch = activeTab == 'ทั้งหมด' || a.status == activeTab;
      return statusMatch;
    }).toList();
  }

  void _showMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(
                Icons.logout_rounded,
                color: Colors.redAccent,
              ),
              title: const Text(
                'ออกจากระบบ',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              onTap: () {
                Navigator.pop(context); // ปิด bottom sheet ก่อน
                Navigator.pushAndRemoveUntil(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => const SplashScreen(),
                    transitionsBuilder: (_, anim, __, child) =>
                        FadeTransition(opacity: anim, child: child),
                    transitionDuration: const Duration(milliseconds: 600),
                  ),
                  (route) => false, // ล้าง stack ทั้งหมด
                );
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: SXColor.primary,
        elevation: 0,
        title: const Text(
          'การจัดการใบสมัคร',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu_rounded, color: Colors.white),
            onPressed: () => _showMenu(context),
          ),
        ],
      ),
      backgroundColor: SXColor.background,
      bottomNavigationBar: const AdminBottomNav(currentIndex: 1),
      body: Column(
        children: [
          // Search bar
          Container(
            color: SXColor.surface,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: SXColor.background,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: SXColor.border),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: 'ค้นหาใบสมัคร',
                        hintStyle: TextStyle(
                          fontSize: 13,
                          color: SXColor.textSecondary,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          size: 18,
                          color: SXColor.textSecondary,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Filter button — highlight ถ้ามี filter active
                GestureDetector(
                  onTap: () => showFilterSheet(
                    context,
                    selectedStatus: activeTab,
                    selectedCategory: activeCategory,
                    onApply: (status, category) {
                      setState(() {
                        activeTab = status;
                        activeCategory = category;
                      });
                    },
                  ),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: hasActiveFilter
                          ? SXColor.primary
                          : SXColor.primaryBg,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: hasActiveFilter
                            ? SXColor.primary
                            : SXColor.primaryPale,
                      ),
                    ),
                    child: Icon(
                      Icons.filter_list,
                      color: hasActiveFilter ? Colors.white : SXColor.primary,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Filter tabs
          Container(
            width: double.infinity,
            color: SXColor.surface,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: tabs.map((tab) {
                  final active = tab == activeTab;
                  return GestureDetector(
                    onTap: () => setState(() => activeTab = tab),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: active ? SXColor.primary : SXColor.surface,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: active ? SXColor.primary : SXColor.border,
                        ),
                      ),
                      child: Text(
                        tab,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: active ? Colors.white : SXColor.textSecondary,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          // List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filtered.length,
              itemBuilder: (context, i) {
                final a = filtered[i];
                return ApplicantCard(
                  applicant: a,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ApplicationDetailScreen(applicant: a),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
