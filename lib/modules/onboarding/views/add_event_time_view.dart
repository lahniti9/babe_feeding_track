import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../core/widgets/bc_scaffold.dart';
import '../../../core/widgets/segment_header.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../routes/app_routes.dart';
import '../controllers/onboarding_controller.dart';

class AddEventTimeView extends StatefulWidget {
  const AddEventTimeView({super.key});

  @override
  State<AddEventTimeView> createState() => _AddEventTimeViewState();
}

class _AddEventTimeViewState extends State<AddEventTimeView> {
  DateTime selectedDateTime = DateTime.now();

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
                  const SegmentHeader(
                    title: "Now, add the event time",
                    padding: EdgeInsets.only(
                      top: AppSpacing.xxl,
                      bottom: AppSpacing.betweenSections,
                    ),
                  ),
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                    ),
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.dateAndTime,
                      initialDateTime: selectedDateTime,
                      maximumDate: DateTime.now(),
                      minimumDate: DateTime.now().subtract(const Duration(days: 7)),
                      onDateTimeChanged: (DateTime newDateTime) {
                        setState(() {
                          selectedDateTime = newDateTime;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: PrimaryButton(
              label: "Done",
              onTap: () {
                controller.saveAnswer('recent_event_time', selectedDateTime);
                Get.toNamed(Routes.wellDone);
              },
            ),
          ),
        ],
      ),
    );
  }
}
