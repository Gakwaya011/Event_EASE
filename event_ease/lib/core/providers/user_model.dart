import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String email;
  final String name;
  final DateTime createdAt;
  final String photoURL;
  final bool status;
  final List<String> eventsCreated;
  final List<String> eventsParticipating;
  final String preferedBudget;
  final List<String> preferedEvents;
  final List<String> role;


  UserModel({
    required this.email,
    required this.name,
    required this.createdAt,
    required this.photoURL,
    required this.status,
    required this.eventsCreated, 
    required this.eventsParticipating,
    required this.preferedBudget,
    required this.preferedEvents,
    required this.role
  });

  // You can create a method to convert Firestore data into this model.
  factory UserModel.fromFirestore(Map<String, dynamic> data) {
    return UserModel(
      email: data['email'] ?? '',
      createdAt: (data['created_at'] as Timestamp).toDate(),
      name: data['name'] ?? '',
      photoURL: data['photoURL'] ?? '',
      status: data['status'] ?? false,
      eventsCreated: List<String>.from(data['eventsCreated'] ?? []),
      eventsParticipating: List<String>.from(data['eventsParticipating'] ?? []),
      preferedBudget: data['preferedBudget'] ?? '',
      preferedEvents: List<String>.from(data['preferedEvents'] ?? []),
      role: List<String>.from(data['role'] ?? [])
    );
  }
}
