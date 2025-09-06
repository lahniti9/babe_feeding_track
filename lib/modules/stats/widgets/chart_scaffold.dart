import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/text.dart';
import 'seg_filter.dart';

class ChartScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final bool showFullReport;
  final bool showLock;
  final bool showShare;
  final VoidCallback? onFullReportTap;
  final VoidCallback? onShareTap;
  final Widget? bottomFilter;
  final List<String>? filterOptions;
  final String? selectedFilter;
  final Function(String)? onFilterChanged;

  const ChartScaffold({
    super.key,
    required this.title,
    required this.body,
    this.showFullReport = false,
    this.showLock = false,
    this.showShare = true,
    this.onFullReportTap,
    this.onShareTap,
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

            // Full report chip (if enabled)
            if (showFullReport) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: onFullReportTap,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(AppSpacing.sm),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.description,
                            color: Colors.green,
                            size: 16,
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            'Full report',
                            style: AppTextStyles.caption.copyWith(
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],

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
      floatingActionButton: showShare
          ? FloatingActionButton(
              onPressed: onShareTap ?? _defaultShare,
              backgroundColor: AppColors.primary,
              child: const Icon(
                Icons.share,
                color: Colors.white,
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _defaultShare() {
    // Default share implementation
    Share.share(
      'Check out my baby\'s statistics from Babe Feeding Track!',
      subject: 'Baby Statistics',
    );
  }
}
