import 'package:flutter/material.dart';

class ProfileTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isEditing;

  const ProfileTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, color: Colors.black54)),
          const SizedBox(height: 5),
          isEditing
              ? TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black12, width: 2.0),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: const BorderSide(color: Colors.amber, width: 2.0),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  ),
                )
              : Text(controller.text, style: const TextStyle(fontSize: 16, color: Colors.black87)),
        ],
      ),
    );
  }
}
