import 'package:edu_lab/app_localizations.dart';
import 'package:edu_lab/services/test_service.dart';
import 'package:flutter/material.dart';

class AddTestModal extends StatefulWidget {
  final String moduleId;
  final Function onTestAdded;

  const AddTestModal({
    super.key,
    required this.moduleId,
    required this.onTestAdded,
  });

  @override
  State<AddTestModal> createState() => _AddTestModalState();
}

class _AddTestModalState extends State<AddTestModal> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final List<Map<String, dynamic>> _questions = [];
  bool _isSubmitting = false;

  void _addQuestion() {
    setState(() {
      _questions.add({
        'title': {'kz': ''},
        'answers': [
          {
            'title': {'kz': ''},
            'isCorrect': false,
          },
        ],
      });
    });
  }

  void _removeQuestion(int index) {
    setState(() {
      _questions.removeAt(index);
    });
  }

  void _addAnswer(Map<String, dynamic> question) {
    setState(() {
      question['answers'].add({
        'title': {'kz': ''},
        'isCorrect': false,
      });
    });
  }

  void _removeAnswer(Map<String, dynamic> question, int answerIndex) {
    setState(() {
      question['answers'].removeAt(answerIndex);
    });
  }

  void _submitTest() async {
    if (!_formKey.currentState!.validate()) return;

    if (_questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one question.')),
      );
      return;
    }

    final testData = {
      "title": {"kz": _titleController.text},
      "questions": _questions,
      "moduleId": widget.moduleId,
    };

    setState(() {
      _isSubmitting = true;
    });

    // Call your backend service to submit the test
    final response = await TestService().addTest(testData);

    setState(() {
      _isSubmitting = false;
    });

    if (response.success) {
      widget.onTestAdded();
      Navigator.pop(context); // Close the modal
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add test: ${response.errorMessage}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.translate('addTest'),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: localizations.translate('title_kz'),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addQuestion,
              child: Text(localizations.translate('addQuestion')),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children:
                      _questions.asMap().entries.map((entry) {
                        final index = entry.key;
                        final question = entry.value;
                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${localizations.translate('question')} ${index + 1}',
                                    ),
                                    IconButton(
                                      onPressed: () => _removeQuestion(index),
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  initialValue: question['title']['kz'],
                                  decoration: InputDecoration(
                                    labelText: localizations.translate(
                                      'question_kz',
                                    ),
                                    border: OutlineInputBorder(),
                                  ),
                                  onChanged: (value) {
                                    question['title']['kz'] = value;
                                  },
                                ),
                                const SizedBox(height: 8),
                                ElevatedButton(
                                  onPressed: () => _addAnswer(question),
                                  child: Text(
                                    localizations.translate('addAnswer'),
                                  ),
                                ),
                                ...question['answers'].asMap().entries.map((
                                  entry,
                                ) {
                                  final answerIndex = entry.key;
                                  final answer = entry.value;
                                  return Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          initialValue: answer['title']['kz'],
                                          decoration: InputDecoration(
                                            labelText: localizations.translate(
                                              'answer_kz',
                                            ),
                                            border: OutlineInputBorder(),
                                          ),
                                          onChanged: (value) {
                                            answer['title']['kz'] = value;
                                          },
                                        ),
                                      ),
                                      Checkbox(
                                        value: answer['isCorrect'],
                                        onChanged: (value) {
                                          setState(() {
                                            answer['isCorrect'] = value!;
                                          });
                                        },
                                      ),
                                      IconButton(
                                        onPressed:
                                            () => _removeAnswer(
                                              question,
                                              answerIndex,
                                            ),
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isSubmitting ? null : _submitTest,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(
                  double.infinity,
                  48,
                ), // Full-width button
              ),
              child:
                  _isSubmitting
                      ? const CircularProgressIndicator()
                      : Text(localizations.translate('submit')),
            ),
            const SizedBox(height: 16), // Space below the button
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }
}
