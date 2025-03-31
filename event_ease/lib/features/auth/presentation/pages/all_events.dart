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
  @override
  void initState() {
    super.initState();
    // Fetch user events when page loads
    Future.microtask(() => 
      Provider.of<EventProvider>(context, listen: false).fetchUserEvents(context)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Events'),
        backgroundColor: Colors.amber[300],
      ),
      body: Consumer<EventProvider>(
        builder: (context, eventProvider, child) {
          if (eventProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
              ),
            );
          }

          // Use the eventsParticipating list (List<Map<String, dynamic>>)
          final events = eventProvider.eventsParticipating;
          if (events.isEmpty) {
            return const Center(child: Text("No events found"));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16.0),
            itemCount: events.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final eventData = events[index];
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
      bottomNavigationBar: const CustomBottomBar(),
    );
  }
}
