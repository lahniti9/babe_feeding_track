import 'package:flutter/material.dart';
import '../theme/spacing.dart';
import 'bc_scaffold.dart';
import 'segment_header.dart';
import 'check_tile.dart';
import 'primary_button.dart';

class QuestionMultiOption {
  final String value;
  final String title;
  final String? subtitle;
  final Widget? leading;

  const QuestionMultiOption({
    required this.value,
    required this.title,
    this.subtitle,
    this.leading,
  });
}

class QuestionMultiView extends StatelessWidget {
  final String title;
  final String? caption;
  final List<QuestionMultiOption> options;
  final List<String> selectedValues;
  final Function(String) onSelectionToggled;
  final VoidCallback? onNext;
  final String nextButtonText;
  final bool showSkip;
  final VoidCallback? onSkip;
  final String? skipText;
  final bool isLoading;
  final bool requireSelection;

  const QuestionMultiView({
    super.key,
    required this.title,
    this.caption,
    required this.options,
    required this.selectedValues,
    required this.onSelectionToggled,
    this.onNext,
    this.nextButtonText = "Next",
    this.showSkip = false,
    this.onSkip,
    this.skipText = "Skip",
    this.isLoading = false,
    this.requireSelection = true,
  });

  @override
  Widget build(BuildContext context) {
    final hasSelection = selectedValues.isNotEmpty;
    final canProceed = !requireSelection || hasSelection;

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
                  ...options.map((option) => CheckTile(
                    title: option.title,
                    subtitle: option.subtitle,
                    selected: selectedValues.contains(option.value),
                    leading: option.leading,
                    onTap: () => onSelectionToggled(option.value),
                  )),
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
                onTap: canProceed ? onNext : null,
                isLoading: isLoading,
                isEnabled: canProceed,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
