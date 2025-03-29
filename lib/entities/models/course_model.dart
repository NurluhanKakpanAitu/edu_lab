import 'package:edu_lab/entities/models/module_model.dart';
import 'package:edu_lab/entities/requests/course_request.dart';

class CourseModel {
  String id;
  String title;
  String? description;
  String? imagePath;
  DateTime createdAt;
  List<ModuleModel> modules;

  CourseModel({
    required this.id,
    required this.title,
    this.description,
    this.imagePath,
    required this.createdAt,
    this.modules = const [],
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      imagePath: json['imagePath'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      modules:
          (json['modules'] as List<dynamic>)
              .map((moduleJson) => ModuleModel.fromJson(moduleJson))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image_path': imagePath,
      'created_at': createdAt.toIso8601String(),
      'modules': modules.map((module) => module.toJson()).toList(),
    };
  }

  static CourseModel fromRequest(String id, CourseRequest request) {
    return CourseModel(
      id: id,
      title: request.title,
      description: request.description,
      imagePath: request.imagePath,
      createdAt: DateTime.now(),
      modules: [],
    );
  }
}
