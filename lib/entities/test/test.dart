import 'package:edu_lab/entities/test/question.dart';
import 'package:edu_lab/entities/translation.dart';

class Test {
  final Translation title;
  final List<Question> questions;
  final String moduleId;
  final String id;

  Test({
    required this.title,
    required this.questions,
    required this.moduleId,
    required this.id,
  });

  factory Test.fromJson(Map<String, dynamic> json) {
    return Test(
      title: Translation.fromJson(json['title']),
      questions:
          (json['questions'] as List<dynamic>)
              .map((question) => Question.fromJson(question))
              .toList(),
      moduleId: json['moduleId'],
      id: json['id'],
    );
  }
}
