class Task {
  late String id;
  late String title;
  late bool completed;

  Task({required this.id, required this.title, required this.completed});

  Task.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    title = json['title'] ?? "";
    completed = json['completed'] ?? true;
  }
}
