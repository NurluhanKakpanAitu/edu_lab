class Course {
  String? id;
  String title;
  String? description;
  String? imagePath;

  Course({this.id, required this.title, this.description, this.imagePath});

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] as String?,
      title: json['title'] as String,
      description: json['description'] as String?,
      imagePath: json['imagePath'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imagePath': imagePath,
    };
  }
}
