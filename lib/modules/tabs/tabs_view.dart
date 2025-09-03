import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/text.dart';
import '../timeline/events_view.dart';
import '../stats/statistics_view.dart';
import '../spurt_calendar/spurt_calendar_view.dart';
import '../children/children_view.dart';
import '../profile/settings_view.dart';
import 'tabs_controller.dart';

class TabsView extends StatelessWidget {
  const TabsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TabsController());
    
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        switch (controller.currentIndex) {
          case TabIndex.events:
            return const EventsView();
          case TabIndex.statistics:
            return const StatisticsView();
          case TabIndex.spurtCalendar:
            return const SpurtCalendarView();
          case TabIndex.children:
            return const ChildrenView();
          case TabIndex.settings:
            return const SettingsView();
        }
      }),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.background,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        selectedLabelStyle: AppTextStyles.tabLabel,
        unselectedLabelStyle: AppTextStyles.tabLabel,
        currentIndex: controller.currentIndexValue,
        onTap: controller.changeTab,
        items: [
          BottomNavigationBarItem(
            icon: Icon(_getIconData('timeline')),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(_getIconData('bar_chart')),
            label: 'Statistics',
          ),
          BottomNavigationBarItem(
            icon: Icon(_getIconData('calendar_month')),
            label: 'Spurt Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(_getIconData('child_care')),
            label: 'Naji',
          ),
          BottomNavigationBarItem(
            icon: Icon(_getIconData('settings')),
            label: 'Settings',
          ),
        ],
      )),
    );
  }
  
  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'timeline':
        return Icons.timeline;
      case 'bar_chart':
        return Icons.bar_chart;
      case 'calendar_month':
        return Icons.calendar_month;
      case 'child_care':
        return Icons.child_care;
      case 'settings':
        return Icons.settings;
      default:
        return Icons.help;
    }
  }
}
