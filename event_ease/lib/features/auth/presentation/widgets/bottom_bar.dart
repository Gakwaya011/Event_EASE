import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomBar extends StatelessWidget {
  const CustomBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    String currentRoute = GoRouterState.of(context).uri.toString();

    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(context, Icons.home, '/dashboard', currentRoute),
          _buildNavItem(context, Icons.add, '/create_event', currentRoute),
          _buildNavItem(context, Icons.settings, '/profile', currentRoute),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, String route, String currentRoute) {
    bool isActive = currentRoute == route;

    return IconButton(
      icon: Icon(
        icon,
        color: isActive ? Colors.amber : Colors.grey,
      ),
      onPressed: () {
        if (!isActive) context.go(route);
      },
    );
  }
}
