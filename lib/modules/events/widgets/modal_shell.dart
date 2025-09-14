import 'package:flutter/material.dart';
import '../../../core/theme/text.dart';
import '../../../core/theme/colors.dart';

class ModalShell extends StatelessWidget {
  final String title;
  final Widget? right;
  final Widget child;

  const ModalShell({
    super.key,
    required this.title,
    this.right,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85, // Added height constraint
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
          Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12), // Reduced padding
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.titleMedium.copyWith(
                      color: Colors.white,
                      fontSize: 22, // Increased font size for consistency
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (right != null) right!,
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
