class ModuleRequest {
  String title;
  String? description;
  String? videoPath;
  String? presentationPath;
  String? taskPath;
  String courseId;

  ModuleRequest({
    required this.title,
    this.description,
    this.videoPath,
    this.presentationPath,
    this.taskPath,
    required this.courseId,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'video_path': videoPath,
      'presentation_path': presentationPath,
      'task_path': taskPath,
      'course_id': courseId,
    };
  }
}
