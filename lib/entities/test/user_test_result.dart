class UserTestResult {
  final int maxScore;
  final int score;

  UserTestResult({required this.maxScore, required this.score});

  factory UserTestResult.fromJson(Map<String, dynamic> json) {
    return UserTestResult(maxScore: json['maxScore'], score: json['score']);
  }

  Map<String, dynamic> toJson() {
    return {'maxScore': maxScore, 'score': score};
  }
}
