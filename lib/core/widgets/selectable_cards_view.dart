import 'package:flutter/material.dart';
import '../theme/spacing.dart';
import 'bc_scaffold.dart';
import 'segment_header.dart';
import 'selectable_card.dart';
import 'primary_button.dart';

class SelectableCardOption {
  final String value;
  final String title;
  final String? subtitle;
  final Widget? image;
  final String? imageAsset;
  final String buttonText;

  const SelectableCardOption({
    required this.value,
    required this.title,
    this.subtitle,
    this.image,
    this.imageAsset,
    this.buttonText = "Select",
  });
}

class SelectableCardsView extends StatelessWidget {
  final String title;
  final String? caption;
  final List<SelectableCardOption> options;
  final String? selectedValue;
  final Function(String) onSelectionChanged;
  final VoidCallback? onNext;
  final String nextButtonText;
  final bool showSkip;
  final VoidCallback? onSkip;
  final String? skipText;
  final bool isLoading;

  const SelectableCardsView({
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
                  ...options.map((option) => SelectableCard(
                    title: option.title,
                    subtitle: option.subtitle,
                    image: option.image,
                    imageAsset: option.imageAsset,
                    selected: selectedValue == option.value,
                    buttonText: option.buttonText,
                    onTap: () => onSelectionChanged(option.value),
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
                onTap: selectedValue != null ? onNext : null,
                isLoading: isLoading,
                isEnabled: selectedValue != null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
