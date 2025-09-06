import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'services/children_store.dart';
import 'models/child_profile.dart';
import 'views/add_child_sheet.dart';
import 'views/edit_child_sheet.dart';
import 'widgets/child_avatar.dart';
import 'widgets/more_avatar.dart';

class ChildrenView extends StatelessWidget {
  const ChildrenView({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Get.find<ChildrenStore>();

    return Obx(() {
      final kids = store.children;
      final active = store.active;

      return Scaffold(
        backgroundColor: const Color(0xFF121212),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                // Header card
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                  child: Column(
                    children: [
                      const Text(
                        'Children',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 110,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: kids.length + 1,
                          separatorBuilder: (_, __) => const SizedBox(width: 14),
                          itemBuilder: (_, i) {
                            if (i == kids.length) {
                              return MoreAvatar(onTap: () => _openAddChild());
                            }
                            final c = kids[i];
                            final isActive = c.id == store.activeId.value;
                            return ChildAvatar(
                              profile: c,
                              active: isActive,
                              onTap: () => store.setActive(c.id),
                              onLongPress: () => _openEditChild(c),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // Info panel for active child
                if (active != null)
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(
                              active.gender == BabyGender.girl ? 'A girl' : 'A boy',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            subtitle: const Text(
                              'Today',
                              style: TextStyle(color: Colors.grey),
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.settings_outlined,
                                color: Colors.white,
                              ),
                              onPressed: () => _openEditChild(active),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Relatives',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          ListTile(
                            leading: const Icon(
                              Icons.circle,
                              color: Color(0xFF2AC06A),
                              size: 14,
                            ),
                            title: const Text(
                              'iPhone',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),

        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFFFFA629),
          onPressed: () { /* your global + action */ },
          child: const Icon(Icons.add, color: Colors.white),
        ),
      );
    });
  }

  void _openAddChild() => Get.bottomSheet(
    const AddChildSheet(),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
  );

  void _openEditChild(ChildProfile c) => Get.bottomSheet(
    EditChildSheet(profile: c),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
  );
}
