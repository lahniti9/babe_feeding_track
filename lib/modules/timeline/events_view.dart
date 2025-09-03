import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/text.dart';
import '../../core/widgets/bc_scaffold.dart';
import '../../data/models/event.dart';
import 'tracking_controller.dart';

class EventsView extends StatelessWidget {
  const EventsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TrackingController());
    
    return BCScaffold(
      showBack: false,
      body: Column(
        children: [
          // Quick action chips
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
              children: [
                _buildQuickActionChip("Sleeping", Icons.bed, () => _quickAddEvent(controller, EventType.sleeping)),
                _buildQuickActionChip("Bedtime routine", Icons.nightlight, () => _quickAddEvent(controller, EventType.sleeping)),
                _buildQuickActionChip("Bottle", Icons.local_drink, () => _quickAddEvent(controller, EventType.bottle)),
                _buildQuickActionChip("Diaper", Icons.baby_changing_station, () => _quickAddEvent(controller, EventType.diaper)),
                _buildQuickActionChip("Condition", Icons.mood, () => _quickAddEvent(controller, EventType.condition)),
                _buildQuickActionChip("Bathing", Icons.bathtub, () => _quickAddEvent(controller, EventType.bathing)),
              ],
            ),
          ),
          
          // Promo banner
          Container(
            margin: const EdgeInsets.all(AppSpacing.screenPadding),
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Track your baby's daily activities",
                        style: AppTextStyles.bodyLarge,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        "Keep a record of feeding, sleeping, and milestones",
                        style: AppTextStyles.subtitle,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.baby_changing_station,
                  color: AppColors.primary,
                  size: AppSpacing.iconLg,
                ),
              ],
            ),
          ),
          
          // Events list
          Expanded(
            child: Obx(() {
              if (controller.events.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.timeline,
                        size: 64,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        "No events yet",
                        style: AppTextStyles.titleMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        "Start tracking your baby's activities",
                        style: AppTextStyles.subtitle,
                      ),
                    ],
                  ),
                );
              }
              
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
                itemCount: controller.events.length,
                itemBuilder: (context, index) {
                  final event = controller.events[index];
                  return _buildEventCard(event);
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEventDialog(controller),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: AppColors.textPrimary),
      ),
    );
  }
  
  Widget _buildQuickActionChip(String label, IconData icon, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(right: AppSpacing.sm),
      child: ActionChip(
        onPressed: onTap,
        avatar: Icon(icon, size: 16, color: AppColors.textSecondary),
        label: Text(label, style: AppTextStyles.caption),
        backgroundColor: AppColors.cardBackground,
        side: BorderSide.none,
      ),
    );
  }
  
  Widget _buildEventCard(Event event) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppSpacing.sm),
            ),
            child: Icon(
              _getEventIcon(event.type),
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.typeDisplay,
                  style: AppTextStyles.bodyLarge,
                ),
                if (event.detailDisplay.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    event.detailDisplay,
                    style: AppTextStyles.subtitle,
                  ),
                ],
              ],
            ),
          ),
          Text(
            event.timeAgoDisplay,
            style: AppTextStyles.caption,
          ),
        ],
      ),
    );
  }
  
  IconData _getEventIcon(EventType type) {
    switch (type) {
      case EventType.sleeping:
        return Icons.bed;
      case EventType.feeding:
        return Icons.restaurant;
      case EventType.bottle:
        return Icons.local_drink;
      case EventType.diaper:
        return Icons.baby_changing_station;
      case EventType.condition:
        return Icons.mood;
      case EventType.bathing:
        return Icons.bathtub;
      case EventType.walking:
        return Icons.directions_walk;
      case EventType.weight:
        return Icons.monitor_weight;
      case EventType.height:
        return Icons.height;
      case EventType.headCircumference:
        return Icons.face;
      case EventType.milestone:
        return Icons.star;
      case EventType.note:
        return Icons.note;
    }
  }
  
  void _quickAddEvent(TrackingController controller, EventType type) {
    // For now, just add a simple event
    controller.addEvent(
      childId: 'default_child',
      type: type,
      detail: {'description': 'Quick added ${type.name}'},
    );
  }
  
  void _showAddEventDialog(TrackingController controller) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: Text('Add Event', style: AppTextStyles.titleMedium),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: EventType.values.map((type) => ListTile(
            leading: Icon(_getEventIcon(type), color: AppColors.primary),
            title: Text(type.name, style: AppTextStyles.bodyMedium),
            onTap: () {
              Get.back();
              _quickAddEvent(controller, type);
            },
          )).toList(),
        ),
      ),
    );
  }
}
