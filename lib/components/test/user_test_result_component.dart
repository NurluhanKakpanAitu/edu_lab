import 'package:flutter/material.dart';
import 'package:edu_lab/entities/test/user_test_result.dart';

class UserTestResultComponent extends StatelessWidget {
  final UserTestResult userTestResult;

  const UserTestResultComponent({super.key, required this.userTestResult});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          'Test Result:',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Score: ${userTestResult.score} / ${userTestResult.maxScore}',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: userTestResult.score / userTestResult.maxScore,
          backgroundColor: Colors.grey[300],
          color: Colors.blue,
        ),
      ],
    );
  }
}
