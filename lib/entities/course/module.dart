class Module {
  final String id;
  final String title;
  final String? description;
  final String? videoPath;
  final int order;
  final DateTime createdAt;
  final String courseId;
  final String? taskPath;

  Module({
    required this.id,
    required this.title,
    this.description,
    this.videoPath,
    required this.order,
    required this.createdAt,
    required this.courseId,
    this.taskPath,
  });

  factory Module.fromJson(Map<String, dynamic> json) {
    return Module(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      videoPath: json['videoPath'],
      order: json['order'],
      createdAt: DateTime.parse(json['createdAt']),
      courseId: json['courseId'],
      taskPath: json['taskPath'],
    );
  }
}
