import 'package:flutter/material.dart';

class ProfileSection extends StatelessWidget {
  final String title;
  final bool isEditing;
  final VoidCallback onEditPressed;
  final VoidCallback onSavePressed;
  final List<Widget> children;

  const ProfileSection({
    super.key,
    required this.title,
    required this.isEditing,
    required this.onEditPressed,
    required this.onSavePressed,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, color: Colors.black87)),
            IconButton(
              icon: Icon(isEditing ? Icons.check : Icons.edit, color: Colors.amber),
              onPressed: isEditing ? onSavePressed : onEditPressed,
            ),
          ],
        ),
        ...children,
      ],
    );
  }
}
