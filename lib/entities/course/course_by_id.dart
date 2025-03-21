import 'package:edu_lab/entities/course/module.dart';
import 'package:edu_lab/entities/translation.dart';

class CourseById {
  final String id;
  final Translation title;
  final Translation description;
  final String? imagePath;
  final DateTime createdAt;
  final List<Module> modules;

  CourseById({
    required this.id,
    required this.title,
    required this.description,
    this.imagePath,
    required this.createdAt,
    required this.modules,
  });

  factory CourseById.fromJson(Map<String, dynamic> json) {
    return CourseById(
      id: json['id'],
      title: Translation.fromJson(json['title']),
      description: Translation.fromJson(json['description']),
      imagePath: json['imagePath'],
      createdAt: DateTime.parse(json['createdAt']),
      modules:
          (json['modules'] as List)
              .map((module) => Module.fromJson(module))
              .toList(),
    );
  }
}
