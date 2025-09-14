import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/add_child_controller.dart';
import '../models/child_profile.dart';
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
            // Gender selection with validation indicator
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Gender',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      '*',
                      style: TextStyle(
                        color: Color(0xFFFF6B6B),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                GenderRow(
                  value: c.gender.value ?? BabyGender.girl,
                  onChanged: (g) => c.gender.value = g,
                ),
              ],
            ),
            const SizedBox(height: 20),
            AvatarPicker(
              value: c.avatar.value,
              onPick: (p) => c.avatar.value = p,
            ),
            const SizedBox(height: 20),
            // Name field with validation indicator
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      "Baby's name",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      '*',
                      style: TextStyle(
                        color: Color(0xFFFF6B6B),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextField(
                  onChanged: (text) => c.name.value = text,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Enter your baby's name",
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[600]!),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
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
              label: c.canSubmit ? 'Add Child' : 'Please fill required fields',
              color: c.canSubmit ? const Color(0xFF10B981) : const Color(0xFF6B7280),
              enabled: c.canSubmit,
              onTap: c.submit,
            ),
          ],
        )),
      ),
    );
  }
}
