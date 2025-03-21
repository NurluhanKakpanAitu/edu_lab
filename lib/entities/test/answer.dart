import 'package:edu_lab/entities/translation.dart';

class Answer {
  final Translation title;
  final bool isCorrect;
  final String? imagePath;
  final String id;

  Answer({
    required this.title,
    required this.isCorrect,
    this.imagePath,
    required this.id,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      title: Translation.fromJson(json['title']),
      isCorrect: json['isCorrect'] ?? false,
      imagePath: json['imagePath'],
      id: json['id'],
    );
  }
}
