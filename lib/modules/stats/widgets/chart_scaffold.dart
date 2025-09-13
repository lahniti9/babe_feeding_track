import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/text.dart';
import 'seg_filter.dart';

class ChartScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final bool showLock;
  final Widget? bottomFilter;
  final List<String>? filterOptions;
  final String? selectedFilter;
  final Function(String)? onFilterChanged;

  const ChartScaffold({
    super.key,
    required this.title,
    required this.body,
    this.showLock = false,
    this.bottomFilter,
    this.filterOptions,
    this.selectedFilter,
    this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.background,
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.textSecondary.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                    color: AppColors.textPrimary,
                  ),
                  Expanded(
                    child: Text(
                      title,
                      style: AppTextStyles.h3,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  if (showLock)
                    Icon(
                      Icons.lock_outline,
                      color: AppColors.textSecondary,
                      size: 20,
                    )
                  else
                    const SizedBox(width: 20),
                ],
              ),
            ),

            // Full report chip removed

            // Body
            Expanded(
              child: body,
            ),

            // Bottom filter (if provided)
            if (bottomFilter != null) ...[
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  border: Border(
                    top: BorderSide(
                      color: AppColors.textSecondary.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                ),
                child: bottomFilter!,
              ),
            ] else if (filterOptions != null && onFilterChanged != null) ...[
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  border: Border(
                    top: BorderSide(
                      color: AppColors.textSecondary.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                ),
                child: SegFilter(
                  options: filterOptions!,
                  selectedOption: selectedFilter ?? filterOptions!.first,
                  onChanged: onFilterChanged!,
                ),
              ),
            ],
          ],
        ),
      ),
      // Floating action button (share icon) removed
    );
  }


}
