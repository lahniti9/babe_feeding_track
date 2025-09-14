import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/colors.dart';
import '../controllers/sleep_entry_controller.dart';
import '../models/sleep_event.dart';
import '../widgets/primary_pill.dart';

class SleepExactView extends StatelessWidget {
  final String childId;
  final SleepEvent? initial;
  
  const SleepExactView({
    super.key, 
    required this.childId, 
    this.initial
  });

  @override
  Widget build(BuildContext context) {
    final c = Get.put(SleepEntryController(childId: childId, initial: initial));

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
        minHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.background,
            AppColors.cardBackground,
          ],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 32,
            offset: const Offset(0, -12),
          ),
          BoxShadow(
            color: AppColors.coral.withValues(alpha: 0.1),
            blurRadius: 64,
            offset: const Offset(0, -24),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Enhanced handle bar
          Container(
            margin: const EdgeInsets.only(top: 16),
            width: 48,
            height: 5,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.coral.withValues(alpha: 0.3),
                  AppColors.coral.withValues(alpha: 0.8),
                  AppColors.coral.withValues(alpha: 0.3),
                ],
              ),
              borderRadius: BorderRadius.circular(3),
            ),
          ),

          // Enhanced header
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.coral.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.coral.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: const Icon(
                        Icons.bedtime_rounded,
                        color: AppColors.coral,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Sleeping',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Obx(() => Text(
                            c.isEdit.value ? 'Edit sleep session' : 'Track sleep time',
                            style: const TextStyle(
                              color: Colors.white60,
                              fontSize: 16,
                            ),
                          )),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Content - Made scrollable
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Column(
                children: [

                  // Enhanced time rows
                  _EnhancedTimeRow(
                    label: 'Fell asleep',
                    dateTime: c.fellAsleep,
                    onPick: (dt) => c.setFellAsleepTime(dt),
                    icon: Icons.bedtime_rounded,
                  ),
                  const SizedBox(height: 16),

                  _EnhancedTimeRow(
                    label: 'Woke up',
                    dateTime: c.wokeUp,
                    onPick: (dt) => c.setWokeUpTime(dt),
                    icon: Icons.wb_sunny_rounded,
                  ),
                  const SizedBox(height: 24),

                  // Enhanced comment section
                  _EnhancedCommentBox(controller: c),
                  const SizedBox(height: 24),

                  // Enhanced sleep tags sections
                  _EnhancedSleepSection(
                    title: 'START OF SLEEP',
                    icon: Icons.bedtime_rounded,
                    options: kSleepStartTags,
                    selected: c.startTag,
                    onToggle: c.toggleStartTag,
                    color: const Color(0xFF8B5CF6),
                  ),
                  const SizedBox(height: 20),

                  _EnhancedSleepSection(
                    title: 'END OF SLEEP',
                    icon: Icons.notifications_active_rounded,
                    options: kSleepEndTags,
                    selected: c.endTag,
                    onToggle: c.toggleEndTag,
                    color: const Color(0xFF10B981),
                  ),
                  const SizedBox(height: 20),

                  _EnhancedSleepSection(
                    title: 'HOW',
                    icon: Icons.help_rounded,
                    options: kSleepHowTags,
                    selected: c.howTag,
                    onToggle: c.toggleHowTag,
                    color: const Color(0xFF3B82F6),
                  ),
                ],
              ),
            ),
          ),

          // Enhanced done button
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            child: PrimaryPill(
              label: 'Done',
              icon: Icons.check_rounded,
              onTap: () {
                c.save();
                Get.back();
              },
              enabled: c.valid,
              color: AppColors.coral,
            ),
          ),
        ],
      ),
    );
  }
}

// Enhanced UI components
class _EnhancedTimeRow extends StatelessWidget {
  final String label;
  final Rx<DateTime> dateTime;
  final Function(DateTime) onPick;
  final IconData icon;

  const _EnhancedTimeRow({
    required this.label,
    required this.dateTime,
    required this.onPick,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackgroundSecondary,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.coral.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.coral.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: AppColors.coral,
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Obx(() => Text(
                  DateFormat('MMM d, h:mm a').format(dateTime.value),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                )),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _showDateTimePicker(context),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.coral.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.coral.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: const Icon(
                Icons.edit_rounded,
                color: AppColors.coral,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDateTimePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Container(
        height: 320,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white60),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onPick(dateTime.value);
                  },
                  child: const Text(
                    'Done',
                    style: TextStyle(color: AppColors.coral),
                  ),
                ),
              ],
            ),
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.dateAndTime,
                initialDateTime: dateTime.value,
                onDateTimeChanged: (time) => dateTime.value = time,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EnhancedCommentBox extends StatefulWidget {
  final SleepEntryController controller;

  const _EnhancedCommentBox({required this.controller});

  @override
  State<_EnhancedCommentBox> createState() => _EnhancedCommentBoxState();
}

