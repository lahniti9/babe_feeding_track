import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/text.dart';

class NumberRow extends StatelessWidget {
  final String label;
  final double value;
  final String unit;
  final Function(double) onChange;
  final Function(String)? onUnitChange;
  final List<String>? unitOptions;
  final double? min;
  final double? max;
  final int decimals;

  const NumberRow({
    super.key,
    required this.label,
    required this.value,
    required this.unit,
    required this.onChange,
    this.onUnitChange,
    this.unitOptions,
    this.min,
    this.max,
    this.decimals = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          
          Row(
            children: [
              // Number input
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E2E2E),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextFormField(
                    initialValue: value.toStringAsFixed(decimals),
                    keyboardType: TextInputType.numberWithOptions(decimal: decimals > 0),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                    ],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '0',
                      hintStyle: TextStyle(
                        color: Color(0xFF5B5B5B),
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onChanged: (text) {
                      final newValue = double.tryParse(text) ?? 0.0;
                      if (min != null && newValue < min!) return;
                      if (max != null && newValue > max!) return;
                      onChange(newValue);
                    },
                  ),
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Unit selector or display
              if (unitOptions != null && onUnitChange != null)
                Expanded(
                  child: GestureDetector(
                    onTap: () => _showUnitPicker(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2E2E2E),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFFF8A00), width: 1),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              unit,
                              style: const TextStyle(
                                color: Color(0xFFFF8A00),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.keyboard_arrow_down,
                            color: Color(0xFFFF8A00),
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                Text(
                  unit,
                  style: const TextStyle(
                    color: Color(0xFFFF8A00),
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _showUnitPicker(BuildContext context) {
    if (unitOptions == null || onUnitChange == null) return;
    
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF151515),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Unit',
              style: AppTextStyles.titleMedium.copyWith(color: Colors.white),
            ),
            const SizedBox(height: AppSpacing.lg),
            ...unitOptions!.map((option) => ListTile(
              title: Text(
                option,
                style: TextStyle(
                  color: option == unit ? const Color(0xFFFF8A00) : Colors.white,
                  fontWeight: option == unit ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
              onTap: () {
                onUnitChange!(option);
                Navigator.pop(context);
              },
            )),
          ],
        ),
      ),
    );
  }
}
