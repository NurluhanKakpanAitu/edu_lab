import 'package:edu_lab/entities/translation.dart';

class Module {
  final String id;
  final Translation? title;
  final Translation? description;
  final String? videoPath;
  final int order;
  final DateTime createdAt;
  final String courseId;

  Module({
    required this.id,
    required this.title,
    required this.description,
    this.videoPath,
    required this.order,
    required this.createdAt,
    required this.courseId,
  });

  factory Module.fromJson(Map<String, dynamic> json) {
    return Module(
      id: json['id'],
      title: Translation.fromJson(json['title']),
      description: Translation.fromJson(json['description']),
      videoPath: json['videoPath'],
      order: json['order'],
      createdAt: DateTime.parse(json['createdAt']),
      courseId: json['courseId'],
    );
  }
}
