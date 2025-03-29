class AddCourse {
  final String title;
  final String? description;
  final String? imagePath;

  AddCourse({
    required this.title,
    required this.description,
    required this.imagePath,
  });

  Map<String, dynamic> toJson() {
    return {'title': title, 'description': description, 'imagePath': imagePath};
  }
}
