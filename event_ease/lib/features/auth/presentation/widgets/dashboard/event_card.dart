import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'map_categories.dart';
import '../../../../../core/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class MyEventsSection extends StatefulWidget {
  const MyEventsSection({super.key});

  @override
  _MyEventsSectionState createState() => _MyEventsSectionState();
}

class _MyEventsSectionState extends State<MyEventsSection> {
  List<Map<String, dynamic>> events = [];

  @override
  void initState() {
    super.initState();
  }

  @override
Widget build(BuildContext context) {
  final authProvider = Provider.of<AuthProvider>(context);
  final participatingEventIds = authProvider.userData?.eventsParticipating ?? [];

  // If there are no participating event IDs, show a message
  if (participatingEventIds.isEmpty) {
    return Center(child: Text("No events found"));
  }

  return StreamBuilder(
     // If there are participating event IDs, filter by them
    stream: participatingEventIds.isNotEmpty
        ? FirebaseFirestore.instance
            .collection('events')
            .where(FieldPath.documentId, whereIn: participatingEventIds)
            .snapshots()
        : FirebaseFirestore.instance.collection('events').snapshots(), 
    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
          ),
        );
      }
      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        return Center(child: Text("No events found"));
      }

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: snapshot.data!.docs.map((event) {
            return Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: _buildEventCard(context, event.data() as Map<String, dynamic>),
            );
          }).toList(),
        ),
      );
    },
  );
}

}

Widget _buildEventCard(BuildContext context, Map<String, dynamic> eventData) {
  final categoryStyle = getCategoryStyle(eventData['category'] ?? 'default');

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
        ],
      ),
    ),
  );
}
