import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:event_ease/core/providers/event_provider.dart';
import 'package:event_ease/features/auth/presentation/widgets/bottom_bar.dart';
import '../widgets/dashboard/map_categories.dart';

class AllEventsPage extends StatefulWidget {
  const AllEventsPage({Key? key}) : super(key: key);

  @override
  _AllEventsPageState createState() => _AllEventsPageState();
}

class _AllEventsPageState extends State<AllEventsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Fetch user events when page loads
    Future.microtask(() => 
      Provider.of<EventProvider>(context, listen: false).fetchUserEvents(context)
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Filter events based on search query
  List<Map<String, dynamic>> _filterEvents(List<Map<String, dynamic>> events) {
    if (_searchQuery.isEmpty) {
      return events;
    }
    
    final query = _searchQuery.toLowerCase();
    return events.where((event) {
      final name = (event['name'] ?? '').toString().toLowerCase();
      final category = (event['category'] ?? '').toString().toLowerCase();
      final location = (event['location'] ?? '').toString().toLowerCase();
      
      return name.contains(query) || 
             category.contains(query) || 
             location.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Events'),
        backgroundColor: Colors.amber[300],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search events...',
                prefixIcon: const Icon(Icons.search, color: Colors.amber),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.amber[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.amber[100]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.amber[300]!),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          
          // Events List
          Expanded(
            child: Consumer<EventProvider>(
              builder: (context, eventProvider, child) {
                if (eventProvider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                    ),
                  );
                }

                // Filter events based on search query
                final events = eventProvider.eventsParticipating;
                final filteredEvents = _filterEvents(events);
                
                if (events.isEmpty) {
                  return const Center(child: Text("No events found"));
                }
                
                if (filteredEvents.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 64, color: Colors.amber[300]),
                        const SizedBox(height: 16),
                        Text(
                          "No events match your search",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: filteredEvents.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final eventData = filteredEvents[index];
                    final categoryStyle = getCategoryStyle(eventData['category'] ?? 'default');

                    return GestureDetector(
                      onTap: () => context.push('/single_event/${eventData['id']}'),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              // Category Icon
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: categoryStyle['color'].withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  categoryStyle['icon'],
                                  color: categoryStyle['color'],
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Event name and date
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      eventData['name'] ?? 'Unnamed Event',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_today,
                                          size: 12,
                                          color: Colors.grey.shade600,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          // Format the date if available
                                          eventData['date'] != null
                                              ? DateFormat('MMM dd, yyyy').format(
                                                  (eventData['date'] as Timestamp).toDate())
                                              : 'No date',
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 12,
                                          ),
                                        ),
                                        if (eventData['location'] != null) ...[
                                          const SizedBox(width: 8),
                                          Icon(
                                            Icons.location_on,
                                            size: 12,
                                            color: Colors.grey.shade600,
                                          ),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              eventData['location'],
                                              style: TextStyle(
                                                color: Colors.grey.shade600,
                                                fontSize: 12,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // Optionally add an arrow icon
                              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomBar(),
    );
  }
}