import 'package:edu_lab/components/shared/app_bar.dart';
import 'package:edu_lab/components/test/practice_work_component.dart';
import 'package:edu_lab/components/test/practice_work_result.dart';
import 'package:edu_lab/components/test/test_component.dart';
import 'package:edu_lab/components/test/user_test_result_component.dart';
import 'package:edu_lab/entities/test/practice_work.dart';
import 'package:edu_lab/entities/test/practice_work_result.dart';
import 'package:edu_lab/entities/test/test.dart';
import 'package:edu_lab/entities/test/test_result.dart';
import 'package:edu_lab/entities/test/user_test_result.dart';
import 'package:edu_lab/main.dart';
import 'package:edu_lab/services/test_service.dart';
import 'package:edu_lab/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:edu_lab/app_localizations.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
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
  Test? _test;
  PracticeWork? _practiceWork;
  List<TestResult> _selectedAnswers = [];
  final CodeController _codeController = CodeController();
  final testService = TestService();
  final userService = UserService();
  late Locale locale;
  PracticeWorkResult? practiceWorkResult;
  bool isLoadedPracticeWork = false;
  UserTestResult? userTestResult;
  bool blockSubmit = false;
  bool blockRetest = true;

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
      var testResponse = await testService.getTestsByModuleId(widget.moduleId);
      if (testResponse.success && testResponse.data.isNotEmpty) {
        _test = Test.fromJson(testResponse.data.first);
      }

      var practiceResponse = await testService.getPracticeWork(widget.moduleId);
      if (practiceResponse.success) {
        _practiceWork = PracticeWork.fromJson(practiceResponse.data);
      }

      var userTestResultResponse = await userService.getTestResult(
        _test?.id ?? '',
      );

      if (userTestResultResponse.success) {
        if (userTestResultResponse.data != null) {
          var selectedAnswers =
              userTestResultResponse.data['testResults'] as List;
          if (selectedAnswers.isNotEmpty) {
            _selectedAnswers =
                selectedAnswers.map((e) => TestResult.fromJson(e)).toList();

            var maxScore = userTestResultResponse.data['maxScore'];
            var score = userTestResultResponse.data['score'];

            userTestResult = UserTestResult(maxScore: maxScore, score: score);
            blockSubmit = true;
            blockRetest = false;
          }
        }
      } else {
        blockSubmit = false;
        blockRetest = true;
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

  void _submitTest() async {
    if (_test == null) return;

    if (_selectedAnswers.length < _test!.questions.length) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please answer all questions')));
      return;
    }

    var apiResponse = await testService.submitTest(_test!.id, _selectedAnswers);

    if (!mounted) return;

    if (!apiResponse.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(apiResponse.errorMessage ?? 'Failed to submit')),
      );
      return;
    }

    setState(() {
      userTestResult = UserTestResult.fromJson(apiResponse.data);
      blockSubmit = true;
      blockRetest = false;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Test submitted successfully!')));
  }

  void _submitPracticeWork() async {
    final code = _codeController.text;
    if (code.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Code cannot be empty')));
      return;
    }

    setState(() {
      isLoadedPracticeWork = true;
    });
    var apiResponse = await testService.submitPracticeWork(
      _practiceWork?.id ?? '',
      code,
    );

    if (!mounted) return;

    setState(() {
      isLoadedPracticeWork = false;
    });

    if (!apiResponse.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(apiResponse.errorMessage ?? 'Failed to submit')),
      );
      return;
    }

    setState(() {
      practiceWorkResult = PracticeWorkResult.fromJson(apiResponse.data);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Practice work submitted successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'EduLab',
        selectedLocale: locale,
        onLocaleChange: (newLocale) {
          setState(() {
            locale = newLocale;
          });
          MyApp.setLocale(context, newLocale);
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
                    if (_test != null)
                      TestComponent(
                        test: _test!,
                        locale: locale,
                        selectedAnswers: _selectedAnswers,
                        onAnswerSelected: (questionId, answerId, isCorrect) {
                          setState(() {
                            if (_selectedAnswers.any(
                              (e) => e.questionId == questionId,
                            )) {
                              _selectedAnswers.removeWhere(
                                (e) => e.questionId == questionId,
                              );
                            }
                            _selectedAnswers.add(
                              TestResult(
                                questionId: questionId,
                                answerId: answerId,
                                isCorrect: isCorrect,
                              ),
                            );
                          });
                        },
                        onSubmit: _submitTest,
                        blockSubmit: blockSubmit,
                        onRetest: () {
                          setState(() {
                            _selectedAnswers = [];
                            userTestResult = null;
                            blockSubmit = false;
                            blockRetest = true;
                          });
                        },
                        blockRetest: blockRetest,
                      ),
                    if (userTestResult != null)
                      UserTestResultComponent(userTestResult: userTestResult!),

                    const SizedBox(height: 30),
                    if (_practiceWork != null) ...[
                      PracticeWorkComponent(
                        practiceWork: _practiceWork!,
                        locale: locale,
                        codeController: _codeController,
                        onSubmit: _submitPracticeWork,
                        isLoaded: isLoadedPracticeWork,
                      ),
                      if (practiceWorkResult != null)
                        PracticeWorkResultComponent(
                          practiceWorkResult: practiceWorkResult!,
                        ),
                    ],
                  ],
                ),
              ),
    );
  }
}
