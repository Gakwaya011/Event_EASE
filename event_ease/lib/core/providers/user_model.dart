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
  final List<String> preferedCategory;
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
    required this.preferedCategory,
    required this.role,
  });

  // Factory method to convert Firestore data to UserModel
  factory UserModel.fromFirestore(Map<String, dynamic> data) {
    return UserModel(
      email: data['email'] ?? '',
      createdAt: (data['created_at'] as Timestamp).toDate(),
      name: data['name'] ?? '',
      photoURL: data['photoURL'] ?? '',
      status: data['status'] ?? false,
      eventsCreated: List<String>.from(data['eventsCreated'] ?? []),
      eventsParticipating: List<String>.from(data['eventsParticipating'] ?? []),
      preferedBudget: (data['preferedBudget'] as String?) ?? '',
      preferedCategory: List<String>.from(data['preferedCategory'] ?? []),
      role: List<String>.from(data['role'] ?? []),
    );
  }

  // CopyWith method to create a new instance with updated fields
  UserModel copyWith({
    String? email,
    String? name,
    DateTime? createdAt,
    String? photoURL,
    bool? status,
    List<String>? eventsCreated,
    List<String>? eventsParticipating,
    String? preferedBudget,
    List<String>? preferedCategory,
    List<String>? role,
  }) {
    return UserModel(
      email: email ?? this.email,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      photoURL: photoURL ?? this.photoURL,
      status: status ?? this.status,
      eventsCreated: eventsCreated ?? this.eventsCreated,
      eventsParticipating: eventsParticipating ?? this.eventsParticipating,
      preferedBudget: preferedBudget ?? this.preferedBudget,
      preferedCategory: preferedCategory ?? this.preferedCategory,
      role: role ?? this.role,
    );
  }
}
