import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/add_child_controller.dart';
import '../widgets/shared_components.dart';
import '../utils/helpers.dart';

class AddChildSheet extends StatelessWidget {
  const AddChildSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(AddChildController());
    
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.9,
      child: BottomShell(
        title: 'Add child',
        right: const SizedBox.shrink(),
        child: Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GenderRow(
              value: c.gender.value,
              onChanged: (g) => c.gender.value = g,
            ),
            const SizedBox(height: 14),
            AvatarPicker(
              value: c.avatar.value,
              onPick: (p) => c.avatar.value = p,
            ),
            const SizedBox(height: 18),
            TextFieldRow(
              label: "Baby's name",
              value: c.name,
              hint: "Baby's name",
            ),
            const SizedBox(height: 18),
            DateRow(
              label: 'Date of birth',
              value: c.birth.value,
              onTap: () async {
                final d = await pickDate(context, c.birth.value);
                if (d != null) c.birth.value = d;
              },
            ),
            const Spacer(),
            PrimaryBottomButton(
              label: 'Forward!',
              color: const Color(0xFF2E7D32),
              enabled: c.canSubmit,
              onTap: c.submit,
            ),
          ],
        )),
      ),
    );
  }
}
