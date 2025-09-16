import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/chart_scaffold.dart';
import '../widgets/empty_chart.dart';
import '../controllers/health_diary_controller.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/text.dart';

class HealthDiaryView extends StatelessWidget {
  final String childId;

  const HealthDiaryView({
    super.key,
    required this.childId,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HealthDiaryController(childId: childId));

    return Obx(() => ChartScaffold(
          title: 'Health diary',
          body: controller.isLoading
              ? const Center(child: CircularProgressIndicator())
              : _buildContent(controller),
        ));
  }

  Widget _buildContent(HealthDiaryController controller) {
    final hasTemperatureData = controller.temperatureData.isNotEmpty;
    final hasMedicineData = controller.medicineData.isNotEmpty;
    final hasDoctorData = controller.doctorData.isNotEmpty;

    if (!hasTemperatureData && !hasMedicineData && !hasDoctorData) {
      return EmptyChart(
        icon: Icons.thermostat,
        label: 'Temperature',
        subtitle: 'No health data recorded yet',
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Temperature section
          if (hasTemperatureData) ...[
            _buildTemperatureChart(controller),
            const SizedBox(height: AppSpacing.xl),
          ] else ...[
            _buildEmptyTemperatureCard(),
            const SizedBox(height: AppSpacing.xl),
          ],

          // Health entries list
          _buildHealthEntriesList(controller),
        ],
      ),
    );
  }

  Widget _buildTemperatureChart(HealthDiaryController controller) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Temperature',
            style: AppTextStyles.h4,
          ),
          const SizedBox(height: AppSpacing.md),
          // Temperature chart would go here
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(AppSpacing.sm),
            ),
            child: const Center(
              child: Text(
                'Temperature Chart',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyTemperatureCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.thermostat,
              color: Colors.red,
              size: 30,
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Temperature',
                  style: AppTextStyles.bodyLarge,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'No temperature data recorded',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthEntriesList(HealthDiaryController controller) {
    return Column(
      children: [
        _buildHealthEntryRow(
          icon: Icons.medication,
          title: 'Medicine',
          subtitle: controller.medicineData.isNotEmpty
              ? '${controller.medicineData.length} entries'
              : 'No medicine records',
          onTap: () => _showComingSoon('Medicine'),
        ),
        const SizedBox(height: AppSpacing.md),
        _buildHealthEntryRow(
          icon: Icons.local_hospital,
          title: 'Doctor',
          subtitle: controller.doctorData.isNotEmpty
              ? '${controller.doctorData.length} visits'
              : 'No doctor visits',
          onTap: () => _showComingSoon('Doctor'),
        ),
        const SizedBox(height: AppSpacing.md),
        _buildHealthEntryRow(
          icon: Icons.description,
          title: 'Report for the doctor',
          subtitle: 'Generate health report',
          onTap: () => _generateHealthReport(),
        ),
      ],
    );
  }

  Widget _buildHealthEntryRow({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
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
                    icon,
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
                        title,
                        style: AppTextStyles.bodyLarge,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        subtitle,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                trailing ??
                    Icon(
                      Icons.chevron_right,
                      color: AppColors.textSecondary,
                      size: AppSpacing.iconMd,
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showComingSoon(String feature) {
    Get.snackbar(
      'Coming Soon',
      '$feature tracking will be available in a future update',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _generateHealthReport() {
    Get.snackbar(
      'Health Report',
      'Generating comprehensive health report for your doctor',
      backgroundColor: Colors.blue.withValues(alpha: 0.2),
      colorText: Colors.blue,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }
}
