import 'package:edu_lab/components/shared/app_bar.dart';
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
  List<Test> _tests = [];
  final Map<String, String> _selectedAnswers = {};
  var testService = TestService();
  late Locale locale;

  @override
  void initState() {
    super.initState();
    _loadTests();
    locale = MyApp.getLocale(context) ?? const Locale('kk', '');
  }

  void _loadTests() async {
    setState(() {
      _isLoading = true;
    });

    var apiResponse = await testService.getTestsByModuleId(widget.moduleId);

    if (!mounted) return;

    if (apiResponse.success) {
      setState(() {
        _tests =
            (apiResponse.data as List)
                .map((test) => Test.fromJson(test))
                .toList();
        _isLoading = false;
      });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load tests')));
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _submitTest(String testId) {
    print('Selected answers: $_selectedAnswers');
    if (_selectedAnswers.length < _tests.firstOrNull!.questions.length) {
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
                    ..._tests.map((test) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            test.title.getTranslation(locale.languageCode) ??
                                'No Title',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...test.questions.map<Widget>((question) {
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
                                ...question.answers.map<Widget>((answer) {
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
                          const Divider(),
                        ],
                      );
                    }),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => _submitTest(_tests.firstOrNull!.id),
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
                  ],
                ),
              ),
    );
  }
}
