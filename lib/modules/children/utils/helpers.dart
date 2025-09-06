import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Date picker helper
Future<DateTime?> pickDate(BuildContext context, DateTime initial) async {
  final picked = await showDatePicker(
    context: context,
    initialDate: initial,
    firstDate: DateTime(2020),
    lastDate: DateTime.now().add(const Duration(days: 1)),
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFFFFA629),
            onPrimary: Colors.white,
            surface: Color(0xFF1B1B1B),
            onSurface: Colors.white,
          ),
        ),
        child: child!,
      );
    },
  );
  return picked;
}

// Text input dialog helper
Future<String?> inputText(BuildContext context, String title, String initial) async {
  final controller = TextEditingController(text: initial);
  
  return await Get.dialog<String>(
    AlertDialog(
      backgroundColor: const Color(0xFF1B1B1B),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      content: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[600]!),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFFFA629)),
          ),
        ),
        autofocus: true,
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        TextButton(
          onPressed: () => Get.back(result: controller.text),
          child: const Text(
            'Save',
            style: TextStyle(color: Color(0xFFFFA629)),
          ),
        ),
      ],
    ),
  );
}

// Confirm delete dialog helper
Future<void> confirmDelete(BuildContext context, {required VoidCallback onYes}) async {
  final result = await Get.dialog<bool>(
    AlertDialog(
      backgroundColor: const Color(0xFF1B1B1B),
      title: const Text(
        'Remove Profile',
        style: TextStyle(color: Colors.white),
      ),
      content: const Text(
        'Are you sure you want to remove this baby\'s profile? This action cannot be undone.',
        style: TextStyle(color: Colors.white70),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(result: false),
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        TextButton(
          onPressed: () => Get.back(result: true),
          child: const Text(
            'Remove',
            style: TextStyle(color: Color(0xFFE53935)),
          ),
        ),
      ],
    ),
  );
  
  if (result == true) {
    onYes();
  }
}
