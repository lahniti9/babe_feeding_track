import 'package:flutter/material.dart';
import '../theme/spacing.dart';
import 'bc_scaffold.dart';
import 'segment_header.dart';
import 'option_tile.dart';
import 'primary_button.dart';

class QuestionOption {
  final String value;
  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;

  const QuestionOption({
    required this.value,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
  });
}

class QuestionSingleView extends StatelessWidget {
  final String title;
  final String? caption;
  final List<QuestionOption> options;
  final String? selectedValue;
  final Function(String) onSelectionChanged;
  final VoidCallback? onNext;
  final String nextButtonText;
  final bool showSkip;
  final VoidCallback? onSkip;
  final String? skipText;
  final bool isLoading;
  final bool autoNavigate;

  const QuestionSingleView({
    super.key,
    required this.title,
    this.caption,
    required this.options,
    this.selectedValue,
    required this.onSelectionChanged,
    this.onNext,
    this.nextButtonText = "Next",
    this.showSkip = false,
    this.onSkip,
    this.skipText = "Skip",
    this.isLoading = false,
    this.autoNavigate = false,
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
                  ...options.map((option) => OptionTile(
                    title: option.title,
                    subtitle: option.subtitle,
                    selected: selectedValue == option.value,
                    leading: option.leading,
                    trailing: option.trailing,
                    onTap: () => onSelectionChanged(option.value),
                  )),
                ],
              ),
            ),
          ),
          if (!autoNavigate)
            Container(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              child: PrimaryButton(
                label: nextButtonText,
                onTap: selectedValue != null ? onNext : null,
                isLoading: isLoading,
                isEnabled: selectedValue != null,
              ),
            ),
        ],
      ),
    );
  }
}
