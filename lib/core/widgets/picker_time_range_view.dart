import 'package:flutter/material.dart';
import '../theme/spacing.dart';
import 'bc_scaffold.dart';
import 'segment_header.dart';
import 'time_picker_row.dart';
import 'primary_button.dart';
import 'primary_button.dart' as pb;

class PickerTimeRangeView extends StatelessWidget {
  final String title;
  final String? caption;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final Function(TimeOfDay) onStartTimeChanged;
  final Function(TimeOfDay) onEndTimeChanged;
  final VoidCallback? onNext;
  final String nextButtonText;
  final bool showSkip;
  final VoidCallback? onSkip;
  final String? skipText;
  final bool isLoading;
  final String startLabel;
  final String endLabel;
  final VoidCallback? onDontKnow;
  final String? dontKnowText;

  const PickerTimeRangeView({
    super.key,
    required this.title,
    this.caption,
    required this.startTime,
    required this.endTime,
    required this.onStartTimeChanged,
    required this.onEndTimeChanged,
    this.onNext,
    this.nextButtonText = "Next",
    this.showSkip = false,
    this.onSkip,
    this.skipText = "Skip",
    this.isLoading = false,
    this.startLabel = "Start time",
    this.endLabel = "End time",
    this.onDontKnow,
    this.dontKnowText = "I don't know",
  });

  @override
  Widget build(BuildContext context) {
    return BCScaffold(
      showBack: true,
      skipText: showSkip ? skipText : null,
      onSkip: onSkip,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
              child: Column(
                children: [
                  SegmentHeader(
                    title: title,
                    caption: caption,
                    padding: const EdgeInsets.only(
                      top: AppSpacing.xxl,
                      bottom: AppSpacing.betweenSections,
                    ),
                  ),
                  TimePickerRow(
                    label: startLabel,
                    value: startTime,
                    onChanged: onStartTimeChanged,
                  ),
                  TimePickerRow(
                    label: endLabel,
                    value: endTime,
                    onChanged: onEndTimeChanged,
                  ),
                  if (onDontKnow != null) ...[
                    const SizedBox(height: AppSpacing.lg),
                    pb.GhostButton(
                      label: dontKnowText!,
                      onTap: onDontKnow,
                    ),
                  ],
                ],
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
                isEnabled: true, // Always enabled since times are always selected
              ),
            ),
          ),
        ],
      ),
    );
  }
}
