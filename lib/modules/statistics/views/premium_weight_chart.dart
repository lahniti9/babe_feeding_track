import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../controllers/weight_stats_controller.dart';
import '../widgets/chart_card.dart';
import '../../events/views/weight_sheet.dart';

/// Premium weight chart screen with all UX enhancements
class PremiumWeightChart extends StatefulWidget {
  final String childId;

  const PremiumWeightChart({
    super.key,
    required this.childId,
  });

  @override
  State<PremiumWeightChart> createState() => _PremiumWeightChartState();
}

class _PremiumWeightChartState extends State<PremiumWeightChart>
    with SingleTickerProviderStateMixin {
  late WeightStatsController controller;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  final _storage = GetStorage();
  final RxInt _selectedRange = 2.obs; // Default to 30D
  final RxBool _useImperial = false.obs;

  @override
  void initState() {
    super.initState();
    controller = Get.put(WeightStatsController(childId: widget.childId));
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    
    // Load persisted preferences
    _selectedRange.value = _storage.read('weight_range_${widget.childId}') ?? 2;
    _useImperial.value = _storage.read('weight_imperial_${widget.childId}') ?? false;
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0B0F),
      appBar: AppBar(
        title: const Text(
          'Weight Progress',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareChart,
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Obx(() {
            if (controller.isLoading.value) {
              return Container(
                height: 400,
                decoration: BoxDecoration(
                  color: const Color(0xFF1F2937),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF0891B2),
                  ),
                ),
              );
            }

            if (controller.points.isEmpty) {
              return Container(
                height: 400,
                decoration: BoxDecoration(
                  color: const Color(0xFF1F2937),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.monitor_weight,
                      size: 64,
                      color: Color(0xFF0891B2),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No Weight Data',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Start tracking your baby\'s weight',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF9CA3AF),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _openWeightSheet,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0891B2),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Add Weight'),
                    ),
                  ],
                ),
              );
            }

            return ChartCard(
              title: 'Weight Progress',
              chart: SizedBox(
                height: 280,
                child: controller.points.isEmpty
                  ? const Center(child: Text('No weight data available'))
                  : Container(
                      padding: const EdgeInsets.all(16),
                      child: const Center(child: Text('Weight Chart Placeholder')),
                    ),
              ),
              actions: const [],
              kpi: controller.points.isNotEmpty
                ? '${controller.points.last.value.toStringAsFixed(1)} kg'
                : null,
              isLoading: controller.isLoading.value,
              onRefresh: () {}, // TODO: Implement refresh
              accentColor: const Color(0xFF0891B2),
            );
          }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openWeightSheet,
        backgroundColor: const Color(0xFF0891B2),
        child: const Icon(Icons.add),
      ),
    );
  }

  List<Widget> _buildBadges() {
    if (controller.points.isEmpty) return [];

    final latest = controller.points.last.value;
    final latestText = _useImperial.value 
        ? '${(latest * 2.20462).toStringAsFixed(1)} lb'
        : '${latest.toStringAsFixed(1)} kg';

    final badges = <Widget>[
      MetricBadge(
        label: 'Latest',
        value: latestText,
        color: const Color(0xFF0891B2),
      ),
    ];

    if (controller.points.length > 1) {
      final previous = controller.points[controller.points.length - 2].value;
      final change = latest - previous;
      final changeText = _useImperial.value
          ? '${change >= 0 ? '+' : ''}${(change * 2.20462).toStringAsFixed(1)} lb'
          : '${change >= 0 ? '+' : ''}${change.toStringAsFixed(1)} kg';

      badges.add(
        MetricBadge(
          label: 'Change',
          value: changeText,
          color: change >= 0 ? const Color(0xFF10B981) : const Color(0xFFEF4444),
        ),
      );
    }

    if (controller.points.length > 2) {
      final avg = controller.points.map((e) => e.value).reduce((a, b) => a + b) / controller.points.length;
      final avgText = _useImperial.value
          ? '${(avg * 2.20462).toStringAsFixed(1)} lb'
          : '${avg.toStringAsFixed(1)} kg';

      badges.add(
        MetricBadge(
          label: 'Average',
          value: avgText,
          color: Colors.white.withValues(alpha: 0.7),
        ),
      );
    }

    return badges;
  }

  String _getRangeLabel() {
    switch (_selectedRange.value) {
      case 0: return 'Last 7 days';
      case 1: return 'Last 14 days';
      case 2: return 'Last 30 days';
      case 3: return 'Last 90 days';
      case 4: return 'Year to date';
      case 5: return 'Custom range';
      default: return 'Last 30 days';
    }
  }

  void _onRangeChanged(int index) {
    _selectedRange.value = index;
    _storage.write('weight_range_${widget.childId}', index);
    
    // Trigger smooth crossfade animation
    _animationController.reset();
    _animationController.forward();
    
    // TODO: Update controller data based on range
    // controller.updateRange(_getRangeDays(index));
  }

  int _getRangeDays(int index) {
    switch (index) {
      case 0: return 7;
      case 1: return 14;
      case 2: return 30;
      case 3: return 90;
      case 4: return 365;
      case 5: return 365; // Custom - would open date picker
      default: return 30;
    }
  }

  void _toggleUnits() {
    _useImperial.value = !_useImperial.value;
    _storage.write('weight_imperial_${widget.childId}', _useImperial.value);
  }

  void _onPointTap(DateTime date, double value) {
    // Show quick info
    Get.snackbar(
      'Weight Measurement',
      '${_formatDate(date)}: ${_formatWeight(value)}',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
      backgroundColor: const Color(0xFF0891B2).withValues(alpha: 0.9),
      colorText: Colors.white,
    );
  }

  void _onPointLongPress(DateTime date, double value) {
    // Open edit sheet for that measurement
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Color(0xFF111217),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Weight on ${_formatDate(date)}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _formatWeight(value),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0891B2),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                      _openWeightSheet(); // Open edit mode
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0891B2),
                    ),
                    child: const Text('Edit'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    child: const Text('Close'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                   'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}';
  }

  String _formatWeight(double value) {
    return _useImperial.value
        ? '${(value * 2.20462).toStringAsFixed(1)} lb'
        : '${value.toStringAsFixed(1)} kg';
  }

  void _openWeightSheet() {
    Get.bottomSheet(
      const WeightSheet(),
      isScrollControlled: true,
    );
  }

  void _shareChart() {
    // Implement chart sharing
    Get.snackbar(
      'Share Chart',
      'Chart sharing functionality would be implemented here',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
