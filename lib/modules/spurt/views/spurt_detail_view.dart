import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/colors.dart';
import '../controllers/spurt_controller.dart';
import '../widgets/section_card.dart';
import '../widgets/date_strip.dart';
import '../models/spurt_models.dart';

class SpurtDetailView extends StatelessWidget {
  final int week;

  const SpurtDetailView({
    super.key,
    required this.week,
  });

  @override
  Widget build(BuildContext context) {
    final parentController = Get.find<SpurtController>();
    final controller = Get.put(SpurtDetailController(
      week: week,
      parent: parentController,
    ));

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Header
            _buildHeader(controller),
            
            const SizedBox(height: 12),
            
            // Date strip
            _buildDateStrip(controller),
            
            const SizedBox(height: 24),
            
            // What's happening section
            _buildWhatsHappeningSection(controller),
            
            const SizedBox(height: 20),
            
            // Important period section
            _buildImportantPeriodSection(controller),
            
            const SizedBox(height: 32),
            
            // Got it button
            _buildGotItButton(controller),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(SpurtDetailController controller) {
    final accentColor = controller.episode.type == SpurtType.leap
        ? const Color(0xFFFF6B6B) // Coral
        : const Color(0xFF28C076); // Green

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Week label
        Text(
          'Week ${controller.week}',
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Title with colored number
        RichText(
          text: TextSpan(
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              height: 1.3,
            ),
            children: _buildTitleSpans(controller.titleLine, accentColor),
          ),
        ),
      ],
    );
  }

  List<TextSpan> _buildTitleSpans(String text, Color accentColor) {
    final spans = <TextSpan>[];
    final regex = RegExp(r'\d+');
    int lastEnd = 0;

    for (final match in regex.allMatches(text)) {
      // Add text before the number
      if (match.start > lastEnd) {
        spans.add(TextSpan(
          text: text.substring(lastEnd, match.start),
        ));
      }
      
      // Add the colored number
      spans.add(TextSpan(
        text: match.group(0),
        style: TextStyle(color: accentColor),
      ));
      
      lastEnd = match.end;
    }

    // Add remaining text
    if (lastEnd < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastEnd),
      ));
    }

    return spans;
  }

  Widget _buildDateStrip(SpurtDetailController controller) {
    final accentColor = controller.episode.type == SpurtType.leap
        ? const Color(0xFFFF6B6B) // Coral
        : const Color(0xFF28C076); // Green

    return DateStrip(
      prevDay: controller.dayPrev,
      currentDay: controller.dayCurr,
      nextDay: controller.dayNext,
      prevMonth: controller.monthPrev,
      currentMonth: controller.monthCurr,
      nextMonth: controller.monthNext,
      accentColor: accentColor,
    );
  }

  Widget _buildWhatsHappeningSection(SpurtDetailController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "What's happening with your baby",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        
        const SizedBox(height: 12),
        
        SectionCard(
          items: [
            SectionItem(
              icon: Icons.psychology,
              title: 'Behaviour changes',
              body: controller.content.behavior,
            ),
            SectionItem(
              icon: Icons.star,
              title: 'Skill development',
              body: controller.content.skill,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildImportantPeriodSection(SpurtDetailController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "During this period it is important",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        
        const SizedBox(height: 12),
        
        SectionCard(
          items: [
            SectionItem(
              icon: Icons.restaurant,
              title: 'Feeding',
              body: controller.content.feeding,
            ),
            SectionItem(
              icon: Icons.bedtime,
              title: 'Sleep',
              body: controller.content.sleep,
            ),
            SectionItem(
              icon: Icons.favorite,
              title: 'Communication',
              body: controller.content.communication,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGotItButton(SpurtDetailController controller) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: controller.onGotItTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.coral, // Coral
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Got it',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
