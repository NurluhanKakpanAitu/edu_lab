import 'package:flutter/material.dart';
import 'package:edu_lab/entities/test/test.dart';

class TestComponent extends StatelessWidget {
  final Test test;
  final Locale locale;
  final Map<String, String> selectedAnswers;
  final Function(String questionId, String answerId) onAnswerSelected;
  final VoidCallback onSubmit;

  const TestComponent({
    super.key,
    required this.test,
    required this.locale,
    required this.selectedAnswers,
    required this.onAnswerSelected,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          test.title.getTranslation(locale.languageCode) ?? 'No Title',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...test.questions.map((question) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                question.title.getTranslation(locale.languageCode) ??
                    'No Question',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              ...question.answers.map((answer) {
                return RadioListTile<String>(
                  title: Text(
                    answer.title.getTranslation(locale.languageCode) ??
                        'No Answer',
                  ),
                  value: answer.id,
                  groupValue: selectedAnswers[question.id],
                  onChanged: (value) {
                    if (value != null) {
                      onAnswerSelected(question.id, value);
                    }
                  },
                );
              }),
              const SizedBox(height: 16),
            ],
          );
        }),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: onSubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: const Text(
            'Submit',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const Divider(),
      ],
    );
  }
}
