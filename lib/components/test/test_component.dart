import 'package:edu_lab/app_localizations.dart';
import 'package:edu_lab/entities/test/test_result.dart';
import 'package:flutter/material.dart';
import 'package:edu_lab/entities/test/test.dart';

class TestComponent extends StatelessWidget {
  final Test test;
  final Locale locale;
  final List<TestResult> selectedAnswers;
  final Function(String questionId, String answerId, bool isCorrect)
  onAnswerSelected;
  final VoidCallback onSubmit;
  final bool blockSubmit;

  const TestComponent({
    super.key,
    required this.test,
    required this.locale,
    required this.selectedAnswers,
    required this.onAnswerSelected,
    required this.onSubmit,
    required this.blockSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
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
                  groupValue:
                      selectedAnswers
                          .firstWhere(
                            (selectedAnswer) =>
                                selectedAnswer.questionId == question.id,
                            orElse:
                                () => TestResult(
                                  questionId: question.id,
                                  answerId: '',
                                  isCorrect: false,
                                ),
                          )
                          .answerId,
                  onChanged: (value) {
                    if (value != null) {
                      onAnswerSelected(question.id, value, answer.isCorrect);
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
          onPressed: blockSubmit ? null : onSubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: Text(
            localizations.translate('submit'),
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
