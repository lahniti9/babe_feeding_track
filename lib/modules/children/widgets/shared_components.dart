import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../models/child_profile.dart';

// Bottom sheet shell wrapper
class BottomShell extends StatelessWidget {
  final String title;
  final Widget? right;
  final Widget child;

  const BottomShell({
    super.key,
    required this.title,
    this.right,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1B1B1B),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Get.back(),
                  ),
                  Expanded(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  right ?? const SizedBox(width: 48),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }
}

// Gender selector row
class GenderRow extends StatelessWidget {
  final BabyGender value;
  final ValueChanged<BabyGender> onChanged;

  const GenderRow({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _GenderChip(
            gender: BabyGender.girl,
            selected: value == BabyGender.girl,
            onTap: () => onChanged(BabyGender.girl),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _GenderChip(
            gender: BabyGender.boy,
            selected: value == BabyGender.boy,
            onTap: () => onChanged(BabyGender.boy),
          ),
        ),
      ],
    );
  }
}

class _GenderChip extends StatelessWidget {
  final BabyGender gender;
  final bool selected;
  final VoidCallback onTap;

  const _GenderChip({
    required this.gender,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isGirl = gender == BabyGender.girl;
    final color = isGirl ? const Color(0xFFFF8266) : const Color(0xFF3AA3FF);
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: selected ? color : Colors.grey[800],
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: selected ? Colors.white : Colors.grey[600],
                shape: BoxShape.circle,
              ),
              child: Icon(
                isGirl ? Icons.female : Icons.male,
                size: 16,
                color: selected ? color : Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              isGirl ? 'A girl' : 'A boy',
              style: TextStyle(
                color: selected ? Colors.white : Colors.grey[400],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Gender segmented control
class GenderSegmented extends StatelessWidget {
  final BabyGender value;
  final ValueChanged<BabyGender> onChanged;

  const GenderSegmented({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: _SegmentButton(
              text: 'A boy',
              selected: value == BabyGender.boy,
              onTap: () => onChanged(BabyGender.boy),
            ),
          ),
          Expanded(
            child: _SegmentButton(
              text: 'A girl',
              selected: value == BabyGender.girl,
              onTap: () => onChanged(BabyGender.girl),
            ),
          ),
        ],
      ),
    );
  }
}

class _SegmentButton extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;

  const _SegmentButton({
    required this.text,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: selected ? Colors.black : Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

// Avatar picker (camera functionality removed)
class AvatarPicker extends StatelessWidget {
  final String? value;
  final ValueChanged<String?> onPick;

  const AvatarPicker({
    super.key,
    required this.value,
    required this.onPick,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 96,
        height: 96,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.grey[700]!,
              Colors.grey[800]!,
            ],
          ),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.2),
            width: 2,
          ),
        ),
        child: value != null
            ? ClipOval(
                child: Image.network(
                  value!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.person_rounded,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              )
            : const Icon(
                Icons.person_rounded,
                color: Colors.white,
                size: 40,
              ),
      ),
    );
  }
}

// Text field row
class TextFieldRow extends StatelessWidget {
  final String label;
  final RxString value;
  final String hint;

  const TextFieldRow({
    super.key,
    required this.label,
    required this.value,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          onChanged: (text) => value.value = text,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400]),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[600]!),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

// Date row
class DateRow extends StatelessWidget {
  final String label;
  final DateTime value;
  final VoidCallback onTap;

  const DateRow({
    super.key,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey[600]!),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              DateFormat('MMM d, yyyy').format(value),
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Value row (for settings)
class ValueRow extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const ValueRow({
    super.key,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey[600]!),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Primary bottom button
class PrimaryBottomButton extends StatelessWidget {
  final String label;
  final Color color;
  final bool enabled;
  final VoidCallback onTap;

  const PrimaryBottomButton({
    super.key,
    required this.label,
    required this.color,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: enabled ? onTap : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: enabled ? color : Colors.grey[600],
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// Destructive button
class DestructiveButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const DestructiveButton({
    super.key,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE53935),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.delete_outline, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
