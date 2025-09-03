import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/spacing.dart';
import '../theme/text.dart';
import 'bc_scaffold.dart';
import 'segment_header.dart';
import 'primary_button.dart';

class TextInputView extends StatefulWidget {
  final String title;
  final String? caption;
  final String? value;
  final Function(String) onValueChanged;
  final VoidCallback? onNext;
  final String nextButtonText;
  final bool showSkip;
  final VoidCallback? onSkip;
  final String? skipText;
  final bool isLoading;
  final String? hint;
  final TextInputType keyboardType;
  final bool required;

  const TextInputView({
    super.key,
    required this.title,
    this.caption,
    this.value,
    required this.onValueChanged,
    this.onNext,
    this.nextButtonText = "Next",
    this.showSkip = false,
    this.onSkip,
    this.skipText = "Skip",
    this.isLoading = false,
    this.hint,
    this.keyboardType = TextInputType.text,
    this.required = true,
  });

  @override
  State<TextInputView> createState() => _TextInputViewState();
}

class _TextInputViewState extends State<TextInputView> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BCScaffold(
      showBack: true,
      skipText: widget.showSkip ? widget.skipText : null,
      onSkip: widget.onSkip,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
              child: Column(
                children: [
                  SegmentHeader(
                    title: widget.title,
                    caption: widget.caption,
                    padding: const EdgeInsets.only(
                      top: AppSpacing.xxl,
                      bottom: AppSpacing.betweenSections,
                    ),
                  ),

                  // Input field
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                      border: Border.all(
                        color: AppColors.border,
                        width: 1,
                      ),
                    ),
                    child: TextField(
                      controller: _controller,
                      keyboardType: widget.keyboardType,
                      style: AppTextStyles.input,
                      autofocus: true, // Auto-focus for better UX
                      decoration: InputDecoration(
                        hintText: widget.hint,
                        hintStyle: AppTextStyles.subtitle,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(AppSpacing.lg),
                      ),
                      onChanged: (value) {
                        widget.onValueChanged(value);
                        setState(() {}); // Rebuild to update button state
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: PrimaryButton(
                label: widget.nextButtonText,
                onTap: _shouldEnableButton() ? widget.onNext : null,
                isLoading: widget.isLoading,
                isEnabled: _shouldEnableButton(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _shouldEnableButton() {
    final hasValue = _controller.text.trim().isNotEmpty;
    return !widget.required || hasValue;
  }
}
