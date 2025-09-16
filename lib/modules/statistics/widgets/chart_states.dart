import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/spacing.dart';

/// Shimmer loading state for charts
class ShimmerCard extends StatefulWidget {
  final double height;
  final String? title;

  const ShimmerCard({
    super.key,
    required this.height,
    this.title,
  });

  @override
  State<ShimmerCard> createState() => _ShimmerCardState();
}

class _ShimmerCardState extends State<ShimmerCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: const Color(0xFF111217),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title shimmer
              if (widget.title != null)
                Text(
                  widget.title!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                )
              else
                _buildShimmerBox(120, 20),
              
              const SizedBox(height: AppSpacing.md),
              
              // Badges shimmer
              Row(
                children: [
                  _buildShimmerBox(80, 32),
                  const SizedBox(width: AppSpacing.sm),
                  _buildShimmerBox(70, 32),
                  const SizedBox(width: AppSpacing.sm),
                  _buildShimmerBox(90, 32),
                ],
              ),
              
              const SizedBox(height: AppSpacing.md),
              
              // Range chips shimmer
              Row(
                children: List.generate(5, (i) => Padding(
                  padding: EdgeInsets.only(right: i < 4 ? 8 : 0),
                  child: _buildShimmerBox(40, 32),
                )),
              ),
              
              const SizedBox(height: AppSpacing.md),
              
              // Chart area shimmer
              Expanded(
                child: _buildShimmerBox(double.infinity, double.infinity),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildShimmerBox(double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: [
            (_animation.value - 1).clamp(0.0, 1.0),
            _animation.value.clamp(0.0, 1.0),
            (_animation.value + 1).clamp(0.0, 1.0),
          ],
          colors: [
            Colors.white.withValues(alpha: 0.05),
            Colors.white.withValues(alpha: 0.15),
            Colors.white.withValues(alpha: 0.05),
          ],
        ),
      ),
    );
  }
}

/// Empty state for charts with CTA
class EmptyChartCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String description;
  final String ctaLabel;
  final VoidCallback onCta;
  final IconData icon;
  final Color color;

  const EmptyChartCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.description,
    required this.ctaLabel,
    required this.onCta,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: const Color(0xFF111217),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      color.withValues(alpha: 0.2),
                      color.withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.2,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppSpacing.xl),
          
          // Empty state content
          Center(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 48,
                    color: color.withValues(alpha: 0.6),
                  ),
                ),
                
                const SizedBox(height: AppSpacing.lg),
                
                Text(
                  'No data yet',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
                
                const SizedBox(height: AppSpacing.sm),
                
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.6),
                    height: 1.4,
                  ),
                ),
                
                const SizedBox(height: AppSpacing.xl),
                
                // CTA Button
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      onCta();
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            color,
                            color.withValues(alpha: 0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: color.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            ctaLabel,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}

/// Live update indicator
class LiveUpdateIndicator extends StatefulWidget {
  final DateTime lastUpdate;

  const LiveUpdateIndicator({
    super.key,
    required this.lastUpdate,
  });

  @override
  State<LiveUpdateIndicator> createState() => _LiveUpdateIndicatorState();
}

class _LiveUpdateIndicatorState extends State<LiveUpdateIndicator> {
  late String _timeAgo;

  @override
  void initState() {
    super.initState();
    _updateTimeAgo();
    // Update every minute
    Future.delayed(const Duration(minutes: 1), _updateTimeAgo);
  }

  void _updateTimeAgo() {
    if (!mounted) return;
    
    final now = DateTime.now();
    final difference = now.difference(widget.lastUpdate);
    
    setState(() {
      if (difference.inSeconds < 60) {
        _timeAgo = 'just now';
      } else if (difference.inMinutes < 60) {
        _timeAgo = '${difference.inMinutes}m ago';
      } else if (difference.inHours < 24) {
        _timeAgo = '${difference.inHours}h ago';
      } else {
        _timeAgo = '${difference.inDays}d ago';
      }
    });
    
    // Schedule next update
    Future.delayed(const Duration(minutes: 1), _updateTimeAgo);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF10B981).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFF10B981).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Color(0xFF10B981),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            'Updated $_timeAgo',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Color(0xFF10B981),
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
