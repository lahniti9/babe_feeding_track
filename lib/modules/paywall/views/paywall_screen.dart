import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/paywall_controller.dart';
import '../services/subscription_service.dart';

/// PALETTE (tuned to your screenshots)
class _PWColors {
  static const bg = Color(0xFFFFEDB3); // buttery yellow
  static const accent = Color(0xFFFFA000); // progress/labels
  static const dark = Color(0xFF2C2C2C);
  static const sub = Color(0xFF6C6C6C);
  static const card = Colors.white;
  static const badge = Color(0xFFFFD54F);
  static const tick = Color(0xFF16A34A);
  static const cta = Color(0xFF22C55E);
  static const discountBg = Color(0xFF3E3A85); // purple bar
  static const discountChip = Color(0xFF6D5BFF);
  static const divider = Color(0x14000000);
}

/// Simple model for plan choice (replace with RevenueCat package later)
enum _Plan { yearly, monthly }

class PaywallScreen extends StatefulWidget {
  const PaywallScreen({
    super.key,

    /// If you want to show step progress at top (like your shots)
    this.progressSteps = 5,
    this.progressFilled = 3,

    /// Countdown deadline (persist it with SharedPreferences for honesty)
    this.discountEndsAt,
    this.initialSelected = _Plan.yearly,

    /// A/B: you can rotate quotes
    this.quotes,
    this.childName = 'your baby',

    /// Story mode support
    this.showStepBar = true,
    this.quoteOverride,
  });

  final int progressSteps;
  final int progressFilled;
  final DateTime? discountEndsAt;
  final _Plan initialSelected;
  final List<Quote>? quotes;
  final String childName;
  final bool showStepBar;
  final Quote? quoteOverride;

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  late _Plan _selected = widget.initialSelected;
  late DateTime _deadline; // Will be initialized in _initializeDeadline
  late Timer _timer;
  Duration _remaining = const Duration();
  bool _trialOn = false; // UI toggle only – store decides real trial eligibility
  bool _isInitialized = false;

  Quote get _quote => widget.quoteOverride ??
      (widget.quotes ?? _defaultQuotes)[Random().nextInt((widget.quotes ?? _defaultQuotes).length)];

