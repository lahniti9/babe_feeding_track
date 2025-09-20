import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'paywall_screen.dart';

/// A single story page: just pass the quote + any per-page tweaks.
/// The last page usually shows the full pricing/CTA and doesn't auto-advance.
class PaywallStoryPage {
  const PaywallStoryPage({
    required this.quoteText,
    required this.author,
    this.duration = const Duration(seconds: 4), // 0 or null => don't auto-advance
  });

  final String quoteText;
  final String author;
  final Duration? duration;
}

/// Story container for your paywall
class PaywallStory extends StatefulWidget {
  const PaywallStory({
    super.key,
    required this.pages,
    this.loop = true, // Always loop by default
    this.childName = 'your baby',
  });

  final List<PaywallStoryPage> pages;
  final bool loop;
  final String childName;

  @override
  State<PaywallStory> createState() => _PaywallStoryState();
}

class _PaywallStoryState extends State<PaywallStory> with TickerProviderStateMixin {
  late List<AnimationController> _progressControllers;
  int _currentQuoteIndex = 0;
  bool _paused = false;

  // Timer for discount countdown
  DateTime? _discountDeadline;
  Duration _timeRemaining = Duration.zero;

  @override
  void initState() {
    super.initState();

    // Initialize discount deadline
    _initializeDiscountDeadline();

    // Create progress controllers for each story segment
    _progressControllers = List.generate(widget.pages.length, (index) {
      return AnimationController(
        vsync: this,
        duration: widget.pages[index].duration ?? const Duration(seconds: 3),
      );
    });

    // Add listener to current controller
    _progressControllers[_currentQuoteIndex].addStatusListener((status) {
      if (status == AnimationStatus.completed && !_paused) {
        _nextQuote();
      }
    });

    _startProgress();
  }

  Future<void> _initializeDiscountDeadline() async {
    final prefs = await SharedPreferences.getInstance();
    final iso = prefs.getString('pw_deadline');

    if (iso == null) {
      // First time - create new deadline
      _discountDeadline = DateTime.now().add(const Duration(hours: 5));
      await prefs.setString('pw_deadline', _discountDeadline!.toIso8601String());
    } else {
      // Check if existing deadline is in the past
      final existingDeadline = DateTime.parse(iso);
      if (existingDeadline.isBefore(DateTime.now())) {
        // Deadline expired - create new one
        _discountDeadline = DateTime.now().add(const Duration(hours: 5));
        await prefs.setString('pw_deadline', _discountDeadline!.toIso8601String());
      } else {
        // Use existing deadline
        _discountDeadline = existingDeadline;
      }
    }

    setState(() {});
  }

  void _startProgress() {
    if (_paused) return;
    _progressControllers[_currentQuoteIndex].forward();
  }

  void _pause() {
    if (_paused) return;
    _paused = true;
    _progressControllers[_currentQuoteIndex].stop();
    setState(() {});
  }

  void _resume() {
    if (!_paused) return;
    _paused = false;
    _progressControllers[_currentQuoteIndex].forward();
    setState(() {});
  }

  void _nextQuote() {
    // Complete current progress bar
    _progressControllers[_currentQuoteIndex].value = 1.0;

    // Move to next quote
    final oldIndex = _currentQuoteIndex;
    _currentQuoteIndex = (_currentQuoteIndex + 1) % widget.pages.length;

    // If we're looping back to start, reset all progress bars
    if (_currentQuoteIndex == 0) {
      for (var controller in _progressControllers) {
        controller.reset();
      }
    }

    // Remove old listener and add new one
    _progressControllers[oldIndex].removeStatusListener(_onProgressComplete);
    _progressControllers[_currentQuoteIndex].addStatusListener(_onProgressComplete);

    setState(() {});

    // Start next progress cycle
    _startProgress();
  }

  void _prevQuote() {
    // Reset current progress bar
    _progressControllers[_currentQuoteIndex].reset();

    // Move to previous quote
    final oldIndex = _currentQuoteIndex;
    _currentQuoteIndex = (_currentQuoteIndex - 1 + widget.pages.length) % widget.pages.length;

    // Reset the previous progress bar too
    _progressControllers[_currentQuoteIndex].reset();

    // Remove old listener and add new one
    _progressControllers[oldIndex].removeStatusListener(_onProgressComplete);
    _progressControllers[_currentQuoteIndex].addStatusListener(_onProgressComplete);

    setState(() {});

    // Start progress cycle
    _startProgress();
  }

  void _onProgressComplete(AnimationStatus status) {
    if (status == AnimationStatus.completed && !_paused) {
      _nextQuote();
    }
  }

  @override
  void dispose() {
    for (var controller in _progressControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentPage = widget.pages[_currentQuoteIndex];

    // Transparent tap zones (left/right), long-press to pause
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapUp: (d) {
        final w = MediaQuery.of(context).size.width;
        final isRight = d.globalPosition.dx > w / 2;
        isRight ? _nextQuote() : _prevQuote();
      },
      onLongPressStart: (_) => _pause(),
      onLongPressEnd: (_) => _resume(),
      child: Stack(
        children: [
          // Single PaywallScreen with changing quote
          PaywallScreen(
            key: ValueKey(_currentQuoteIndex), // Force rebuild when quote changes
            showStepBar: false, // We'll show our own progress bar
            quoteOverride: Quote(currentPage.quoteText, currentPage.author),
            childName: widget.childName,
            discountEndsAt: _discountDeadline, // Pass the same deadline to preserve timer
          ),

          // 5 segmented progress bars at the top (like Instagram stories)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                children: List.generate(widget.pages.length, (index) {
                  return Expanded(
                    child: Container(
                      height: 4,
                      margin: EdgeInsets.only(right: index < widget.pages.length - 1 ? 4 : 0),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: AnimatedBuilder(
                          animation: _progressControllers[index],
                          builder: (context, child) {
                            double value;
                            if (index < _currentQuoteIndex) {
                              // Completed segments
                              value = 1.0;
                            } else if (index == _currentQuoteIndex) {
                              // Current segment (animating)
                              value = _progressControllers[index].value;
                            } else {
                              // Future segments
                              value = 0.0;
                            }

                            return LinearProgressIndicator(
                              value: value,
                              backgroundColor: Colors.transparent,
                              valueColor: const AlwaysStoppedAnimation(Color(0xFFFFA000)),
                              minHeight: 4,
                            );
                          },
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),

          // Optional tiny "paused" hint
          if (_paused)
            const Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: 32),
                child: Icon(Icons.pause_circle_filled, color: Colors.black38),
              ),
            ),
        ],
      ),
    );
  }
}


