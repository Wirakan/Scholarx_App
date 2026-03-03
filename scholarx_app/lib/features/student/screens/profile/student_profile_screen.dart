import 'package:flutter/material.dart';
import '/coreApp/themeApp/app_colors.dart';
import '/coreApp/themeApp/app_text_style.dart';
import '/features/student/models/student_model.dart';

class StudentProfileScreen extends StatelessWidget {
  final StudentModel student;
  const StudentProfileScreen({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _ProfileHero(student: student)),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _InfoSection(student: student),
                const SizedBox(height: 16),
                _StatsRow(gpa: student.gpa),
                const SizedBox(height: 16),
                _MenuSection(),
                const SizedBox(height: 24),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileHero extends StatelessWidget {
  final StudentModel student;
  const _ProfileHero({required this.student});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 20,
        left: 20,
        right: 20,
        bottom: 32,
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 44,
            backgroundColor: Colors.white.withOpacity(0.25),
            child: const Icon(Icons.person, color: Colors.white, size: 48),
          ),
          const SizedBox(height: 12),
          Text(
            student.fullName,
            style: AppTextStyle.h2.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 4),
          Text(
            student.studentId,
            style: AppTextStyle.body.copyWith(
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'แก้ไขข้อมูล',
              style: AppTextStyle.label.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  final StudentModel student;
  const _InfoSection({required this.student});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('ข้อมูลส่วนตัว', style: AppTextStyle.h3),
          const SizedBox(height: 16),
          _InfoRow(label: 'อีเมล', value: student.email),
          const Divider(height: 24, color: AppColors.border),
          _InfoRow(label: 'คณะ', value: student.faculty),
          const Divider(height: 24, color: AppColors.border),
          _InfoRow(label: 'สาขา', value: student.major),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

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

class _StatsRow extends StatelessWidget {
  final double gpa;
  const _StatsRow({required this.gpa});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: 'GPA',
            value: gpa.toStringAsFixed(2),
            icon: Icons.grade_rounded,
            color: AppColors.success,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            label: 'ทุนที่ได้รับ',
            value: '2',
            icon: Icons.emoji_events_rounded,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            label: 'รอดำเนินการ',
            value: '1',
            icon: Icons.hourglass_empty_rounded,
            color: AppColors.warning,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyle.statNumber.copyWith(color: color, fontSize: 18),
          ),
          const SizedBox(height: 2),
          Text(label, style: AppTextStyle.caption, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _MenuSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.history_rounded, 'ประวัติการสมัครทุน', AppColors.primary),
      (Icons.description_rounded, 'เอกสารของฉัน', AppColors.info),
      (Icons.notifications_rounded, 'การแจ้งเตือน', AppColors.warning),
      (Icons.help_outline_rounded, 'ช่วยเหลือ / FAQ', AppColors.textSecondary),
      (Icons.logout_rounded, 'ออกจากระบบ', AppColors.error),
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: List.generate(items.length, (i) {
          final item = items[i];
          return Column(
            children: [
              ListTile(
                leading: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: item.$3.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(item.$1, color: item.$3, size: 18),
                ),
                title: Text(item.$2, style: AppTextStyle.bodyMedium),
                trailing: const Icon(
                  Icons.chevron_right,
                  color: AppColors.textTertiary,
                  size: 20,
                ),
                onTap: () {},
              ),
              if (i < items.length - 1)
                const Divider(
                  height: 1,
                  indent: 16,
                  endIndent: 16,
                  color: AppColors.border,
                ),
            ],
          );
        }),
      ),
    );
  }
}
