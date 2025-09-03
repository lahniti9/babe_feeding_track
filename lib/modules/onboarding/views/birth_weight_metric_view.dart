import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../core/widgets/numeric_input_view.dart';
import '../../../core/widgets/metric_toggle.dart';
import '../../../data/models/weight.dart';
import '../../../routes/app_routes.dart';
import '../controllers/onboarding_controller.dart';

class BirthWeightMetricView extends StatefulWidget {
  const BirthWeightMetricView({super.key});

  @override
  State<BirthWeightMetricView> createState() => _BirthWeightMetricViewState();
}

class _BirthWeightMetricViewState extends State<BirthWeightMetricView> {
  final TextEditingController _controller = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    final controller = Get.find<OnboardingController>();
    if (controller.birthWeight != null) {
      _controller.text = controller.birthWeight!.grams.toString();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController>();

    return NumericInputView(
      title: "What was your baby's birth weight?",
      value: _controller.text,
      suffix: "grams",
      hint: "Enter weight in grams",
      showMetricToggle: true,
      metricSystem: controller.metricSystem,
      onMetricChanged: (system) {
        controller.setMetricSystem(system);
        if (system == MetricSystem.imperial) {
          Get.toNamed(Routes.birthWeightImperial);
        }
      },
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      onValueChanged: (value) {
        _controller.text = value;
        if (value.isNotEmpty) {
          final grams = int.tryParse(value);
          if (grams != null && grams > 0) {
            controller.setBirthWeight(Weight.fromGrams(grams));
          }
        }
      },
      onNext: () {
        final grams = int.tryParse(_controller.text);
        if (grams != null && grams > 0) {
          controller.setBirthWeight(Weight.fromGrams(grams));
          Get.toNamed(Routes.teammateName);
        }
      },
    );
  }
}
