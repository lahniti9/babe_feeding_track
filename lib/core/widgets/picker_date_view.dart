import 'package:flutter/cupertino.dart';
import '../theme/colors.dart';
import '../theme/spacing.dart';
import 'bc_scaffold.dart';
import 'segment_header.dart';
import 'primary_button.dart';

class PickerDateView extends StatelessWidget {
  final String title;
  final String? caption;
  final DateTime selectedDate;
  final Function(DateTime) onDateChanged;
  final VoidCallback? onNext;
  final String nextButtonText;
  final bool showSkip;
  final VoidCallback? onSkip;
  final String? skipText;
  final bool isLoading;
  final DateTime? minimumDate;
  final DateTime? maximumDate;
  final CupertinoDatePickerMode mode;

  const PickerDateView({
    super.key,
    required this.title,
    this.caption,
    required this.selectedDate,
    required this.onDateChanged,
    this.onNext,
    this.nextButtonText = "Next",
    this.showSkip = false,
    this.onSkip,
    this.skipText = "Skip",
    this.isLoading = false,
    this.minimumDate,
    this.maximumDate,
    this.mode = CupertinoDatePickerMode.date,
  });

  @override
  Widget build(BuildContext context) {
    return BCScaffold(
      showBack: true,
      skipText: showSkip ? skipText : null,
      onSkip: onSkip,
      body: Column(
        children: [
          SegmentHeader(
            title: title,
            caption: caption,
            padding: const EdgeInsets.only(
              top: AppSpacing.xxl,
              bottom: AppSpacing.betweenSections,
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
              child: CupertinoDatePicker(
                mode: mode,
                initialDateTime: selectedDate,
                minimumDate: minimumDate,
                maximumDate: maximumDate,
                onDateTimeChanged: onDateChanged,
                backgroundColor: AppColors.background,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: PrimaryButton(
                label: nextButtonText,
                onTap: onNext,
                isLoading: isLoading,
                isEnabled: true, // Always enabled since date is always selected
              ),
            ),
          ),
        ],
      ),
    );
  }
}
