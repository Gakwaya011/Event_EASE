import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'map_categories.dart';
import '../../../../../core/providers/event_provider.dart';
import 'search_bar.dart';

class MyEventsSection extends StatefulWidget {
  final String searchQuery; // Accept search query

  const MyEventsSection({super.key, required this.searchQuery});

  @override
  _MyEventsSectionState createState() => _MyEventsSectionState();
}

class _MyEventsSectionState extends State<MyEventsSection> {
  String _searchQuery = ''; // Store search query


  @override
  void initState() {
    super.initState();
    Future.microtask(() => 
      Provider.of<EventProvider>(context, listen: false).fetchUserEvents(context)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EventProvider>(
      builder: (context, eventProvider, child) {
        if (eventProvider.isLoading) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
            ),
          );
        }

        if (eventProvider.eventsParticipating.isEmpty) {
          return Center(child: Text("No events found"));
        }

        List<Map<String, dynamic>> filteredEvents = eventProvider.eventsParticipating
            .where((event) => event['name']
                .toString()
                .toLowerCase()
                .contains(_searchQuery.toLowerCase())) // Filter by search input
            .toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             // SEARCH BAR
            CustomSearchBar(
              onSearchChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
            ),
            // Title Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              child: GestureDetector(
                onTap: () => context.push('/all_events'), // Navigate to All Events Page
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Your Events',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward,
                      size: 16,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),

            // Event Cards Section
            filteredEvents.isEmpty
                ? Center(child: Text("No matching events"))
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: filteredEvents.map((event) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: _buildEventCard(context, event),
                        );
                      }).toList(),
                    ),
                  ),
          ],
        );
      },
    );
  }

  Widget _buildEventCard(BuildContext context, Map<String, dynamic> eventData) {
    final categoryStyle = getCategoryStyle(eventData['category'] ?? 'default');

    return GestureDetector(
      onTap: () => context.push('/single_event/${eventData['id']}'), // Navigate to event details
      child: Container(
        width: 140,
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
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
            // Category Icon
            Container(
              height: 25,
              width: 25,
              decoration: BoxDecoration(
                color: categoryStyle['color'].withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                categoryStyle['icon'],
                color: categoryStyle['color'],
                size: 20,
              ),
            ),
            const SizedBox(width: 8),

            // Event Name
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    eventData['name'] ?? 'Unnamed Event',
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

            // Three-Dot Menu
            SizedBox(
              width: 30,
              child: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'delete') {
                    _showDeleteConfirmation(context, eventData['id']);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Colors.red),
                        SizedBox(width: 8),
                        Text("Delete", style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
                icon: const Icon(Icons.more_vert, size: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String eventId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          width: 20,
          height: 20,
          child: AlertDialog(
            title: const Text("Confirm Deletion"),
            content: const Text("Are you sure you want to delete this event?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(), // Close the dialog
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop(); // Close the dialog
                  await Provider.of<EventProvider>(context, listen: false).deleteEvent(context, eventId); // Pass context here
                  await Provider.of<EventProvider>(context, listen: false).fetchUserEvents(context); // Refresh events
                },
                child: const Text("Delete", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
      },
    );
  }
}
