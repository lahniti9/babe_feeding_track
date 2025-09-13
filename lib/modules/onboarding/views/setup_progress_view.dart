import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/bc_scaffold.dart';
import '../../../core/widgets/progress_ring.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/text.dart';

class SetupProgressView extends StatefulWidget {
  final int? startStage;

  const SetupProgressView({super.key, this.startStage});

  @override
  State<SetupProgressView> createState() => _SetupProgressViewState();
}

class _SetupProgressViewState extends State<SetupProgressView>
    with TickerProviderStateMixin {
  late AnimationController _overallController;
  late Animation<double> _overallAnimation;

  int _currentStage = 0;
  double _currentProgress = 0.0;

  final List<ProgressStage> _stages = [
    ProgressStage(progress: 0.18, message: "Preparing custom recommendations"),
    ProgressStage(progress: 0.59, message: "Making a list of reminders"),
    ProgressStage(progress: 0.73, message: "Creating a baby's health report template"),
    ProgressStage(progress: 0.87, message: "Adding a code to sync with other devices"),
  ];

  @override
  void initState() {
    super.initState();

    // Set starting stage (default to 0 if not specified)
    _currentStage = widget.startStage ?? 0;

    _overallController = AnimationController(
      duration: Duration(seconds: (_stages.length - _currentStage) * 3), // 3 seconds per stage
      vsync: this,
    );

    _overallAnimation = Tween<double>(
      begin: _currentStage > 0 ? _stages[_currentStage - 1].progress : 0.0,
      end: _stages.last.progress,
    ).animate(CurvedAnimation(
      parent: _overallController,
      curve: Curves.easeInOut,
    ));

    _overallAnimation.addListener(() {
      setState(() {
        _currentProgress = _overallAnimation.value;

        // Update current stage based on progress
        for (int i = _currentStage; i < _stages.length; i++) {
          if (_currentProgress >= _stages[i].progress - 0.01) {
            if (i != _currentStage) {
              _currentStage = i;
            }
          } else {
            break;
          }
        }
      });
    });

    _startProgressSequence();
  }

  void _startProgressSequence() async {
    await Future.delayed(const Duration(milliseconds: 500));
    await _overallController.forward();

    // All stages complete, navigate to next screen
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      Get.toNamed('/jumpstart');
    }
  }

  @override
  void dispose() {
    _overallController.dispose();
    super.dispose();
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
                percent: _currentProgress,
                size: 250,
                strokeWidth: 8,
                backgroundColor: AppColors.cardBackground,
                progressColor: AppColors.primary,
                animationDuration: const Duration(milliseconds: 300), // Smooth updates
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                _stages[_currentStage].message,
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

class ProgressStage {
  final double progress;
  final String message;

  const ProgressStage({
    required this.progress,
    required this.message,
  });
}

// Specific progress screens - now all use the same unified view
class Setup18View extends StatelessWidget {
  const Setup18View({super.key});

  @override
  Widget build(BuildContext context) {
    return const SetupProgressView(startStage: 0);
  }
}

class Setup59View extends StatelessWidget {
  const Setup59View({super.key});

  @override
  Widget build(BuildContext context) {
    return const SetupProgressView(startStage: 1);
  }
}

class Setup73View extends StatelessWidget {
  const Setup73View({super.key});

  @override
  Widget build(BuildContext context) {
    return const SetupProgressView(startStage: 2);
  }
}

class Setup87View extends StatelessWidget {
  const Setup87View({super.key});

  @override
  Widget build(BuildContext context) {
    return const SetupProgressView(startStage: 3);
  }
}
