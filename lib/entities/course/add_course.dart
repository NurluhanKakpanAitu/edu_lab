import 'package:edu_lab/entities/translation.dart';

class AddCourse {
  final Translation title;
  final Translation description;
  final String? imagePath;

  AddCourse({
    required this.title,
    required this.description,
    required this.imagePath,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title.toJson(),
      'description': description.toJson(),
      'imagePath': imagePath,
    };
  }
}
