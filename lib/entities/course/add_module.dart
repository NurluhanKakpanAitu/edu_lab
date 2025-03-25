import 'package:edu_lab/entities/translation.dart';

class AddModule {
  final Translation title;
  final Translation description;
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
      'title': title.toJson(),
      'description': description.toJson(),
      'videoPath': videoPath,
      'courseId': courseId,
    };
  }
}
