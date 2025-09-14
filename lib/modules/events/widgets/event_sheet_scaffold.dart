import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text.dart';

class EventSheetScaffold extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final Widget child;
  final bool showHandle;

  const EventSheetScaffold({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    required this.child,
    this.showHandle = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85, // Increased to 85% of screen height
        minHeight: MediaQuery.of(context).size.height * 0.6,  // Added minimum height
      ),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 24,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          if (showHandle)
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.coral.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12), // Reduced padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: AppTextStyles.titleLarge.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 22, // Reduced from 24 to 22
                        ),
                      ),
                    ),
                    if (trailing != null) trailing!,
                  ],
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 14, // Reduced from 16 to 14
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Divider
          Container(
            height: 1,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  AppColors.coral.withValues(alpha: 0.2),
                  Colors.transparent,
                ],
              ),
            ),
          ),

          // Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
