import 'package:edu_lab/entities/course/add_course.dart';
import 'package:edu_lab/entities/translation.dart';

class Course {
  String? id;
  Translation? title;
  Translation? description;
  String? imagePath;

  Course({this.id, this.title, this.description, this.imagePath});

  Course.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = Translation.fromJson(json['title']);
    description = Translation.fromJson(json['description']);
    imagePath = json['imagePath'];
  }

  static Course fromModal(AddCourse addCourse, String id) {
    return Course(
      id: id,
      title: addCourse.title,
      description: addCourse.description,
      imagePath: addCourse.imagePath,
    );
  }
}
