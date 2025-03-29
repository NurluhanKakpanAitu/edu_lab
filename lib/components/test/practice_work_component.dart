import 'package:edu_lab/components/shared/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:edu_lab/entities/test/practice_work.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart'; // Ensure this is present
import 'package:highlight/languages/python.dart'; // For Python syntax highlighting

class PracticeWorkComponent extends StatefulWidget {
  final PracticeWork practiceWork;
  final Locale locale;
  final CodeController codeController;
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
  State<PracticeWorkComponent> createState() => _PracticeWorkComponentState();
}

class _PracticeWorkComponentState extends State<PracticeWorkComponent> {
  late CodeController codeEditorController;

  @override
  void initState() {
    super.initState();
    // Initialize the CodeController with the current text in the codeController
    codeEditorController = CodeController(
      text:
          widget.codeController.text.isEmpty ? '' : widget.codeController.text,
      language: python,
    );
  }

  @override
  void dispose() {
    // Dispose of the CodeController
    codeEditorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return !widget.isLoaded
        ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.practiceWork.title.getTranslation(
                    widget.locale.languageCode,
                  ) ??
                  'No Title',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              widget.practiceWork.description.getTranslation(
                    widget.locale.languageCode,
                  ) ??
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
                  widget.codeController.text = value;
                },
                textStyle: const TextStyle(fontSize: 14, color: Colors.white),
                decoration: const BoxDecoration(
                  color: Color(0xFF212121), // Background color for the editor
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: widget.onSubmit,
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
                'Жіберу',
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
