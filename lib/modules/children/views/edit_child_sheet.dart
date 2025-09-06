import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/edit_child_controller.dart';
import '../models/child_profile.dart';
import '../widgets/shared_components.dart';
import '../utils/helpers.dart';

class EditChildSheet extends StatelessWidget {
  final ChildProfile profile;
  
  const EditChildSheet({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(EditChildController(profile));
    
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      child: BottomShell(
        title: 'Settings',
        right: IconButton(
          icon: const Icon(Icons.check, color: Colors.white),
          onPressed: c.save,
        ),
        child: Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AvatarPicker(
              value: c.avatar.value,
              onPick: (p) => c.avatar.value = p,
            ),
            const SizedBox(height: 18),
            ValueRow(
              label: "Baby's name",
              value: c.name.value,
              onTap: () async {
                final s = await inputText(context, 'Baby\'s name', c.name.value);
                if (s != null) c.name.value = s;
              },
            ),
            DateRow(
              label: 'Date of birth',
              value: c.birth.value,
              onTap: () async {
                final d = await pickDate(context, c.birth.value);
                if (d != null) c.birth.value = d;
              },
            ),
            const SizedBox(height: 10),
            GenderSegmented(
              value: c.gender.value,
              onChanged: (g) => c.gender.value = g,
            ),
            const Spacer(),
            DestructiveButton(
              label: "Remove the baby's profile",
              onTap: () => confirmDelete(context, onYes: c.deleteProfile),
            ),
          ],
        )),
      ),
    );
  }
}
