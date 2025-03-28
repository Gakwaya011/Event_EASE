import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String email;
  final String name;
  final DateTime createdAt;
  final String photoURL;
  final List<String> eventsCreated;
  final List<String> eventsParticipating;

  UserModel({
    required this.email,
    required this.name,
    required this.createdAt,
    required this.photoURL,
    required this.eventsCreated, 
    required this.eventsParticipating
  });

  // You can create a method to convert Firestore data into this model.
  factory UserModel.fromFirestore(Map<String, dynamic> data) {
    return UserModel(
      email: data['email'] ?? '',
      createdAt: (data['created_at'] as Timestamp).toDate(),
      name: data['name'] ?? '',
      photoURL: data['photoURL'] ?? '',
      eventsCreated: List<String>.from(data['eventsCreated'] ?? []),
      eventsParticipating: List<String>.from(data['eventsParticipating'] ?? []),
    );
  }
}
