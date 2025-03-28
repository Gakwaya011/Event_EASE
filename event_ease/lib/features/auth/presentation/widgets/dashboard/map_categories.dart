import 'package:flutter/material.dart';

Map<String, dynamic> getCategoryStyle(String category) {
  switch (category.toLowerCase()) {
    case 'birthday':
      return {'icon': Icons.cake, 'color': Colors.red.shade300};
    case 'wedding':
      return {'icon': Icons.card_giftcard, 'color': Colors.blue.shade300};
    case 'graduation':
      return {'icon': Icons.school, 'color': Colors.purple.shade300};
    case 'conference':
      return {'icon': Icons.business, 'color': Colors.amber};
    case 'party':
      return {'icon': Icons.celebration, 'color': Colors.orange.shade300};
    case 'burial':
      return {'icon': Icons.home, 'color': Colors.green.shade400};
    default:
      return {'icon': Icons.event, 'color': Colors.grey.shade400}; // Default style
  }
}
