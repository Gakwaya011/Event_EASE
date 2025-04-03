import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:event_ease/core/providers/auth_provider.dart';

// Importing the UI widgets
import '../widgets/dashboard/appbar.dart';
import '../widgets/bottom_bar.dart';
import '../widgets/dashboard/event_card.dart';
import '../widgets/dashboard/template_card.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String _searchQuery = ''; 

  void _onSearchChanged(String query) { 
    setState(() {
      _searchQuery = query;
    });
  }

  @override
  void initState() {
    super.initState();
    _checkAuthenticationStatus();
  }

  void _checkAuthenticationStatus() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      // Wait until the user data is fully loaded
    if (authProvider.isLoading) return;

    // Redirect only if user is NOT authenticated
    if (authProvider.userData == null) {
      context.go('/login');
    }
    else if (authProvider.userData!.status == false) {
      context.go('/onboarding');
    }
    });
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App Bar
              CustomAppBar(),
              
              // Search Bar
              // CustomSearchBar(onSearchChanged: _onSearchChanged),
              
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        
                        // My Events Section
                        MyEventsSection(searchQuery: _searchQuery),
                        
                        const SizedBox(height: 24),
                        
                        // Start Planning Section
                        _buildStartPlanningSection(context),
                        
                        const SizedBox(height: 24),
                        
                        // For You Section
                        forYouSection(),
                        
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Bottom Navigation
              CustomBottomBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStartPlanningSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
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
          GestureDetector(
            onTap: () => context.push('/create_event'),
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
      ),
    );
  }
}
