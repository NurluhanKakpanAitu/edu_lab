class PracticeWorkResult {
  late String answer;
  late String explanation;
  late bool isCorrect;

  PracticeWorkResult({
    required this.answer,
    required this.explanation,
    required this.isCorrect,
  });

  static PracticeWorkResult fromJson(Map<String, dynamic> json) {
    return PracticeWorkResult(
      answer: json['answer'],
      explanation: json['explanation'],
      isCorrect: json['isCorrect'],
    );
  }
}
