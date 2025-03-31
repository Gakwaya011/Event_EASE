
import 'package:flutter/material.dart';
import 'task_model.dart';

class EventModel {
  final String id;
  final String title;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String location;
  final String description;
  final String guestRange;
  final String budget;
  final List<TaskModel> tasks;
  final List<String> participants;
  final String category;
  final int reminder;

  EventModel({
    required this.id,
    required this.title,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.description,
    required this.budget,
    required this.tasks,
    required this.participants,
    required this.category,
    required this.reminder,
    required this.guestRange,

  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'],
      title: json['name'],
      date: DateTime.parse(json['date']),
      startTime: TimeOfDay(
        hour: int.parse(json['time'].split(":")[0]),
        minute: int.parse(json['time'].split(":")[1]),
      ),
      endTime: TimeOfDay(
        hour: int.parse(json['endTime'].split(":")[0]),
        minute: int.parse(json['endTime'].split(":")[1]),
      ),
      location: json['location'],
      description: json['description'],
      guestRange: json['guestRange'],
      budget: json['budget'], 
      tasks: (json['tasks'] as List).map((task) => TaskModel.fromJson(task)).toList(),
      participants: List<String>.from(json['participants']),
      category: json['category'],
      reminder: json['reminderMinutes'],
    );
  }
}
