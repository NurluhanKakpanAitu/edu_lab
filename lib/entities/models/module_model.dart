class ModuleModel {
  String id;
  String title;
  String? description;
  String? videoPath;
  String? presentationPath;
  String? taskPath;
  DateTime createdAt;
  int order;
  String courseId;

  ModuleModel({
    required this.id,
    required this.title,
    this.description,
    this.videoPath,
    this.presentationPath,
    this.taskPath,
    required this.createdAt,
    this.order = 0,
    this.courseId = '',
  });

  factory ModuleModel.fromJson(Map<String, dynamic> json) {
    return ModuleModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      videoPath: json['videoPath'] as String?,
      presentationPath: json['presentationPath'] as String?,
      taskPath: json['taskPath'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      order: json['order'] as int? ?? 0,
      courseId: json['courseId'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'video_path': videoPath,
      'presentation_path': presentationPath,
      'task_path': taskPath,
      'created_at': createdAt.toIso8601String(),
      'order': order,
      'courseId': courseId,
    };
  }
}
