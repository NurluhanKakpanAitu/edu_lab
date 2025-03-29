class AddModule {
  final String title;
  final String? description;
  final String? videoPath;
  final String courseId;

  AddModule({
    required this.title,
    required this.description,
    this.videoPath,
    required this.courseId,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'videoPath': videoPath,
      'courseId': courseId,
    };
  }
}