  @override
  void initState() {
    super.initState();
    _initializeDeadline();
    _tick();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  Future<void> _initializeDeadline() async {
    if (widget.discountEndsAt != null) {
      _deadline = widget.discountEndsAt!;
      setState(() => _isInitialized = true);
      _tick(); // Start timer immediately
      return;
    }

    // Persist discount deadline using SharedPreferences for honesty
    final prefs = await SharedPreferences.getInstance();
    final iso = prefs.getString('pw_deadline');

    if (iso == null) {
      // First time - create new deadline
      _deadline = DateTime.now().add(const Duration(hours: 5));
      await prefs.setString('pw_deadline', _deadline.toIso8601String());
    } else {
      // Use existing deadline
      _deadline = DateTime.parse(iso);
    }

    setState(() => _isInitialized = true);
    _tick(); // Start timer immediately
  }

  void _tick() {
    if (!_isInitialized) return; // Don't tick until deadline is initialized

    final now = DateTime.now();
    setState(() {
      _remaining = _deadline.isAfter(now)
          ? _deadline.difference(now)
          : Duration.zero;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  // Format "4h 23m 47s" or "23m 47s"
  String _fmt(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes % 60;
    final s = d.inSeconds % 60;

    if (h > 0) {
      return '${h}h ${m}m ${s.toString().padLeft(2, '0')}s';
    } else {
      return '${m}m ${s.toString().padLeft(2, '0')}s';
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: _PWColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            // ===== TOP BAR =====
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
              child: Column(
                children: [
                  if (widget.showStepBar)
                    _ProgressBar(
                      steps: widget.progressSteps,
                      filled: widget.progressFilled,
                    ),
                  if (widget.showStepBar) const SizedBox(height: 12),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close, color: _PWColors.sub),
                        onPressed: () {
                          try {
                            Get.offAllNamed('/tabs');
                          } catch (e) {
                            // Fallback navigation
                            Navigator.of(context).pushNamedAndRemoveUntil('/tabs', (route) => false);
                          }
                        },
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () async {
                          try {
                            final subscriptionService = Get.find<SubscriptionService>();
                            subscriptionService.openManageSubscriptions();
                          } catch (e) {
                            Get.snackbar('Info', 'Manage subscriptions feature coming soon');
                          }
                        },
                        child: const Text(
                          'Manage',
                          style: TextStyle(
                            color: _PWColors.sub,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          try {
                            final controller = Get.find<PaywallController>();
                            await controller.restorePurchases();
                          } catch (e) {
                            // Controller not found, handle gracefully
                            Get.snackbar('Info', 'Restore purchases feature coming soon');
                          }
                        },
                        child: const Text(
                          'Restore',
                          style: TextStyle(
                            color: _PWColors.sub,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ===== BODY =====
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                children: [
                  // Header + Stars
                  Text(
                    'Choose your plan\n${widget.childName} will appreciate it',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      height: 1.15,
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: _PWColors.dark,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const _StarsRow(),
                  const SizedBox(height: 16),

                  // Quote
                  Text(
                    '"${_quote.text}"',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      height: 1.35,
                      color: _PWColors.dark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _quote.author,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: _PWColors.sub,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Free trial toggle
                  _TrialRow(
                    value: _trialOn,
                    onChanged: (v) => setState(() => _trialOn = v),
                  ),
                  const SizedBox(height: 14),

                  // Plans
                  _PlanTile(
                    label: '1 year',
                    subtitle: 'US\$9,99 per year (only US\$0,8 per month)',
                    selected: _selected == _Plan.yearly,
                    badgeText: '67% OFF',
                    onTap: () => setState(() => _selected = _Plan.yearly),
                  ),
                  const SizedBox(height: 12),
                  _PlanTile(
                    label: '1 month',
                    subtitle: 'US\$2,49',
                    selected: _selected == _Plan.monthly,
                    onTap: () => setState(() => _selected = _Plan.monthly),
                  ),
                  const SizedBox(height: 22),

                  // Discount + countdown (Stack to show purple chip over bar)
                  if (_isInitialized)
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
                          decoration: BoxDecoration(
                            color: _PWColors.discountBg,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Row(
                            children: [
                              const Text(
                                'Expires in:',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                _fmt(_remaining),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 28,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: -16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: _PWColors.discountChip,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Text(
                              'YOU GET A DISCOUNT!',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.4,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  SizedBox(height: max(30.0, MediaQuery.of(context).padding.bottom)),
                ],
              ),
            ),

            // ===== BIG CTA =====
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 18),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _PWColors.cta,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(58),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () async {
                  // TODO: purchase selected plan
                  try {
                    final controller = Get.find<PaywallController>();
                    final subscriptionService = Get.find<SubscriptionService>();

                    if (_selected == _Plan.yearly) {
                      // Select annual package
                      final annualPackage = subscriptionService.annualPackage;
                      if (annualPackage != null) {
                        controller.selectPackage(annualPackage);
                      }
                    } else {
                      // Select monthly package
                      final monthlyPackage = subscriptionService.monthlyPackage;
                      if (monthlyPackage != null) {
                        controller.selectPackage(monthlyPackage);
                      }
                    }
                    await controller.purchaseSelected();
                  } catch (e) {
                    // For demo purposes, simulate successful purchase
                    Get.snackbar(
                      'Demo Mode',
                      'Purchase simulation - would buy ${_selected == _Plan.yearly ? 'annual' : 'monthly'} plan',
                      snackPosition: SnackPosition.TOP,
                    );
                    // Navigate to main app
                    Get.offAllNamed('/tabs');
                  }
                },
                child: const Text(
                  'Subscribe',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ----------------------------- SUBWIDGETS ------------------------------ */

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.steps, required this.filled});
  final int steps;
  final int filled;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(steps, (i) {
        return Expanded(
          child: Container(
            height: 6,
            margin: EdgeInsets.only(
              left: i == 0 ? 0 : 6,
              right: i == steps - 1 ? 0 : 6,
            ),
            decoration: BoxDecoration(
              color: i < filled ? _PWColors.accent : Colors.white.withOpacity(i == steps - 1 ? .9 : .55),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }),
    );
  }
}

class _StarsRow extends StatelessWidget {
  const _StarsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        5,
        (_) => const Padding(
          padding: EdgeInsets.symmetric(horizontal: 3.5),
          child: Icon(Icons.star, color: Color(0xFFFFB300), size: 26),
        ),
      ),
    );
  }
}

class _TrialRow extends StatelessWidget {
  const _TrialRow({required this.value, required this.onChanged});
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _PWColors.card.withOpacity(.65),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Still in doubt? Try it for free',
              style: TextStyle(
                color: _PWColors.dark,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: _PWColors.cta,
          ),
        ],
      ),
    );
  }
}

class _PlanTile extends StatelessWidget {
  const _PlanTile({
    required this.label,
    required this.subtitle,
    required this.selected,
    this.badgeText,
    required this.onTap,
  });

  final String label;
  final String subtitle;
  final bool selected;
  final String? badgeText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final border = Border.all(
      color: selected ? _PWColors.badge : _PWColors.divider,
      width: selected ? 2 : 1,
    );

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: _PWColors.card,
          borderRadius: BorderRadius.circular(16),
          border: border,
          boxShadow: [
            if (selected)
              BoxShadow(
                color: _PWColors.badge.withOpacity(.35),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Stack(
          children: [
            Row(
              children: [
                // radio/check
                Container(
                  height: 24,
                  width: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selected ? _PWColors.tick : _PWColors.sub,
                      width: selected ? 0 : 2,
                    ),
                    color: selected ? _PWColors.tick : Colors.transparent,
                  ),
                  child: selected
                      ? const Icon(Icons.check, color: Colors.white, size: 16)
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(color: _PWColors.dark),
                          children: [
                            TextSpan(
                              text: '$label: ',
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 17,
                              ),
                            ),
                            TextSpan(
                              text: subtitle,
                              style: const TextStyle(
                                fontSize: 16,
                                color: _PWColors.dark,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (badgeText != null)
              Positioned(
                right: 10,
                top: -8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: _PWColors.badge,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    badgeText!,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: _PWColors.dark,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}



class Quote {
  final String text;
  final String author;
  const Quote(this.text, this.author);
}

const _defaultQuotes = <Quote>[
  Quote(
    'This app changed my life as a new mom!',
    'Sarah M.',
  ),
  Quote(
    'Finally, an app that actually helps with feeding schedules.',
    'Jessica K.',
  ),
  Quote(
    'My baby sleeps better since using this app!',
    'Maria L.',
  ),
  Quote(
    'Worth every penny. Best parenting investment ever!',
    'Amanda R.',
  ),
  Quote(
    'Perfect for tracking everything about my baby!',
    'Emily T.',
  ),
];
