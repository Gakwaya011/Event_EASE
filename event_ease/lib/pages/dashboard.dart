import 'package:flutter/material.dart';


class EventPlannerHome extends StatefulWidget {
  const EventPlannerHome({super.key});

  @override
  State<EventPlannerHome> createState() => _EventPlannerHomeState();
}

class _EventPlannerHomeState extends State<EventPlannerHome> {
  // Controller for search input
  final TextEditingController _searchController = TextEditingController();
  
  // Selected bottom nav index
  int _selectedIndex = 0;
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  
  void _onCardTap(String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$title selected')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Color(0xFFFFF2D6),
              Color(0xFFFFE4B3),
            ],
            stops: [0.0, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Background design bars
              Positioned(
                right: 0,
                bottom: 0,
                child: _buildDesignBars(),
              ),
              
              // Main content
              Column(
                children: [
                  _buildAppBar(),
                  _buildSearchBar(),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),
                            _buildMyEventsSection(),
                            const SizedBox(height: 24),
                            _buildStartPlanningSection(),
                            const SizedBox(height: 24),
                            _buildForYouSection(),
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ),
                  ),
                  _buildBottomNavBar(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesignBars() {
  return Positioned(
    right: -20, // Adjust the position to move the bars to the right
    bottom: 20, // Adjust the position to move the bars to the bottom
    child: Opacity(
      opacity: 0.4,
      child: Transform.rotate(
        angle: 0.8, // Rotate the bars diagonally (in radians)
        child: SizedBox(
          height: 180,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: 180,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: 200,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 244, 210, 156),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: 170,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 253, 204, 118),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26.0, vertical: 8.0),
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
                onPressed: () {},
              ),
              SizedBox(width: 8),
              Container(
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
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36.0, vertical: 18.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Filter tapped')),
                  );
                },
                borderRadius: BorderRadius.circular(8),
                child: const Icon(
                  Icons.filter_list,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyEventsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'My Events',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 80,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildEventCard(
                title: "Kamila's Birthday",
                icon: Icons.cake,
                color: Colors.red.shade300,
                hasHeart: true,
                onTap: () => _onCardTap("Kamila's Birthday"),
              ),
              _buildEventCard(
                title: "My wedding",
                icon: Icons.card_giftcard,
                color: Colors.blue.shade300,
                onTap: () => _onCardTap("My wedding"),
              ),
              _buildEventCard(
                title: "Corporate",
                icon: Icons.business,
                color: Colors.amber,
                isPartial: true,
                onTap: () => _onCardTap("Corporate"),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEventCard({
    required String title,
    required IconData icon,
    required Color color,
    required Function() onTap,
    bool hasHeart = false,
    bool isPartial = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 12),
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
            if (hasHeart)
              const Icon(
                Icons.favorite,
                color: Colors.red,
                size: 16,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStartPlanningSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Start planning new event',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Create new event tapped')),
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                    color: Colors.amber.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Colors.amber,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Create new event',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildForYouSection() {
    return Column(
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
              title: 'Birthday Template',
              icon: Icons.cake,
              color: Colors.red.shade300,
              onTap: () => _onCardTap('Birthday Template'),
            ),
            _buildTemplateCard(
              title: 'Wedding Template',
              icon: Icons.card_giftcard,
              color: Colors.blue.shade300,
              onTap: () => _onCardTap('Wedding Template'),
            ),
            _buildTemplateCard(
              title: 'Corporate Meeting',
              icon: Icons.business,
              color: Colors.amber,
              onTap: () => _onCardTap('Corporate Meeting'),
            ),
            _buildTemplateCard(
              title: 'Burial Template',
              icon: Icons.home,
              color: Colors.green.shade400,
              onTap: () => _onCardTap('Burial Template'),
            ),
            _buildTemplateCard(
              title: 'Wedding Template',
              icon: Icons.school,
              color: Colors.purple.shade300,
              onTap: () => _onCardTap('Wedding Template'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTemplateCard({
    required String title,
    required IconData icon,
    required Color color,
    required Function() onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
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
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
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
          _buildNavItem(Icons.home, index: 0),
          _buildNavItem(Icons.add, index: 1),
          _buildNavItem(Icons.settings, index: 2),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, {required int index}) {
    final bool isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => _onItemTapped(index),
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: isSelected ? Colors.amber.withOpacity(0.1) : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.amber : Colors.grey,
        ),
      ),
    );
  }
}