import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../models/spurt_models.dart';
import '../views/spurt_detail_view.dart';

class SpurtTile extends StatefulWidget {
  final int week;
  final SpurtEpisode? episode;
  final bool isCurrent;
  final String range;
  final WeekStatus? weekStatus;

  const SpurtTile({
    super.key,
    required this.week,
    required this.episode,
    required this.isCurrent,
    required this.range,
    this.weekStatus,
  });

  @override
  State<SpurtTile> createState() => _SpurtTileState();
}

class _SpurtTileState extends State<SpurtTile> with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  late AnimationController _borderAnimationController;
  late Animation<double> _borderAnimation;

  @override
  void initState() {
    super.initState();
    _borderAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _borderAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _borderAnimationController,
      curve: Curves.easeInOut,
    ));

    if (widget.isCurrent) {
      _borderAnimationController.forward();
    }
  }

  @override
  void didUpdateWidget(SpurtTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isCurrent != oldWidget.isCurrent) {
      if (widget.isCurrent) {
        _borderAnimationController.forward();
      } else {
        _borderAnimationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _borderAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = switch (widget.episode?.type) {
      SpurtType.leap => const Color(0xFFFF6B6B), // Coral
      SpurtType.fussy => const Color(0xFF28C076), // Green
      _ => _getWeekStatusColor(), // Use status-based color for normal weeks
    };

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.episode == null ? null : () => _handleTap(),
      child: AnimatedBuilder(
        animation: _borderAnimation,
        builder: (context, child) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            transform: Matrix4.identity()
              ..scale(_isPressed ? 0.95 : (widget.isCurrent ? 1.02 : 1.0)),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(widget.isCurrent ? 18 : 16),
              border: _getAnimatedBorder(),
              boxShadow: _getCurrentWeekShadow(),
            ),
        padding: const EdgeInsets.all(12),
        child: Stack(
          children: [
            // Week number (top-left)
            Align(
              alignment: Alignment.topLeft,
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  fontSize: widget.isCurrent ? 22 : 20,
                  fontWeight: widget.isCurrent ? FontWeight.w800 : FontWeight.w700,
                  color: Colors.white,
                  shadows: widget.isCurrent ? [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ] : null,
                ),
                child: Text('${widget.week}'),
              ),
            ),

            // Enhanced click indicator (top-right) - only if episode exists
            if (widget.episode != null)
              Positioned(
                top: 8,
                right: 8,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 24,
                  width: 24,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.4),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.1),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.touch_app,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ),

            // Date range (bottom-left)
            Align(
              alignment: Alignment.bottomLeft,
              child: Opacity(
                opacity: 0.85,
                child: Text(
                  widget.range,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
          );
        },
      ),
    );
  }

  Color _getWeekStatusColor() {
    return switch (widget.weekStatus) {
      WeekStatus.current => const Color(0xFF2A2A2A), // Slightly lighter for current
      WeekStatus.upcoming => const Color(0xFF252525), // Slightly highlighted
      WeekStatus.recent => const Color(0xFF202020), // Slightly dimmed
      WeekStatus.past => const Color(0xFF1A1A1A), // Darker for past
      WeekStatus.future => const Color(0xFF151515), // Darkest for future
      _ => const Color(0xFF1A1A1A), // Default
    };
  }

  Border? _getAnimatedBorder() {
    if (widget.isCurrent) {
      final animatedOpacity = 0.5 + (_borderAnimation.value * 0.5); // 0.5 to 1.0
      final animatedWidth = 2.0 + (_borderAnimation.value * 1.0); // 2.0 to 3.0
      return Border.all(
        color: Colors.white.withValues(alpha: animatedOpacity),
        width: animatedWidth,
      );
    }

    return switch (widget.weekStatus) {
      WeekStatus.current => Border.all(color: Colors.white.withValues(alpha: 0.6), width: 3),
      WeekStatus.upcoming => Border.all(color: const Color(0xFFFF6B6B).withValues(alpha: 0.4), width: 2),
      WeekStatus.recent => Border.all(color: Colors.grey.withValues(alpha: 0.3), width: 1),
      _ => widget.episode != null
          ? Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1)
          : null,
    };
  }

  List<BoxShadow>? _getCurrentWeekShadow() {
    if (widget.weekStatus == WeekStatus.current || widget.isCurrent) {
      return [
        // Inner glow
        BoxShadow(
          color: Colors.white.withValues(alpha: 0.3),
          blurRadius: 6,
          spreadRadius: 1,
          offset: const Offset(0, 0),
        ),
        // Outer glow
        BoxShadow(
          color: Colors.white.withValues(alpha: 0.15),
          blurRadius: 12,
          spreadRadius: 3,
          offset: const Offset(0, 2),
        ),
        // Subtle depth
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.2),
          blurRadius: 8,
          spreadRadius: 0,
          offset: const Offset(0, 4),
        ),
      ];
    }

    // Add subtle shadow for episode tiles
    if (widget.episode != null) {
      return [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: 4,
          spreadRadius: 0,
          offset: const Offset(0, 2),
        ),
      ];
    }

    return null;
  }

  void _handleTap() {
    // Add haptic feedback for better user experience
    HapticFeedback.lightImpact();

    // Navigate to detail view
    Get.to(() => SpurtDetailView(week: widget.week));
  }
}


