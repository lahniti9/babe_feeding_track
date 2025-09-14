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
                // Enhanced header card
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF2A2A2A),
                        const Color(0xFF1A1A1A),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.1),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white.withValues(alpha: 0.15),
                                  Colors.white.withValues(alpha: 0.05),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.2),
                                width: 1,
                              ),
                            ),
                            child: const Icon(
                              Icons.family_restroom_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Children',
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  '${kids.length} ${kids.length == 1 ? 'child' : 'children'}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white.withValues(alpha: 0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 110,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: kids.length + 1,
                          separatorBuilder: (_, __) => const SizedBox(width: 16),
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

                // Enhanced info panel for active child
                if (active != null)
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFF1A1A1A),
                            const Color(0xFF2A2A2A).withValues(alpha: 0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.1),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header row
                            Row(
                              children: [
                                // Child info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        active.name,
                                        style: const TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: active.gender == BabyGender.girl
                                            ? const Color(0xFFFF8266).withValues(alpha: 0.2)
                                            : const Color(0xFF3AA3FF).withValues(alpha: 0.2),
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(
                                            color: active.gender == BabyGender.girl
                                              ? const Color(0xFFFF8266)
                                              : const Color(0xFF3AA3FF),
                                            width: 1,
                                          ),
                                        ),
                                        child: Text(
                                          active.gender == BabyGender.girl ? 'Girl' : 'Boy',
                                          style: TextStyle(
                                            color: active.gender == BabyGender.girl
                                              ? const Color(0xFFFF8266)
                                              : const Color(0xFF3AA3FF),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Settings button
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: Colors.white.withValues(alpha: 0.2),
                                      width: 1,
                                    ),
                                  ),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.settings_rounded,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                    onPressed: () => _openEditChild(active),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),

                            // Age info
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.05),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.1),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.cake_rounded,
                                    color: Colors.white.withValues(alpha: 0.7),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Age',
                                          style: TextStyle(
                                            color: Colors.white.withValues(alpha: 0.7),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          active.ageDisplay,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
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
