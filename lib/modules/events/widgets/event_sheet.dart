import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text.dart';
import 'primary_pill.dart';

class EventSheet extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Widget> sections;
  final VoidCallback onSubmit;
  final Widget? trailing;
  final IconData? icon;
  final Color? accentColor;

  const EventSheet({
    super.key,
    required this.title,
    this.subtitle,
    required this.sections,
    required this.onSubmit,
    this.trailing,
    this.icon,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveAccentColor = accentColor ?? AppColors.coral;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
        minHeight: MediaQuery.of(context).size.height * 0.6,
      ),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, -10),
          ),
          BoxShadow(
            color: effectiveAccentColor.withValues(alpha: 0.1),
            blurRadius: 40,
            offset: const Offset(0, -20),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Enhanced handle bar
          Container(
            margin: const EdgeInsets.only(top: 16),
            width: 48,
            height: 5,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  effectiveAccentColor.withValues(alpha: 0.3),
                  effectiveAccentColor.withValues(alpha: 0.6),
                  effectiveAccentColor.withValues(alpha: 0.3),
                ],
              ),
              borderRadius: BorderRadius.circular(3),
            ),
          ),

          // Enhanced header
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (icon != null) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: effectiveAccentColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: effectiveAccentColor.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          icon,
                          color: effectiveAccentColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: AppTextStyles.titleLarge.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 24,
                            ),
                          ),
                          if (subtitle != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              subtitle!,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (trailing != null) trailing!,
                  ],
                ),
              ],
            ),
          ),

          // Enhanced divider
          Container(
            height: 1,
            margin: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  effectiveAccentColor.withValues(alpha: 0.3),
                  effectiveAccentColor.withValues(alpha: 0.6),
                  effectiveAccentColor.withValues(alpha: 0.3),
                  Colors.transparent,
                ],
              ),
            ),
          ),

          // Scrollable content with enhanced spacing
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sections
                  ...sections.map((section) => Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: section,
                  )),

                  const SizedBox(height: 16),

                  // Enhanced Done button
                  PrimaryPill(
                    label: 'Done',
                    icon: Icons.check_rounded,
                    onTap: onSubmit,
                    color: effectiveAccentColor,
                  ),

                  // Bottom padding for safe area
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
