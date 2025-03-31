import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  State<CustomAppBar>createState() => _CustomAppBarState();
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

}

class _CustomAppBarState extends State<CustomAppBar> {
  //  bool _isNotificationModalVisible = false;

  void _toggleNotificationModal() {
  showGeneralDialog(
    context: context,
    barrierDismissible: true, // Close when tapping outside
    barrierLabel: "Dismiss",
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, anim1, anim2) {
      return _buildFullScreenNotificationModal();
    },
    transitionBuilder: (context, anim1, anim2, child) {
      return SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
            .animate(anim1),
        child: child,
      );
    },
  );
}


  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            'assets/logo.png', 
            width: 30, 
            height: 30,
          ),
          const Text(
            'Dashboard',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: _toggleNotificationModal,
              ),
              SizedBox(width: 20),
              GestureDetector(
                onTap: () => context.push('/profile'),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: Colors.amber,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFullScreenNotificationModal() {
  return Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      backgroundColor: Colors.amber,
      title: const Text('Notifications'),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
    ),
    body: ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildNotificationItem(
          icon: Icons.cake,
          title: "Kamila's Birthday Reminder",
          subtitle: "Event is coming up in 3 days",
          time: "2 hours ago",
        ),
        _buildNotificationItem(
          icon: Icons.card_giftcard,
          title: "Wedding Planning Update",
          subtitle: "New vendor suggestions added",
          time: "Yesterday",
        ),
      ],
    ),
  );
}


  Widget _buildNotificationItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String time,
  }) {
    return ListTile(
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.amber.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Colors.amber),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 12,
        ),
      ),
      trailing: Text(
        time,
        style: TextStyle(
          color: Colors.grey.shade500,
          fontSize: 12,
        ),
      ),
    );
  }

}
