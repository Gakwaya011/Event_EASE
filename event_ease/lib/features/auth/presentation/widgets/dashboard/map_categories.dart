import 'package:flutter/material.dart';

Map<String, dynamic> getCategoryStyle(String category) {
  switch (category.toLowerCase()) {
    case 'birthday':
      return {'icon': Icons.cake, 'color': Colors.pink.shade300};
    case 'wedding':
      return {'icon': Icons.card_giftcard, 'color': Colors.amber.shade300};
    case 'corporate':
      return {'icon': Icons.business, 'color': Colors.blue.shade300};
    case 'conference':
      return {'icon': Icons.mic, 'color': Colors.deepPurple.shade300};
    case 'party':
      return {'icon': Icons.celebration, 'color': Colors.orange.shade300};
    default:
      return {'icon': Icons.event, 'color': Colors.grey.shade400}; // Default style
  }
}
