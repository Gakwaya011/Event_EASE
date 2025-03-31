import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
// import '../../../../../core/providers/auth_provider.dart';
import '../../../../../core/providers/event_provider.dart';
import 'map_categories.dart';

class MyEventsSection extends StatefulWidget {
  const MyEventsSection({super.key});

  @override
  _MyEventsSectionState createState() => _MyEventsSectionState();
}

class _MyEventsSectionState extends State<MyEventsSection> {
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

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: eventProvider.eventsParticipating.map((event) {
          return Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: _buildEventCard(context, event),
          );
        }).toList(),
      ),
    );
    });
  }
}

Widget _buildEventCard(BuildContext context, Map<String, dynamic> eventData) {
  final categoryStyle = getCategoryStyle(eventData['category'] ?? 'default');
  final eventProvider = Provider.of<EventProvider>(context, listen: false);

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
          Container(
            width: 30,
            child: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'delete') {
                  _showDeleteConfirmation(context, eventProvider, eventData['id']);
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


void _showDeleteConfirmation(BuildContext context, EventProvider eventProvider, String eventId) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Container(
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
                await eventProvider.deleteEvent(context, eventId); // Pass context here
                await eventProvider.fetchUserEvents(context); // Refresh events
              },
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );
    },
  );
}
