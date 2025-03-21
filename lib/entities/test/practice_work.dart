import 'package:edu_lab/entities/translation.dart';

class PracticeWork {
  late String id;
  late Translation title;
  late Translation description;
  late String? imagePath;

  PracticeWork({
    required this.id,
    required this.title,
    required this.description,
    this.imagePath,
  });

  PracticeWork.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = Translation.fromJson(json['title']);
    description = Translation.fromJson(json['description']);
    imagePath = json['imagePath'];
  }
}
