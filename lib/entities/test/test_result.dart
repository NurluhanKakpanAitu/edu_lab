class TestResult {
  final String questionId;
  final String answerId;
  final bool isCorrect;

  TestResult({
    required this.questionId,
    required this.answerId,
    required this.isCorrect,
  });

  factory TestResult.fromJson(Map<String, dynamic> json) {
    return TestResult(
      questionId: json['questionId'],
      answerId: json['answerId'],
      isCorrect: json['isCorrect'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'answerId': answerId,
      'isCorrect': isCorrect,
    };
  }
}
