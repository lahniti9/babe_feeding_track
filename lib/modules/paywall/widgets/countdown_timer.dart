import 'package:flutter/material.dart';
import 'dart:async';
import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/text.dart';

class CountdownTimer extends StatefulWidget {
  final DateTime? deadline;

  const CountdownTimer({
    super.key,
    this.deadline,
  });

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  Timer? _timer;
  Duration _timeLeft = Duration.zero;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    if (widget.deadline == null) return;
    
    _updateTimeLeft();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTimeLeft();
    });
  }

  void _updateTimeLeft() {
    if (widget.deadline == null) return;
    
    final now = DateTime.now();
    final timeLeft = widget.deadline!.difference(now);
    
    if (timeLeft.isNegative) {
      setState(() {
        _timeLeft = Duration.zero;
      });
      _timer?.cancel();
    } else {
      setState(() {
        _timeLeft = timeLeft;
      });
    }
  }

  String _formatTime(int value) {
    return value.toString().padLeft(2, '0');
  }

  @override
  Widget build(BuildContext context) {
    if (widget.deadline == null || _timeLeft.isNegative || _timeLeft == Duration.zero) {
      return const SizedBox.shrink();
    }

    final minutes = _timeLeft.inMinutes % 60;
    final seconds = _timeLeft.inSeconds % 60;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.warning.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.warning.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.access_time,
            color: AppColors.warning,
            size: 16,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            'Limited offer ends in ${_formatTime(minutes)}:${_formatTime(seconds)}',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.warning,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
