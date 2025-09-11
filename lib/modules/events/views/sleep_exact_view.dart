import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/sleep_entry_controller.dart';
import '../models/sleep_event.dart';

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

    return SafeArea(
      top: false,
      child: DraggableScrollableSheet(
        initialChildSize: 0.92,
        minChildSize: 0.6,
        maxChildSize: 0.98,
        builder: (_, controller) => Container(
          decoration: const BoxDecoration(
            color: Color(0xFF191919),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(
            controller: controller,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Grabber
                Center(
                  child: Container(
                    width: 44, 
                    height: 5, 
                    decoration: BoxDecoration(
                      color: Colors.white24, 
                      borderRadius: BorderRadius.circular(3)
                    )
                  )
                ),
                const SizedBox(height: 16),

                // Title row
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Sleeping', 
                            style: TextStyle(
                              fontSize: 22, 
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            )
                          ),
                          const SizedBox(height: 2),
                          Obx(() => Text(
                            c.isEdit.value ? 'edit event' : 'add event',
                            style: const TextStyle(color: Colors.white60)
                          )),
                        ],
                      ),
                    ),
                    Obx(() => c.isEdit.value
                        ? IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.white),
                            onPressed: c.delete,
                          )
                        : const SizedBox.shrink()),
                  ],
                ),

                const Divider(color: Colors.white12),
                const SizedBox(height: 16),

                // Fell asleep row
                _TimeRow(
                  label: 'Fell asleep',
                  dateTime: c.fellAsleep,
                  onPick: (dt) => c.setFellAsleepTime(dt),
                ),
                const SizedBox(height: 16),

                // Woke up row
                _TimeRow(
                  label: 'Woke up',
                  dateTime: c.wokeUp,
                  onPick: (dt) => c.setWokeUpTime(dt),
                ),
                const SizedBox(height: 16),

                // Comment field + counter
                _CommentBox(
                  controller: c,
                ),
                const SizedBox(height: 8),

                // START OF SLEEP tags
                _SectionHeader(icon: Icons.bedtime, label: 'START OF SLEEP'),
                const SizedBox(height: 8),
                _SingleSelectChips(
                  options: kSleepStartTags,
                  selected: c.startTag,
                  onToggle: c.toggleStartTag,
                ),

                const SizedBox(height: 16),

                // END OF SLEEP tags
                _SectionHeader(icon: Icons.notifications_active_outlined, label: 'END OF SLEEP'),
                const SizedBox(height: 8),
                _SingleSelectChips(
                  options: kSleepEndTags,
                  selected: c.endTag,
                  onToggle: c.toggleEndTag,
                ),

                const SizedBox(height: 16),

                // HOW tags
                _SectionHeader(icon: Icons.help_outline, label: 'HOW'),
                const SizedBox(height: 8),
                _SingleSelectChips(
                  options: kSleepHowTags,
                  selected: c.howTag,
                  onToggle: c.toggleHowTag,
                ),

                const SizedBox(height: 24),

                // Bottom button
                _BigPill(
                  leading: const Icon(Icons.check, color: Colors.white),
                  label: 'Done',
                  color: const Color(0xFF2E7D32), // green
                  onTap: c.save,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Supporting UI components
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
