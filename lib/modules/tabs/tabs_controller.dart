import 'package:get/get.dart';

enum TabIndex { events, statistics, spurtCalendar, children, settings }

class TabsController extends GetxController {
  // Current tab index
  final _currentIndex = TabIndex.events.obs;
  TabIndex get currentIndex => _currentIndex.value;
  int get currentIndexValue => _currentIndex.value.index;
  
  // Tab labels
  final List<String> tabLabels = [
    'Events',
    'Statistics',
    'Spurts',
    'Naji',
    'Settings',
  ];
  
  // Tab icons
  final List<String> tabIcons = [
    'timeline',
    'bar_chart',
    'calendar_month',
    'child_care',
    'settings',
  ];
  
  // Change tab
  void changeTab(int index) {
    if (index >= 0 && index < TabIndex.values.length) {
      _currentIndex.value = TabIndex.values[index];
    }
  }
  
  void changeTabByEnum(TabIndex tab) {
    _currentIndex.value = tab;
  }
  
  // Navigate to specific tabs
  void goToEvents() => changeTabByEnum(TabIndex.events);
  void goToStatistics() => changeTabByEnum(TabIndex.statistics);
  void goToSpurtCalendar() => changeTabByEnum(TabIndex.spurtCalendar);
  void goToChildren() => changeTabByEnum(TabIndex.children);
  void goToSettings() => changeTabByEnum(TabIndex.settings);
  
  // Check if tab is active
  bool isTabActive(TabIndex tab) => _currentIndex.value == tab;
  bool isTabActiveByIndex(int index) => _currentIndex.value.index == index;
  
  // Get current tab label
  String get currentTabLabel => tabLabels[_currentIndex.value.index];
  
  // Get current tab icon
  String get currentTabIcon => tabIcons[_currentIndex.value.index];
}
