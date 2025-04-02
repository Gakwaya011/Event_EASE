class TaskModel {
  final String title;
  bool completed;

  TaskModel({required this.title, this.completed = false});

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      title: json['task'] ?? '',
      completed: json['completed'] ?? false,
    );
  }
}
