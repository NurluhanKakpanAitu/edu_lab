import 'package:flutter/material.dart';
import 'package:edu_lab/entities/test/practice_work_result.dart';

class PracticeWorkResultComponent extends StatelessWidget {
  final PracticeWorkResult practiceWorkResult;

  const PracticeWorkResultComponent({
    super.key,
    required this.practiceWorkResult,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Text(
          'Нәтиже:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Жауап: ${practiceWorkResult.answer}',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),
        Text(
          'Түсіндірме: ${practiceWorkResult.explanation}',
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        Text(
          'Дұрыс па: ${practiceWorkResult.isCorrect ? 'Иә' : 'Жоқ'}',
          style: TextStyle(
            fontSize: 16,
            color: practiceWorkResult.isCorrect ? Colors.green : Colors.red,
          ),
        ),
      ],
    );
  }
}
