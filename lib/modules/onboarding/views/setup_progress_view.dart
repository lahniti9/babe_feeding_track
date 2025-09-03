import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/bc_scaffold.dart';
import '../../../core/widgets/progress_ring.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/text.dart';

class SetupProgressView extends StatefulWidget {
  final double progress;
  final String message;
  final String nextRoute;
  final int delaySeconds;

  const SetupProgressView({
    super.key,
    required this.progress,
    required this.message,
    required this.nextRoute,
    this.delaySeconds = 3,
  });

  @override
  State<SetupProgressView> createState() => _SetupProgressViewState();
}

class _SetupProgressViewState extends State<SetupProgressView> {
  @override
  void initState() {
    super.initState();
    // Auto-navigate after delay
    Future.delayed(Duration(seconds: widget.delaySeconds), () {
      if (mounted) {
        Get.toNamed(widget.nextRoute);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BCScaffold(
      showBack: false,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ProgressRing(
                percent: widget.progress,
                size: 200,
                strokeWidth: 8,
                backgroundColor: AppColors.cardBackground,
                progressColor: AppColors.primary,
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                widget.message,
                style: AppTextStyles.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Specific progress screens
class Setup18View extends StatelessWidget {
  const Setup18View({super.key});

  @override
  Widget build(BuildContext context) {
    return const SetupProgressView(
      progress: 0.18,
      message: "Preparing custom recommendations",
      nextRoute: '/setup-59',
    );
  }
}

class Setup59View extends StatelessWidget {
  const Setup59View({super.key});

  @override
  Widget build(BuildContext context) {
    return const SetupProgressView(
      progress: 0.59,
      message: "Making a list of reminders",
      nextRoute: '/setup-73',
    );
  }
}

class Setup73View extends StatelessWidget {
  const Setup73View({super.key});

  @override
  Widget build(BuildContext context) {
    return const SetupProgressView(
      progress: 0.73,
      message: "Creating a baby's health report template",
      nextRoute: '/setup-87',
    );
  }
}

class Setup87View extends StatelessWidget {
  const Setup87View({super.key});

  @override
  Widget build(BuildContext context) {
    return const SetupProgressView(
      progress: 0.87,
      message: "Adding a code to sync with other devices",
      nextRoute: '/with-without',
    );
  }
}
