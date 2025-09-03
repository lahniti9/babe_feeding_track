import 'package:flutter/material.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/text.dart';
import '../../core/widgets/bc_scaffold.dart';

enum CalendarCellType { growthLeap, fussyPhase, inactive, normal }

class CalendarCell {
  final int day;
  final CalendarCellType type;
  final String? tag;
  final bool hasArrow;

  const CalendarCell({
    required this.day,
    this.type = CalendarCellType.normal,
    this.tag,
    this.hasArrow = false,
  });
}

class SpurtCalendarView extends StatelessWidget {
  const SpurtCalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    return BCScaffold(
      title: "Spurt Calendar",
      showBack: false,
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Legend
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Legend",
                    style: AppTextStyles.bodyLarge,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      _buildLegendItem(AppColors.growthLeap, "Growth Leap"),
                      const SizedBox(width: AppSpacing.lg),
                      _buildLegendItem(AppColors.fussyPhase, "Fussy Phase"),
                      const SizedBox(width: AppSpacing.lg),
                      _buildLegendItem(AppColors.inactive, "Inactive"),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: AppSpacing.lg),
            
            // Calendar grid
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                ),
                child: Column(
                  children: [
                    // Month header
                    Text(
                      "March 2025",
                      style: AppTextStyles.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    
                    // Weekday headers
                    Row(
                      children: ['S', 'M', 'T', 'W', 'T', 'F', 'S']
                          .map((day) => Expanded(
                                child: Center(
                                  child: Text(
                                    day,
                                    style: AppTextStyles.caption,
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                    
                    const SizedBox(height: AppSpacing.md),
                    
                    // Calendar grid
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 7,
                          childAspectRatio: 1.0,
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 4,
                        ),
                        itemCount: 42, // 6 weeks
                        itemBuilder: (context, index) {
                          return _buildCalendarCell(_generateCalendarCell(index));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildLegendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          label,
          style: AppTextStyles.caption,
        ),
      ],
    );
  }
  
  Widget _buildCalendarCell(CalendarCell cell) {
    Color backgroundColor;
    switch (cell.type) {
      case CalendarCellType.growthLeap:
        backgroundColor = AppColors.growthLeap;
        break;
      case CalendarCellType.fussyPhase:
        backgroundColor = AppColors.fussyPhase;
        break;
      case CalendarCellType.inactive:
        backgroundColor = AppColors.inactive;
        break;
      case CalendarCellType.normal:
        backgroundColor = AppColors.cardBackgroundSecondary;
        break;
    }
    
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppSpacing.xs),
      ),
      child: Stack(
        children: [
          // Tag in top corner
          if (cell.tag != null)
            Positioned(
              top: 2,
              left: 2,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.textPrimary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    cell.tag!,
                    style: const TextStyle(
                      fontSize: 6,
                      color: AppColors.background,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          
          // Day number
          Center(
            child: Text(
              cell.day > 0 ? cell.day.toString() : '',
              style: AppTextStyles.bodyMedium.copyWith(
                color: cell.type == CalendarCellType.inactive 
                    ? AppColors.textCaption 
                    : AppColors.textPrimary,
              ),
            ),
          ),
          
          // Arrow indicator
          if (cell.hasArrow)
            Positioned(
              bottom: 2,
              right: 2,
              child: Icon(
                Icons.arrow_forward_ios,
                size: 8,
                color: AppColors.textPrimary,
              ),
            ),
        ],
      ),
    );
  }
  
  CalendarCell _generateCalendarCell(int index) {
    // Generate sample calendar data
    final day = index - 6; // Start from previous month
    
    if (day <= 0 || day > 31) {
      return CalendarCell(day: day <= 0 ? 30 + day : day - 31, type: CalendarCellType.inactive);
    }
    
    // Sample growth spurts and fussy phases
    if ([5, 12, 19, 26].contains(day)) {
      return CalendarCell(
        day: day,
        type: CalendarCellType.growthLeap,
        tag: 'G',
        hasArrow: day == 19,
      );
    }
    
    if ([8, 15, 22, 29].contains(day)) {
      return CalendarCell(
        day: day,
        type: CalendarCellType.fussyPhase,
        tag: 'F',
      );
    }
    
    return CalendarCell(day: day);
  }
}
