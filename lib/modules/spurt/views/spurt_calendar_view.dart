import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/spurt_controller.dart';
import '../widgets/spurt_tile.dart';

class SpurtCalendarView extends StatelessWidget {
  const SpurtCalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SpurtController());

    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Dark background
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Main container
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1C1C1C), // Slightly lighter dark
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  // Title
                  const Center(
                    child: Text(
                      'Wonder Weeks Calendar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Legend
                  _buildLegend(),

                  const SizedBox(height: 20),

                  // Enhanced Grid with better week selection
                  _buildEnhancedGrid(controller),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }



  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem(
          color: const Color(0xFFFF6B6B), // Coral
          label: 'Growth Leap',
        ),

        const SizedBox(width: 24),

        _buildLegendItem(
          color: const Color(0xFF28C076), // Green
          label: 'Fussy Phase',
        ),
      ],
    );
  }

  Widget _buildLegendItem({required Color color, required String label}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        
        const SizedBox(width: 8),
        
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFCFCFCF), // Light grey
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildEnhancedGrid(SpurtController controller) {
    return Obx(() {
      // Access reactive properties to ensure GetX tracks them
      controller.dueDate.value; // Trigger reactivity
      controller.episodes.length; // Trigger reactivity

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.05, // Slightly taller than wide
        ),
        itemCount: controller.totalWeeks,
        itemBuilder: (context, index) {
          final week = index + 1;
          final episode = controller.episodeForWeek(week);
          final isCurrent = controller.isCurrentWeek(week);
          final range = controller.rangeLabel(week);
          final weekStatus = controller.getWeekStatus(week);

          return SpurtTile(
            week: week,
            episode: episode,
            isCurrent: isCurrent,
            range: range,
            weekStatus: weekStatus,
          );
        },
      );
    });
  }
}
