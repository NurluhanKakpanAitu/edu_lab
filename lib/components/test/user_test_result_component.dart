import 'package:edu_lab/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:edu_lab/entities/test/user_test_result.dart';

class UserTestResultComponent extends StatelessWidget {
  final UserTestResult userTestResult;

  const UserTestResultComponent({super.key, required this.userTestResult});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          localizations.translate('testResult'),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          '${localizations.translate('score')}: ${userTestResult.score}/${userTestResult.maxScore}',
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
