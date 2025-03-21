import 'package:edu_lab/components/course/course_header.dart';
import 'package:edu_lab/components/course/module/module_list.dart';
import 'package:edu_lab/components/shared/app_bar.dart';
import 'package:edu_lab/components/shared/loading_indicator.dart';
import 'package:edu_lab/entities/course/course_by_id.dart';
import 'package:edu_lab/main.dart';
import 'package:edu_lab/services/course_service.dart';
import 'package:flutter/material.dart';
import 'package:edu_lab/app_localizations.dart';
import 'package:go_router/go_router.dart';

class CourseScreen extends StatefulWidget {
  final String courseId;
  const CourseScreen({super.key, required this.courseId});

  @override
  CourseScreenState createState() => CourseScreenState();
}

class CourseScreenState extends State<CourseScreen> {
  late CourseById course;
  late Locale _selectedLocale;
  var courseService = CourseService();
  var _isLoading = true;
  Map<String, bool> _expandedModules =
      {}; // Track expanded state for each module

  @override
  void initState() {
    super.initState();
    _selectedLocale = MyApp.getLocale(context) ?? Locale('kk', '');
    _loadCourse();
  }

  void _showReviewDialog(BuildContext context) {
    final TextEditingController reviewController = TextEditingController();
    final localizations = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(localizations.translate('writeReview')),
          content: TextField(
            controller: reviewController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: localizations.translate('enterYourReview'),
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(localizations.translate('cancel')),
            ),
            ElevatedButton(
              onPressed: () {
                _submitReview(reviewController.text);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(localizations.translate('submit')),
            ),
          ],
        );
      },
    );
  }

  void _submitReview(String review) {
    if (review.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context).translate('reviewCannotBeEmpty'),
          ),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLocalizations.of(context).translate('reviewSubmitted'),
        ),
      ),
    );
  }

  void _changeLanguage(Locale locale) {
    setState(() {
      _selectedLocale = locale;
    });
    MyApp.setLocale(context, locale);
  }

  void _loadCourse() async {
    setState(() {
      _isLoading = true;
    });

    var response = await courseService.getCourse(widget.courseId);

    if (!mounted) return;

    if (response.success) {
      setState(() {
        course = CourseById.fromJson(response.data);
        _isLoading = false;
        // Initialize expanded state for all modules
        _expandedModules = {
          for (var module in course.modules) module.id: false,
        };
      });
    } else {
      context.go('/auth');
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'EduLab',
        selectedLocale: _selectedLocale,
        onLocaleChange: _changeLanguage,
        onBackButtonPressed: () {
          context.go('/home');
        },
      ),
      body:
          _isLoading
              ? LoadingIndicator()
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CourseHeader(
                      imagePath: course.imagePath,
                      title:
                          course.title.getTranslation(
                            _selectedLocale.languageCode,
                          ) ??
                          'No Title',
                      description:
                          course.description.getTranslation(
                            _selectedLocale.languageCode,
                          ) ??
                          'No Description',
                    ),
                    Text(
                      localizations.translate('modules'),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ModuleList(
                      modules: course.modules,
                      expandedModules: _expandedModules,
                      onToggleExpand: (moduleId) {
                        setState(() {
                          _expandedModules[moduleId] =
                              !_expandedModules[moduleId]!;
                        });
                      },
                      onGoToTasks: (moduleId) {
                        context.go('/module/${widget.courseId}/test/$moduleId');
                      },
                      locale: _selectedLocale,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        _showReviewDialog(context);
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
                        localizations.translate('writeReview'),
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
