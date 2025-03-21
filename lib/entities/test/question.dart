import 'package:edu_lab/entities/test/answer.dart';
import 'package:edu_lab/entities/translation.dart';

class Question {
  final Translation title;
  final String? imagePath;
  final List<Answer> answers;
  final String id;

  Question({
    required this.title,
    this.imagePath,
    required this.answers,
    required this.id,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      title: Translation.fromJson(json['title']),
      imagePath: json['imagePath'],
      answers:
          (json['answers'] as List<dynamic>)
              .map((answer) => Answer.fromJson(answer))
              .toList(),
      id: json['id'],
    );
  }
}
