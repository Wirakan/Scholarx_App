import 'package:flutter/material.dart';
import '/coreApp/themeApp/app_colors.dart';
import '/coreApp/themeApp/app_text_style.dart';

// ─────────────────────────────────────────────
//  ORANGE HEADER  (title + subtitle only)
// ─────────────────────────────────────────────
class FormHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const FormHeader({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFEB591A), Color(0xFFFF7A3D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 52, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyle.heading2.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: AppTextStyle.body.copyWith(
              color: Colors.white.withOpacity(0.9),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  WHITE STEP INDICATOR BAR
// ─────────────────────────────────────────────
class StepIndicatorBar extends StatelessWidget {
  final int currentStep; // 1-5
  final List<String> labels;

  const StepIndicatorBar({
    super.key,
    required this.currentStep,
    this.labels = const [
      'ข้อมูล\nส่วนตัว',
      'ข้อมูล\nครอบครัว',
      'ผู้อุปการะ',
      'แนบ\nเอกสาร',
      'ยืนยัน',
    ],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(labels.length * 2 - 1, (i) {
          // even index = step, odd index = connector line
          if (i.isOdd) {
            final stepIndex = i ~/ 2;
            final isDone = (stepIndex + 1) < currentStep;
            return Expanded(
              child: Container(
                height: 2,
                margin: const EdgeInsets.only(top: 13),
                color: isDone ? AppColors.primary : AppColors.border,
              ),
            );
          }

          final stepIndex = i ~/ 2;
          final step = stepIndex + 1;
          final isDone = step < currentStep;
          final isActive = step == currentStep;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _StepCircle(step: step, isDone: isDone, isActive: isActive),
              const SizedBox(height: 4),
              Text(
                labels[stepIndex],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isActive || isDone
                      ? FontWeight.w700
                      : FontWeight.w400,
                  color: isActive
                      ? AppColors.primary
                      : isDone
                      ? AppColors.primary
                      : AppColors.textTertiary,
                  height: 1.3,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _StepCircle extends StatelessWidget {
  final int step;
  final bool isDone;
  final bool isActive;

  const _StepCircle({
    required this.step,
    required this.isDone,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    Color bg = isDone || isActive ? AppColors.primary : AppColors.border;
    Widget child = isDone
        ? const Icon(Icons.check, color: Colors.white, size: 14)
        : Text(
            '$step',
            style: TextStyle(
              color: isActive ? Colors.white : AppColors.textTertiary,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          );

    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: child,
    );
  }
}

// ─────────────────────────────────────────────
//  ORANGE INFO BANNER
// ─────────────────────────────────────────────
class FormInfoBanner extends StatelessWidget {
  final String message;

  const FormInfoBanner({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primaryBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primaryLight.withOpacity(0.4)),
      ),
      child: Text(
        message,
        style: AppTextStyle.caption.copyWith(
          color: AppColors.primaryDark,
          height: 1.5,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  WHITE SECTION CARD
// ─────────────────────────────────────────────
class FormSectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color iconBgColor;
  final List<Widget> children;

  const FormSectionCard({
    super.key,
    required this.icon,
    required this.title,
    this.iconBgColor = const Color(0xFFFFF0E8),
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppColors.primary, size: 18),
              ),
              const SizedBox(width: 10),
              Text(title, style: AppTextStyle.title),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  LABELED TEXT FIELD
// ─────────────────────────────────────────────
class FormTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final bool isRequired;
  final TextEditingController? controller;
  final int maxLines;

  const FormTextField({
    super.key,
    required this.label,
    this.hint,
    this.isRequired = true,
    this.controller,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: AppTextStyle.bodyMedium,
            children: isRequired
                ? [
                    const TextSpan(
                      text: '*',
                      style: TextStyle(color: AppColors.error),
                    ),
                  ]
                : [],
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          style: AppTextStyle.body,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyle.body.copyWith(
              color: AppColors.textTertiary,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  LABELED DROPDOWN
// ─────────────────────────────────────────────
class FormDropdown extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final bool isRequired;
  final ValueChanged<String?>? onChanged;

  const FormDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    this.isRequired = true,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: AppTextStyle.bodyMedium,
            children: isRequired
                ? [
                    const TextSpan(
                      text: '*',
                      style: TextStyle(color: AppColors.error),
                    ),
                  ]
                : [],
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
          style: AppTextStyle.body,
          icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.primary),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  BOTTOM NAV BAR
// ─────────────────────────────────────────────
class AppBottomNavBar extends StatelessWidget {
  final int activeIndex;

  const AppBottomNavBar({super.key, this.activeIndex = 1});

  @override
  Widget build(BuildContext context) {
    const items = [
      _NavDef(Icons.home_outlined, 'Home'),
      _NavDef(Icons.school_outlined, 'Scholar'),
      _NavDef(Icons.description_outlined, 'Tracking'),
      _NavDef(Icons.notifications_outlined, 'Alert'),
      _NavDef(Icons.person_outline, 'Profile'),
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (i) {
          final active = i == activeIndex;
          final color = active ? AppColors.primary : AppColors.textTertiary;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(items[i].icon, color: color, size: 24),
              const SizedBox(height: 4),
              Text(
                items[i].label,
                style: TextStyle(color: color, fontSize: 11),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _NavDef {
  final IconData icon;
  final String label;
  const _NavDef(this.icon, this.label);
}

// ─────────────────────────────────────────────
//  BOTTOM BUTTON ROW (ย้อนกลับ / ถัดไป)
// ─────────────────────────────────────────────
class FormBottomButtons extends StatelessWidget {
  final VoidCallback? onBack;
  final VoidCallback? onNext;
  final String nextLabel;

  const FormBottomButtons({
    super.key,
    this.onBack,
    this.onNext,
    this.nextLabel = 'ถัดไป',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onBack ?? () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, size: 16),
              label: const Text('ย้อนกลับ'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: onNext,
              icon: const Icon(Icons.arrow_forward, size: 16),
              iconAlignment: IconAlignment.end,
              label: Text(nextLabel),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
                elevation: 0,
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
