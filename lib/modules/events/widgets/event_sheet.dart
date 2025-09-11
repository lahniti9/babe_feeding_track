import 'package:flutter/material.dart';
import 'event_sheet_scaffold.dart';
import 'primary_pill.dart';

class EventSheet extends StatelessWidget {
  final String title;
  final List<Widget> sections;
  final VoidCallback onSubmit;
  final Widget? trailing;

  const EventSheet({
    super.key,
    required this.title,
    required this.sections,
    required this.onSubmit,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return EventSheetScaffold(
      title: title,
      trailing: trailing,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...sections.map((section) => Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: section,
          )),
          const SizedBox(height: 8),
          PrimaryPill(
            label: 'Done',
            icon: Icons.check,
            onTap: onSubmit,
          ),
        ],
      ),
    );
  }
}
