import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/chart_scaffold.dart';
import '../controllers/monthly_overview_controller.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/text.dart';

class MonthlyOverviewView extends StatelessWidget {
  final String childId;

  const MonthlyOverviewView({
    super.key,
    required this.childId,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MonthlyOverviewController(childId: childId));

    return Obx(() => ChartScaffold(
          title: 'Monthly Overview',
          body: controller.isLoading
              ? const Center(child: CircularProgressIndicator())
              : _buildContent(controller),
        ));
  }

  Widget _buildContent(MonthlyOverviewController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter chips
          _buildFilterChips(controller),
          const SizedBox(height: AppSpacing.xl),
          
          // Monthly grid
          _buildMonthlyGrid(controller),
        ],
      ),
    );
  }

  Widget _buildFilterChips(MonthlyOverviewController controller) {
    return Wrap(
      spacing: AppSpacing.sm,
      children: controller.availableFilters.map((filter) {
        final isSelected = controller.selectedFilters.contains(filter);
        return FilterChip(
          label: Text(filter),
          selected: isSelected,
          onSelected: (selected) => controller.toggleFilter(filter),
          backgroundColor: AppColors.cardBackground,
          selectedColor: AppColors.primary.withValues(alpha: 0.2),
          checkmarkColor: AppColors.primary,
          labelStyle: TextStyle(
            color: isSelected ? AppColors.primary : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMonthlyGrid(MonthlyOverviewController controller) {
    final daysInMonth = controller.daysInCurrentMonth;
    
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Month header
          Text(
            controller.monthYearDisplay,
            style: AppTextStyles.h4,
          ),
          const SizedBox(height: AppSpacing.lg),
          
          // Days grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1.0,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemCount: daysInMonth,
            itemBuilder: (context, index) {
              final day = index + 1;
              final dayEvents = controller.getEventsForDay(day);
              
              return _buildDayCell(day, dayEvents, controller);
            },
          ),
          
          // Legend
          const SizedBox(height: AppSpacing.lg),
          _buildLegend(controller),
        ],
      ),
    );
  }

  Widget _buildDayCell(int day, List<String> events, MonthlyOverviewController controller) {
    final hasEvents = events.isNotEmpty;
    final isToday = controller.isToday(day);
    
    return Container(
      decoration: BoxDecoration(
        color: isToday 
            ? AppColors.primary.withValues(alpha: 0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(4),
        border: isToday 
            ? Border.all(color: AppColors.primary, width: 1)
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Day number
          Text(
            day.toString(),
            style: AppTextStyles.caption.copyWith(
              color: isToday ? AppColors.primary : AppColors.textPrimary,
              fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          
          // Event indicators
          if (hasEvents) ...[
            const SizedBox(height: 2),
            Wrap(
              spacing: 1,
              runSpacing: 1,
              children: events.take(3).map((eventType) {
                return Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: _getEventColor(eventType),
                    shape: BoxShape.circle,
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLegend(MonthlyOverviewController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildLegendItem('Bottle', AppColors.coral),
        _buildLegendItem('Daytime sleep', Colors.purple),
        _buildLegendItem('All events', Colors.blue),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Color _getEventColor(String eventType) {
    switch (eventType) {
      case 'Bottle':
        return AppColors.coral;
      case 'Daytime sleep':
        return Colors.purple;
      default:
        return Colors.blue;
    }
  }
}
