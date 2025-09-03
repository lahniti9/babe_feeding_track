import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../core/widgets/bc_scaffold.dart';
import '../../../core/widgets/segment_header.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/metric_toggle.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/text.dart';
import '../../../data/models/weight.dart';
import '../../../routes/app_routes.dart';
import '../controllers/onboarding_controller.dart';

class BirthWeightImperialView extends StatefulWidget {
  const BirthWeightImperialView({super.key});

  @override
  State<BirthWeightImperialView> createState() => _BirthWeightImperialViewState();
}

class _BirthWeightImperialViewState extends State<BirthWeightImperialView> {
  final TextEditingController _poundsController = TextEditingController();
  final TextEditingController _ouncesController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    final controller = Get.find<OnboardingController>();
    if (controller.birthWeight != null) {
      final weight = controller.birthWeight!;
      _poundsController.text = weight.pounds.toString();
      _ouncesController.text = weight.ounces.toString();
    }
  }

  @override
  void dispose() {
    _poundsController.dispose();
    _ouncesController.dispose();
    super.dispose();
  }

  void _updateWeight() {
    final controller = Get.find<OnboardingController>();
    final pounds = int.tryParse(_poundsController.text) ?? 0;
    final ounces = int.tryParse(_ouncesController.text) ?? 0;
    
    if (pounds > 0 || ounces > 0) {
      controller.setBirthWeight(Weight.fromPoundsOunces(pounds, ounces));
    }
    setState(() {}); // Update button state
  }

  bool _hasValidInput() {
    final pounds = int.tryParse(_poundsController.text) ?? 0;
    final ounces = int.tryParse(_ouncesController.text) ?? 0;
    return pounds > 0 || ounces > 0;
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController>();
    
    return BCScaffold(
      showBack: true,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
              child: Column(
                children: [
                  SegmentHeader(
                    title: "What was your baby's birth weight?",
                    padding: const EdgeInsets.only(
                      top: AppSpacing.xxl,
                      bottom: AppSpacing.betweenSections,
                    ),
                  ),
                  
                  // Metric toggle
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      MetricToggle(
                        selectedSystem: controller.metricSystem,
                        onChanged: (system) {
                          controller.setMetricSystem(system);
                          if (system == MetricSystem.metric) {
                            Get.toNamed(Routes.birthWeightMetric);
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  
                  // Input fields
                  Row(
                    children: [
                      // Pounds input
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.cardBackground,
                            borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                            border: Border.all(
                              color: AppColors.border,
                              width: 1,
                            ),
                          ),
                          child: TextField(
                            controller: _poundsController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            style: AppTextStyles.input,
                            autofocus: true,
                            decoration: InputDecoration(
                              hintText: "Pounds",
                              hintStyle: AppTextStyles.subtitle,
                              suffixText: "lbs",
                              suffixStyle: AppTextStyles.subtitle,
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(AppSpacing.lg),
                            ),
                            onChanged: (value) => _updateWeight(),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      // Ounces input
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.cardBackground,
                            borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                            border: Border.all(
                              color: AppColors.border,
                              width: 1,
                            ),
                          ),
                          child: TextField(
                            controller: _ouncesController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            style: AppTextStyles.input,
                            decoration: InputDecoration(
                              hintText: "Ounces",
                              hintStyle: AppTextStyles.subtitle,
                              suffixText: "oz",
                              suffixStyle: AppTextStyles.subtitle,
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(AppSpacing.lg),
                            ),
                            onChanged: (value) => _updateWeight(),
                          ),
                        ),
                      ),
                    ],
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
                label: "Next",
                onTap: _hasValidInput() ? () => Get.toNamed(Routes.teammateName) : null,
                isEnabled: _hasValidInput(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
