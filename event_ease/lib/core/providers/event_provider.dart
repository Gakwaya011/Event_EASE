import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/auth_provider.dart';

class EventProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> createEvent({
  required BuildContext context,
  String? name,
  String? description,
  String? location,
  DateTime? selectedDate,
  TimeOfDay? startTime,
  TimeOfDay? endTime,
  List<String>? tasks,
  String? selectedGuestRange,
  String? selectedBudget,
  String? selectedCategory,
  int? selectedReminder,
  List<String>? participants,
}) async {
  try {
    // Fetch current user's email from AuthProvider
    String? userEmail = Provider.of<AuthProvider>(context, listen: false).userData?.email;
    String? userId = Provider.of<AuthProvider>(context, listen: false).currentUser?.uid;

    // If no user is logged in, return null
    if (userEmail == null || userId == null) return null;

    // Add the creator's email to the participants list if not already included
    participants ??= [];
    if (!participants.contains(userEmail)) {
      participants.add(userEmail);
    }

    // Create the event document in Firestore
    DocumentReference eventRef = await _firestore.collection('events').add({
      "name": name?.trim(),
      "description": description?.trim(),
      "location": location,
      "date": Timestamp.fromDate(selectedDate!),
      "startTime": {
        "hour": startTime!.hour,
        "minute": startTime.minute,
      },
      "endTime": {
        "hour": endTime!.hour,
        "minute": endTime.minute,
      },
      "tasks": tasks,
      "guestRange": selectedGuestRange,
      "budget": selectedBudget,
      "category": selectedCategory,
      "reminderMinutes": selectedReminder,
      "participants": participants,  // Updated participants list
      "createdAt": FieldValue.serverTimestamp(),
    });

    // Now, we need to loop through the participants' emails and update their `eventsParticipating`
    for (String participantEmail in participants) {
      // Fetch the user ID for each participant
      QuerySnapshot userSnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: participantEmail)
          .get();

      // If the user exists, update their eventsParticipating
      if (userSnapshot.docs.isNotEmpty) {
        String participantUserId = userSnapshot.docs.first.id;

        // Update the participant's `eventsParticipating` list
        await _firestore.collection('users').doc(participantUserId).update({
          'eventsParticipating': FieldValue.arrayUnion([eventRef.id]),
        });
      }
    }

    // Add the event ID to the creator's `eventsCreated` list
    await _firestore.collection('users').doc(userId).update({
      'eventsCreated': FieldValue.arrayUnion([eventRef.id]),
    });

    // Update the AuthProvider for the current user with the new event IDs
    Provider.of<AuthProvider>(context, listen: false).updateUserEvents([eventRef.id]);

    // Force a UI update by notifying listeners
    notifyListeners();

    return eventRef.id;
  } catch (e) {
    print("Error creating event: $e");
    return null;
  }
}


}
