

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class myEventsSection extends StatelessWidget {
  const myEventsSection({super.key});

  @override
   Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'My Events',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              _buildEventCard(
                context,
                title: "Kamila's Birthday",
                icon: Icons.cake,
                color: Colors.red.shade300,
              ),
              const SizedBox(width: 12),
              _buildEventCard(
                context,
                title: "My wedding",
                icon: Icons.card_giftcard,
                color: Colors.blue.shade300,
              ),
              const SizedBox(width: 12),
              _buildEventCard(
                context,
                title: "Corporate",
                icon: Icons.business,
                color: Colors.amber,
                isPartial: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

}


Widget _buildEventCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    bool isPartial = false,
  }) {
    return GestureDetector(
      onTap: () => context.push('/single_event'),
      child: Container(
        width: 140,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 36,
              width: 36,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: color,
                size: 20,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
