import 'package:edu_lab/app_localizations.dart';
import 'package:edu_lab/components/shared/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:edu_lab/entities/test/practice_work.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart'; // Ensure this is present
import 'package:highlight/languages/python.dart'; // For Python syntax highlighting

class PracticeWorkComponent extends StatelessWidget {
  final PracticeWork practiceWork;
  final Locale locale;
  final TextEditingController codeController;
  final VoidCallback onSubmit;
  final bool isLoaded;

  const PracticeWorkComponent({
    super.key,
    required this.practiceWork,
    required this.locale,
    required this.codeController,
    required this.onSubmit,
    required this.isLoaded,
  });

  @override
  Widget build(BuildContext context) {
    // Initialize the CodeController with the current text in codeController
    final codeEditorController = CodeController(
      text: codeController.text.isEmpty ? '' : codeController.text,
      language: python,
    );

    final localizations = AppLocalizations.of(context);

    return !isLoaded
        ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              practiceWork.title.getTranslation(locale.languageCode) ??
                  'No Title',
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
                expands: true,
                onChanged: (value) {
                  codeController.text = value;
                },
                textStyle: const TextStyle(fontSize: 14, color: Colors.white),
                decoration: const BoxDecoration(
                  color: Color(0xFF212121), // Background color for the editor
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                localizations.translate('submit'),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        )
        : LoadingIndicator();
  }
}
