import 'package:flutter/material.dart';
import 'package:edu_lab/entities/test/practice_work.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart'; // Ensure this is present
import 'package:highlight/languages/python.dart'; // For Python syntax highlighting

class PracticeWorkComponent extends StatelessWidget {
  final PracticeWork practiceWork;
  final Locale locale;
  final TextEditingController codeController;
  final VoidCallback onSubmit;

  const PracticeWorkComponent({
    super.key,
    required this.practiceWork,
    required this.locale,
    required this.codeController,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final codeEditorController = CodeController(
      text:
          codeController.text.isEmpty
              ? '# Write your Python code here...'
              : codeController.text,
      language: python,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          practiceWork.title.getTranslation(locale.languageCode) ?? 'No Title',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 30),
        Text(
          practiceWork.description.getTranslation(locale.languageCode) ??
              'No Description',
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 20),
        Text(
          'Code Editor',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(4),
          ),
          child: CodeField(
            controller: codeEditorController,
            onChanged: (value) {
              codeController.text = value;
            },
          ),
        ),
        const SizedBox(height: 16),
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
      ],
    );
  }
}
