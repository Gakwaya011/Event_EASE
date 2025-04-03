
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class forYouSection extends StatelessWidget {
  const forYouSection({super.key});

  @override
   Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'For you',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            shrinkWrap: true,
            childAspectRatio: 1.3,
            children: [
              _buildTemplateCard(
                context,
                title: 'Birthday Template',
                icon: Icons.cake,
                color: Colors.red.shade300,
              ),
              _buildTemplateCard(
                context,
                title: 'Wedding Template',
                icon: Icons.card_giftcard,
                color: Colors.blue.shade300,
              ),
              _buildTemplateCard(
                context,
                title: 'Corporate Meeting',
                icon: Icons.business,
                color: Colors.amber,
              ),
              _buildTemplateCard(
                context,
                title: 'Burial Template',
                icon: Icons.home,
                color: Colors.green.shade400,
              ),
              _buildTemplateCard(
                context,
                title: 'Graduation Template',
                icon: Icons.school,
                color: Colors.purple.shade300,
              ),
            ],
          ),
        ],
      ),
    );
  }

}



Widget _buildTemplateCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () => context.push('/create_event'),
      child: Container(
        padding: const EdgeInsets.all(16),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.clip,
            ),
          ],
        ),
      ),
    );
  }
