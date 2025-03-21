import 'package:edu_lab/components/shared/app_bar.dart';
import 'package:edu_lab/entities/test/practice_work.dart';
import 'package:edu_lab/entities/test/test.dart';
import 'package:edu_lab/main.dart';
import 'package:edu_lab/services/test_service.dart';
import 'package:flutter/material.dart';
import 'package:edu_lab/app_localizations.dart';
import 'package:go_router/go_router.dart';

class TestScreen extends StatefulWidget {
  final String moduleId;
  final String courseId;

  const TestScreen({super.key, required this.moduleId, required this.courseId});

  @override
  TestScreenState createState() => TestScreenState();
}

class TestScreenState extends State<TestScreen> {
  bool _isLoading = true;
  Test? _test; // Single test
  PracticeWork? _practiceWork; // Practice work
  final Map<String, String> _selectedAnswers = {};
  final testService = TestService();
  late Locale locale;

  @override
  void initState() {
    super.initState();
    locale = MyApp.getLocale(context) ?? const Locale('kk', '');
    _loadData();
  }

  void _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Load test
      var testResponse = await testService.getTestsByModuleId(widget.moduleId);
      if (testResponse.success && testResponse.data.isNotEmpty) {
        _test = Test.fromJson(testResponse.data.first);
      }

      // Load practice work
      var practiceResponse = await testService.getPracticeWork(widget.moduleId);
      if (practiceResponse.success) {
        _practiceWork = PracticeWork.fromJson(practiceResponse.data);
      }

      if (!mounted) return;
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load data: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _submitTest() {
    if (_test == null) return;

    if (_selectedAnswers.length < _test!.questions.length) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please answer all questions')));
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Test submitted successfully!')));
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'EduLab',
        selectedLocale: locale,
        onLocaleChange: (newLocale) {
          setState(() {
            locale = newLocale;
          });
        },
        onBackButtonPressed: () {
          context.go('/course/${widget.courseId}');
        },
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_test != null) ...[
                      // Display Test
                      Text(
                        _test!.title.getTranslation(locale.languageCode) ??
                            'No Title',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ..._test!.questions.map((question) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              question.title.getTranslation(
                                    locale.languageCode,
                                  ) ??
                                  'No Question',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            ...question.answers.map((answer) {
                              return RadioListTile<String>(
                                title: Text(
                                  answer.title.getTranslation(
                                        locale.languageCode,
                                      ) ??
                                      'No Answer',
                                ),
                                value: answer.id,
                                groupValue: _selectedAnswers[question.id],
                                onChanged: (value) {
                                  setState(() {
                                    _selectedAnswers[question.id] = value!;
                                  });
                                },
                              );
                            }),
                            const SizedBox(height: 16),
                          ],
                        );
                      }),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _submitTest,
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
                          localizations.translate('submitTest'),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const Divider(),
                    ],
                    const SizedBox(height: 16),
                    if (_practiceWork != null) ...[
                      // Display Practice Work
                      Text(
                        _practiceWork!.title.getTranslation(
                              locale.languageCode,
                            ) ??
                            'No Title',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        _practiceWork!.description.getTranslation(
                              locale.languageCode,
                            ) ??
                            'No Description',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        localizations.translate('codeEditor'),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        maxLines: 10,
                        decoration: InputDecoration(
                          hintText: localizations.translate('codeEditorHint'),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {},
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                localizations.translate('codeSubmitted'),
                              ),
                            ),
                          );
                        },
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
                          localizations.translate('submitCode'),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
    );
  }
}
