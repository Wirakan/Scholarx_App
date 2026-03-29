// features/student/screens/scholar/scholar_screen.dart

import 'package:flutter/material.dart';
import '/coreApp/themeApp/app_colors.dart';
import '/coreApp/themeApp/app_text_style.dart';
import '../../components/scholarship_list_card.dart';
import '/student/models/scholarship_model.dart';
import '/student/screens/scholar/scholarship_detail.dart';

class ScholarScreen extends StatefulWidget {
  const ScholarScreen({super.key});

  @override
  State<ScholarScreen> createState() => _ScholarScreenState();
}

class _ScholarScreenState extends State<ScholarScreen> {
  ScholarshipCategory _selectedCategory = ScholarshipCategory.all;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // ── Filter state ──────────────────────────────────────────────────
  ScholarshipCategory? _filterCategory;           // null = ไม่กรอง
  RangeValues _amountRange = const RangeValues(0, 200000);
  bool _openOnly = false;

  static const double _maxAmount = 200000;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool get _hasActiveFilter =>
      _filterCategory != null || _openOnly || _amountRange != const RangeValues(0, _maxAmount);

  List<ScholarshipModel> get _filtered {
    return ScholarshipModel.mockList.where((s) {
      // category tab
      final matchCat =
          _selectedCategory == ScholarshipCategory.all ||
          s.category == _selectedCategory;

      // search
      final matchSearch =
          _searchQuery.isEmpty ||
          s.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          s.description.toLowerCase().contains(_searchQuery.toLowerCase());

      // filter sheet — category
      final matchFilterCat =
          _filterCategory == null || s.category == _filterCategory;

      // filter sheet — amount (ถ้า model มี field amount ให้ปรับตรงนี้)
      // ใช้ตัวอย่างเฉยๆ เพราะ mock อาจไม่มี field amount
      // final matchAmount = s.amount >= _amountRange.start && s.amount <= _amountRange.end;

      // filter sheet — open only (ถ้า model มี isOpen)
      // final matchOpen = !_openOnly || s.isOpen;

      return matchCat && matchSearch && matchFilterCat;
      // ถ้า model มี field ครบให้เพิ่ม && matchAmount && matchOpen
    }).toList();
  }

  static const _categories = [
    ScholarshipCategory.all,
    ScholarshipCategory.bachelor,
    ScholarshipCategory.research,
    ScholarshipCategory.assistance,
    ScholarshipCategory.innovation,
  ];

