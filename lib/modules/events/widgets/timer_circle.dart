import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart';

class TimerCircle extends StatefulWidget {
  final bool isRunning;
  final String timeText;
  final VoidCallback onToggle;
  final Color gradientStart;
  final Color gradientEnd;
  final double size;

  const TimerCircle({
    super.key,
    required this.isRunning,
    required this.timeText,
    required this.onToggle,
    this.gradientStart = AppColors.softCoral,
    this.gradientEnd = AppColors.coral,
    this.size = 280.0,
  });

  @override
  State<TimerCircle> createState() => _TimerCircleState();
}

class _TimerCircleState extends State<TimerCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _animationController.forward(),
      onTapUp: (_) => _animationController.reverse(),
      onTapCancel: () => _animationController.reverse(),
      onTap: widget.onToggle,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [widget.gradientStart, widget.gradientEnd],
                  center: Alignment.center,
                  radius: 0.8,
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.gradientEnd.withValues(alpha: 0.4),
                    blurRadius: widget.isRunning ? 20 : 12,
                    offset: const Offset(0, 6),
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Pulse effect when running
                  if (widget.isRunning)
                    Positioned.fill(
                      child: AnimatedBuilder(
                        animation: _pulseAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _pulseAnimation.value,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.3),
                                  width: 2,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                  // Main content
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.2),
                          ),
                          child: Icon(
                            widget.isRunning ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                            size: widget.size * 0.12,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          widget.timeText,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: widget.size * 0.08,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.isRunning ? 'Tap to pause' : 'Tap to start',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: widget.size * 0.04,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
