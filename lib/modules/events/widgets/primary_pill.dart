import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart';

class PrimaryPill extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color? color;
  final IconData? icon;
  final bool enabled;

  const PrimaryPill({
    super.key,
    required this.label,
    required this.onTap,
    this.color,
    this.icon,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = enabled
        ? (color ?? AppColors.coral)
        : AppColors.cardBackgroundSecondary;

    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        onTap: enabled ? onTap : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            gradient: enabled ? LinearGradient(
              colors: [
                effectiveColor,
                effectiveColor.withValues(alpha: 0.8),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ) : null,
            color: enabled ? null : AppColors.cardBackgroundSecondary,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: enabled
                ? effectiveColor.withValues(alpha: 0.3)
                : AppColors.textSecondary.withValues(alpha: 0.2),
              width: 1,
            ),
            boxShadow: enabled ? [
              BoxShadow(
                color: effectiveColor.withValues(alpha: 0.4),
                blurRadius: 16,
                offset: const Offset(0, 8),
                spreadRadius: 0,
              ),
              BoxShadow(
                color: effectiveColor.withValues(alpha: 0.2),
                blurRadius: 32,
                offset: const Offset(0, 16),
                spreadRadius: 0,
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ] : [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  color: enabled ? Colors.white : AppColors.textSecondary,
                  size: 20,
                ),
                const SizedBox(width: 12),
              ],
              Text(
                label,
                style: TextStyle(
                  color: enabled ? Colors.white : AppColors.textSecondary,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SecondaryPill extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final IconData? icon;

  const SecondaryPill({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF2E2E2E),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white, size: 16),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
