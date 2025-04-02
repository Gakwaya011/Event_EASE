import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/auth_provider.dart';

import '../models/event_model.dart';
import '../models/task_model.dart';

class EventProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> _eventsParticipating = [];
  bool _isLoading = true;

  List<Map<String, dynamic>> get eventsParticipating => _eventsParticipating;
  bool get isLoading => _isLoading;

  /// Fetches events for the logged-in user
  Future<void> fetchUserEvents(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      String? userId = authProvider.currentUser?.uid;

      if (userId == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }

      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userId).get();

      if (!userDoc.exists) {
        _isLoading = false;
        notifyListeners();
        return;
      }

      List<String> eventsParticipatingIds =
          List<String>.from(userDoc.get('eventsParticipating') ?? []);

      // Fetch participating events
      _eventsParticipating = await _fetchEventsByIds(eventsParticipatingIds);
    } catch (e) {
      print("Error fetching events: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Fetches events from Firestore by their IDs
  Future<List<Map<String, dynamic>>> _fetchEventsByIds(List<String> eventIds) async {
    if (eventIds.isEmpty) return [];

    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('events')
          .where(FieldPath.documentId, whereIn: eventIds)
          .get();

      return querySnapshot.docs
          .map((doc) => {"id": doc.id, ...doc.data() as Map<String, dynamic>})
          .toList();
    } catch (e) {
      print("Error fetching events by IDs: $e");
      return [];
    }
  }


  List<EventModel> _events = [];

  List<EventModel> get events => _events;

  EventModel? getEventById(String eventId) {
  return _events.isNotEmpty && _events.any((event) => event.id == eventId)
      ? _events.firstWhere((event) => event.id == eventId)
      : null;
}
  
  /// Fetches a single event from Firestore by its ID
Future<void> fetchEventById(String eventId) async {
  try {
    final doc = await FirebaseFirestore.instance.collection('events').doc(eventId).get();

    if (!doc.exists || doc.data() == null) {
      print("Error: Event not found in Firestore");
      return;
    }

    final data = doc.data()!; // Now we are sure it's not null

    final event = EventModel(
      id: doc.id,
      title: data['name'] ?? '',
      date: (data['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      startTime:  TimeOfDay(
        hour: (data['startTime'] as Map<String, dynamic>?)?['hour'] ?? 0,
        minute: (data['startTime'] as Map<String, dynamic>?)?['minute'] ?? 0,
      ),
      endTime: TimeOfDay(
        hour: (data['endTime'] as Map<String, dynamic>?)?['hour'] ?? 0,
        minute: (data['endTime'] as Map<String, dynamic>?)?['minute'] ?? 0,
      ),
      location: data['location'] ?? '',
      description: data['description'] ?? '',
      budget: data['budget'] ?? '',
      tasks: (data['tasks'] as List<dynamic>?)
          ?.map((task) => TaskModel(
                title: task['task'] ?? '',
                completed: task['completed'] ?? false,
              ))
          .toList() ?? [],
      guestRange: data['guestRange'] ?? '',
      category: data['category'] ?? '',
      participants: (data['participants'] as List<dynamic>?)
          ?.map((participant) => participant as String)
          .toList() ?? [],
      reminder: data['reminderMinutes'] ?? 0,
    );

    // Check if event already exists and replace it
    int index = _events.indexWhere((e) => e.id == event.id);
    if (index != -1) {
      _events[index] = event; // Replace existing event
    } else {
      _events.add(event); // Add new event if not found
    }
    
    notifyListeners();
  } catch (e) {
    print("Error fetching event: $e");
  }
}





   Future<String?> createEvent({
  required BuildContext context,
  String? name,
  String? description,
  String? location,
  DateTime? selectedDate,
  TimeOfDay? startTime,
  TimeOfDay? endTime,
  List<TaskModel>? tasks,
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

     // Convert TaskModel list to Map format for Firestore
    List<Map<String, dynamic>> taskList = tasks?.map((task) {
      return {
        'task': task.title,
        'completed': task.completed,
      };
    }).toList() ?? [];

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
      "tasks": taskList,
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

     // Immediately fetch user events again to refresh data
    await Provider.of<EventProvider>(context, listen: false).fetchUserEvents(context);

    // Force a UI update by notifying listeners
    notifyListeners();

    return eventRef.id;
  } catch (e) {
    print("Error creating event: $e");
    return null;
  }
}

  Future<bool> updateEvent({
  required BuildContext context,
  required String eventId, // Make eventId required since you need it
  String? name,
  String? description,
  String? location,
  DateTime? selectedDate,
  TimeOfDay? startTime,
  TimeOfDay? endTime,
  List<TaskModel>? tasks,
  String? selectedGuestRange,
  String? selectedBudget,
  String? selectedCategory,
  int? selectedReminder,
  List<String>? participants,
}) async {
  try {
    // Convert TaskModel list to Map format for Firestore
    List<Map<String, dynamic>> taskList = tasks?.map((task) {
      return {
        'task': task.title,
        'completed': task.completed,
      };
    }).toList() ?? [];

    // Ensure date and time are not null before updating
    if (selectedDate == null || startTime == null || endTime == null) {
      print("Error: Date or time is null.");
      return false;
    }

    // Update the event document in Firestore
    await _firestore.collection('events').doc(eventId).update({
      "name": name?.trim(),
      "description": description?.trim(),
      "location": location,
      "date": Timestamp.fromDate(selectedDate),
      "startTime": {
        "hour": startTime.hour,
        "minute": startTime.minute,
      },
      "endTime": {
        "hour": endTime.hour,
        "minute": endTime.minute,
      },
      "tasks": taskList,
      "guestRange": selectedGuestRange,
      "budget": selectedBudget,
      "category": selectedCategory,
      "reminderMinutes": selectedReminder,
      "participants": participants,
      "updatedAt": FieldValue.serverTimestamp(), // Changed from createdAt
    });

    // fetch this event after updating it
    await fetchEventById(eventId);

    notifyListeners();
    print("Event updated successfully");
    return true; // Indicate success
  } catch (e) {
    print("Error updating event: $e");
    return false; // Indicate failure
  }
}

// update status of the task
Future<void> updateTaskStatus(String eventId, TaskModel updatedTask) async {
  try {
    final eventRef = FirebaseFirestore.instance.collection('events').doc(eventId);
    
    // Fetch the current event data from Firestore
    final eventSnapshot = await eventRef.get();
    if (!eventSnapshot.exists) return;

    List<dynamic> tasks = eventSnapshot.data()?['tasks'] ?? [];
    
    // Update the specific task in the list
    for (var task in tasks) {
      if (task['task'] == updatedTask.title) {
        task['completed'] = updatedTask.completed;
      }
    }

    // Save the updated task list back to Firestore
    await eventRef.update({'tasks': tasks});
    notifyListeners(); // Notify UI about the change

    print('Task status updated successfully');
  } catch (e) {
    print('Error updating task status: $e');
  }
}



  Future<void> deleteEvent(BuildContext context, String eventId) async {
  try {
    // Delete the event from Firestore
    await FirebaseFirestore.instance.collection('events').doc(eventId).delete();

    // Remove event from both lists
    _events.removeWhere((event) => event.id == eventId);
    _eventsParticipating.removeWhere((event) => event['id'] == eventId);

    // Notify listeners to update UI
    notifyListeners();
  } catch (e) {
    print("Error deleting event: $e");
  }
}









  
}

