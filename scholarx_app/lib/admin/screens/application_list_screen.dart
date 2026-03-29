import 'package:flutter/material.dart';
import '../core/colors.dart';
import '../core/models.dart';
import '../widgets/applicant_card.dart';
import 'application_detail_screen.dart';
import '../widgets/admin_bottom_nav.dart';
import '/shared/application_repository.dart';
import '/screens/splash_screen.dart';
import 'submitted_application_detail_screen.dart';

// ─── Filter Sheet ──────────────────────────────────────────────────────
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
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => setState(() {
                    _status = 'ทั้งหมด';
                    _category = 'ทั้งหมด';
                  }),
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

// ─── Application List Screen ──────────────────────────────────────────
class ApplicationListScreen extends StatefulWidget {
  const ApplicationListScreen({super.key});

  @override
  State<ApplicationListScreen> createState() => _ApplicationListScreenState();
}

class _ApplicationListScreenState extends State<ApplicationListScreen> {
  String _activeTab = 'ทั้งหมด';
  String _activeCategory = 'ทั้งหมด';
  String _searchQuery = '';
  final tabs = ['ทั้งหมด', 'รอดำเนินการ', 'กำลังพิจารณา', 'อนุมัติ', 'ปฏิเสธ'];

  bool get hasActiveFilter =>
      _activeTab != 'ทั้งหมด' || _activeCategory != 'ทั้งหมด';

  /// แปลง ApplicationRecord → Applicant เพื่อใช้กับ ApplicantCard เดิม
  Applicant _toApplicant(ApplicationRecord r) {
    return Applicant(
      id: r.id,
      name: r.fullName,
      studentId: r.studentId,
      scholarship: r.scholarshipName,
      faculty: r.faculty,
      major: r.major,
      year: r.year,
      gpa: r.gpa,
      address: r.address,
      email: r.email,
      date: r.formattedAppliedDate,
      status: r.status.label,
      reason: r.reason,
    );
  }

  List<ApplicationRecord> _getFilteredRepo(List<ApplicationRecord> all) {
    return all.where((r) {
      final statusMatch =
          _activeTab == 'ทั้งหมด' || r.status.label == _activeTab;
      final searchMatch =
          _searchQuery.isEmpty ||
          r.fullName.contains(_searchQuery) ||
          r.studentId.contains(_searchQuery) ||
          r.scholarshipName.contains(_searchQuery) ||
          r.id.contains(_searchQuery);
      return statusMatch && searchMatch;
    }).toList();
  }

  List<Applicant> _getFilteredMock() {
    return mockApplicants.where((a) {
      final statusMatch = _activeTab == 'ทั้งหมด' || a.status == _activeTab;
      final searchMatch =
          _searchQuery.isEmpty ||
          a.name.contains(_searchQuery) ||
          a.studentId.contains(_searchQuery) ||
          a.scholarship.contains(_searchQuery);
      return statusMatch && searchMatch;
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
                Navigator.pop(context);
                Navigator.pushAndRemoveUntil(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => const SplashScreen(),
                    transitionsBuilder: (_, anim, __, child) =>
                        FadeTransition(opacity: anim, child: child),
                    transitionDuration: const Duration(milliseconds: 600),
                  ),
                  (route) => false,
                );
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  /// Navigate ไป detail พร้อม applicationId ที่ถูกต้อง
void _openDetail(BuildContext context, Applicant a, String? applicationId) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) {
        if (applicationId != null) {
          return SubmittedApplicationDetailScreen(
            applicationId: applicationId,
          );
        }

        return ApplicationDetailScreen(
          applicant: a,
          applicationId: applicationId,
        );
      },
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ApplicationRepository.instance,
      builder: (context, _) {
        final repoRecords = ApplicationRepository.instance.all;

        // แยก filtered list ของ repo และ mock
        final filteredRepoRecords = _getFilteredRepo(repoRecords);
        final filteredRepoApplicants = filteredRepoRecords
            .map(_toApplicant)
            .toList();
        final filteredMockApplicants = _getFilteredMock();

        // รวมกัน: repo records ก่อน ตามด้วย mock
        final filteredApplicants = [
          ...filteredRepoApplicants,
          ...filteredMockApplicants,
        ];

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
              // ── Search ──
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
                        child: TextField(
                          onChanged: (v) => setState(() => _searchQuery = v),
                          decoration: const InputDecoration(
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
                    GestureDetector(
                      onTap: () => showFilterSheet(
                        context,
                        selectedStatus: _activeTab,
                        selectedCategory: _activeCategory,
                        onApply: (s, c) => setState(() {
                          _activeTab = s;
                          _activeCategory = c;
                        }),
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
                          color: hasActiveFilter
                              ? Colors.white
                              : SXColor.primary,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // ── Tabs ──
              Container(
                width: double.infinity,
                color: SXColor.surface,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Row(
                    children: tabs.map((tab) {
                      final active = tab == _activeTab;
                      return GestureDetector(
                        onTap: () => setState(() => _activeTab = tab),
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
                              color: active
                                  ? Colors.white
                                  : SXColor.textSecondary,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              // ── List ──
              Expanded(
                child: filteredApplicants.isEmpty
                    ? const Center(
                        child: Text(
                          'ไม่มีใบสมัคร',
                          style: TextStyle(color: SXColor.textSecondary),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filteredApplicants.length,
                        itemBuilder: (context, i) {
                          final a = filteredApplicants[i];
                          // ค้นหา record จาก repo ด้วย id ที่ตรงกัน
                          final record = ApplicationRepository.instance
                              .findById(a.id);
                          return ApplicantCard(
                            applicant: a,
                            onTap: () => _openDetail(context, a, record?.id),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
