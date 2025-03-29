class CourseRequest {
  String title;
  String? description;
  String? imagePath;

  CourseRequest({required this.title, this.description, this.imagePath});

  Map<String, dynamic> toJson() {
    return {'title': title, 'description': description, 'imagePath': imagePath};
  }

  factory CourseRequest.fromJson(Map<String, dynamic> json) {
    return CourseRequest(
      title: json['title'] as String,
      description: json['description'] as String?,
      imagePath: json['imagePath'] as String?,
    );
  }
}
