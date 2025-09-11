import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart';

class RoundTimerButton extends StatelessWidget {
  final double size;
  final bool running;
  final String timeText;
  final String label;
  final VoidCallback onTap;

  const RoundTimerButton({
    super.key,
    required this.size,
    required this.running,
    required this.timeText,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Timer button
        AnimatedContainer(
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeOut,
          width: size,
          height: size,
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const RadialGradient(
                  colors: [AppColors.softCoral, AppColors.coral],
                  center: Alignment.center,
                  radius: 0.8,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      running ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                      size: size * 0.2,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      timeText,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: size * 0.08,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Label
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        
        // "Last" indicator when running
        if (running) ...[
          const SizedBox(height: 4),
          const Text(
            'Last',
            style: TextStyle(
              color: Color(0xFFBDBDBD),
              fontSize: 14,
            ),
          ),
        ],
      ],
    );
  }
}