  // ── Filter Bottom Sheet ───────────────────────────────────────────
  void _showFilterSheet() {
    // local state สำหรับ sheet (จะ apply เมื่อกด "นำไปใช้")
    ScholarshipCategory? tempCategory = _filterCategory;
    RangeValues tempRange = _amountRange;
    bool tempOpenOnly = _openOnly;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Title row
                  Row(
                    children: [
                      Text('กรองทุน', style: AppTextStyle.h2),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          setSheetState(() {
                            tempCategory = null;
                            tempRange = const RangeValues(0, _maxAmount);
                            tempOpenOnly = false;
                          });
                        },
                        child: Text(
                          'รีเซ็ต',
                          style: AppTextStyle.label.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ── ประเภทกองทุน ──────────────────────────────────
                  Text(
                    'ประเภทกองทุน',
                    style: AppTextStyle.label.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ScholarshipCategory.bachelor,
                      ScholarshipCategory.research,
                      ScholarshipCategory.assistance,
                      ScholarshipCategory.innovation,
                    ].map((cat) {
                      final isSelected = tempCategory == cat;
                      return GestureDetector(
                        onTap: () => setSheetState(
                          () => tempCategory = isSelected ? null : cat,
                        ),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.background,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.border,
                            ),
                          ),
                          child: Text(
                            cat.label,
                            style: AppTextStyle.label.copyWith(
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  // ── เปิดรับสมัครอยู่ ──────────────────────────────
                  Row(
                    children: [
                      Text(
                        'เปิดรับสมัครอยู่เท่านั้น',
                        style: AppTextStyle.body,
                      ),
                      const Spacer(),
                      Switch(
                        value: tempOpenOnly,
                        activeColor: AppColors.primary,
                        onChanged: (v) =>
                            setSheetState(() => tempOpenOnly = v),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  const Divider(),
                  const SizedBox(height: 8),

                  // ── ปุ่มนำไปใช้ ───────────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        setState(() {
                          _filterCategory = tempCategory;
                          _amountRange = tempRange;
                          _openOnly = tempOpenOnly;
                        });
                        Navigator.pop(ctx);
                      },
                      child: Text(
                        'นำไปใช้',
                        style: AppTextStyle.label.copyWith(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // ── Orange Header ──────────────────────────────────────────
          Container(
            color: AppColors.primary,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 12,
              left: 20,
              right: 20,
              bottom: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'สมัครทุน',
                  style: AppTextStyle.display.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 2),
                Text(
                  'ทุนที่เปิดรับสมัคร ${ScholarshipModel.mockList.length} รายการ',
                  style: AppTextStyle.body.copyWith(
                    color: Colors.white.withOpacity(0.85),
                  ),
                ),
                const SizedBox(height: 16),

                // ── Search bar + Filter button ─────────────────────
                Row(
                  children: [
                    // Search bar (ขยายเต็ม)
                    Expanded(
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: (v) => setState(() => _searchQuery = v),
                          style: AppTextStyle.body,
                          decoration: InputDecoration(
                            hintText: 'ค้นหาทุน...',
                            hintStyle: AppTextStyle.body.copyWith(
                              color: AppColors.textTertiary,
                            ),
                            prefixIcon: const Icon(
                              Icons.search_rounded,
                              color: AppColors.textTertiary,
                              size: 20,
                            ),
                            suffixIcon: _searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(
                                      Icons.close_rounded,
                                      size: 18,
                                      color: AppColors.textTertiary,
                                    ),
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() => _searchQuery = '');
                                    },
                                  )
                                : null,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),

                    // ── Filter Button ──────────────────────────────
                    GestureDetector(
                      onTap: _showFilterSheet,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: _hasActiveFilter
                              ? Colors.white
                              : Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _hasActiveFilter
                                ? Colors.white
                                : Colors.white.withOpacity(0.4),
                            width: 1.5,
                          ),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(
                              Icons.tune_rounded,
                              color: _hasActiveFilter
                                  ? AppColors.primary
                                  : Colors.white,
                              size: 22,
                            ),
                            // Badge แสดงว่า filter ถูก active
                            if (_hasActiveFilter)
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── Filter Tabs ────────────────────────────────────────────
          Container(
            width: double.infinity,
            color: AppColors.surface,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: _categories.map((cat) {
                  final isSelected = _selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedCategory = cat),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.background,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.border,
                          ),
                        ),
                        child: Text(
                          cat.label,
                          style: AppTextStyle.label.copyWith(
                            color: isSelected
                                ? Colors.white
                                : AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // ── Active filter chips (แสดงเมื่อมี filter) ──────────────
          if (_hasActiveFilter)
            Container(
              width: double.infinity,
              color: AppColors.surface,
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: 10,
              ),
              child: Wrap(
                spacing: 6,
                children: [
                  if (_filterCategory != null)
                    _FilterChip(
                      label: _filterCategory!.label,
                      onRemove: () =>
                          setState(() => _filterCategory = null),
                    ),
                  if (_openOnly)
                    _FilterChip(
                      label: 'เปิดรับสมัคร',
                      onRemove: () => setState(() => _openOnly = false),
                    ),
                ],
              ),
            ),

          // ── Scholarship List ───────────────────────────────────────
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 48,
                          color: AppColors.textTertiary,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'ไม่พบทุนที่ค้นหา',
                          style: AppTextStyle.h3.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (ctx, i) => ScholarshipListCard(
                      scholarship: filtered[i],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ScholarshipDetailScreen(
                              scholarship: filtered[i],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

// ── Reusable filter chip ───────────────────────────────────────────────────────
class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, required this.onRemove});

  final String label;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTextStyle.label.copyWith(
              color: AppColors.primary,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: Icon(
              Icons.close_rounded,
              size: 14,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}