class _EnhancedCommentBoxState extends State<_EnhancedCommentBox> {
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.controller.comment.value);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackgroundSecondary,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.coral.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.coral.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.comment_rounded,
                  color: AppColors.coral,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'COMMENT',
                style: TextStyle(
                  color: AppColors.coral,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _textController,
            maxLines: 4,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            decoration: const InputDecoration(
              hintText: 'Here you can write your comment',
              hintStyle: TextStyle(color: Colors.white60),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            onChanged: widget.controller.updateComment,
          ),
          const SizedBox(height: 12),
          Obx(() => Text(
            '${widget.controller.commentCharacterCount} / 300',
            style: TextStyle(
              color: widget.controller.commentAtLimit ? Colors.red : Colors.white60,
              fontSize: 12,
            ),
          )),
        ],
      ),
    );
  }
}

class _EnhancedSleepSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<String> options;
  final RxnString selected;
  final Function(String) onToggle;
  final Color color;

  const _EnhancedSleepSection({
    required this.title,
    required this.icon,
    required this.options,
    required this.selected,
    required this.onToggle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackgroundSecondary,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Obx(() => Wrap(
            spacing: 8,
            runSpacing: 8,
            children: options.map((option) {
              final isSelected = selected.value == option;
              return GestureDetector(
                onTap: () => onToggle(option),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected
                      ? color.withValues(alpha: 0.2)
                      : AppColors.background,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                        ? color
                        : Colors.white.withValues(alpha: 0.1),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isSelected)
                        Container(
                          margin: const EdgeInsets.only(right: 8),
                          child: Icon(
                            Icons.check_circle_rounded,
                            color: color,
                            size: 16,
                          ),
                        ),
                      Text(
                        option,
                        style: TextStyle(
                          color: isSelected ? color : Colors.white70,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          )),
        ],
      ),
    );
  }
}

// Supporting UI components (keeping for compatibility)
class _TimeRow extends StatelessWidget {
  final String label;
  final Rx<DateTime> dateTime;
  final Function(DateTime) onPick;

  const _TimeRow({
    required this.label,
    required this.dateTime,
    required this.onPick,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d');
    final timeFormat = DateFormat('HH:mm');

    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white
          )
        ),
        const Spacer(),
        GestureDetector(
          onTap: () => _showDateTimePicker(context),
          child: Obx(() => Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  dateFormat.format(dateTime.value),
                  style: const TextStyle(color: Color(0xFFE0E0E0)),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  timeFormat.format(dateTime.value),
                  style: const TextStyle(color: Color(0xFFE0E0E0)),
                ),
              ),
            ],
          )),
        ),
      ],
    );
  }

  void _showDateTimePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF191919),
      builder: (context) => Container(
        height: 300,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel', style: TextStyle(color: Colors.white60)),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onPick(dateTime.value);
                  },
                  child: const Text('Done', style: TextStyle(color: Colors.orange)),
                ),
              ],
            ),
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.dateAndTime,
                initialDateTime: dateTime.value,
                onDateTimeChanged: (time) => dateTime.value = time,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CommentBox extends StatefulWidget {
  final SleepEntryController controller;

  const _CommentBox({required this.controller});

  @override
  State<_CommentBox> createState() => _CommentBoxState();
}

class _CommentBoxState extends State<_CommentBox> {
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.controller.comment.value);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(16),
          ),
          child: TextField(
            controller: _textController,
            maxLines: 4,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Here you can write your comment',
              hintStyle: TextStyle(color: Colors.white60),
              border: InputBorder.none,
            ),
            onChanged: widget.controller.updateComment,
          ),
        ),
        const SizedBox(height: 8),
        Obx(() => Text(
          '${widget.controller.commentCharacterCount} / 300',
          style: TextStyle(
            color: widget.controller.commentAtLimit ? Colors.red : Colors.white60,
            fontSize: 12,
          ),
        )),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String label;

  const _SectionHeader({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF8C5BFF), size: 20),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF8C5BFF),
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

class _SingleSelectChips extends StatelessWidget {
  final List<String> options;
  final RxnString selected;
  final Function(String) onToggle;

  const _SingleSelectChips({
    required this.options,
    required this.selected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() => Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((option) {
        final isSelected = selected.value == option;
        return GestureDetector(
          onTap: () => onToggle(option),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF8C5BFF) : const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              option,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFFE0E0E0),
                fontSize: 14,
              ),
            ),
          ),
        );
      }).toList(),
    ));
  }
}

class _BigPill extends StatelessWidget {
  final Widget leading;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _BigPill({
    required this.leading,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            leading,
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
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
