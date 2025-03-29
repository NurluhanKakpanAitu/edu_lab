class ModuleRequest {
  String title;
  String? description;
  String? videoPath;
  String? presentationPath;
  String? taskPath;
  String courseId;
  int order;

  ModuleRequest({
    required this.title,
    this.description,
    this.videoPath,
    this.presentationPath,
    this.taskPath,
    required this.courseId,
    this.order = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'videoPath': videoPath,
      'presentationPath': presentationPath,
      'taskPath': taskPath,
      'courseId': courseId,
      'order': order,
    };
  }
}
