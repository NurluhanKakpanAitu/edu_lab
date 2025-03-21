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

  @override
  void initState() {
    super.initState();
    _selectedLocale = MyApp.getLocale(context) ?? Locale('kk', '');
    _loadCourse();
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
      ),
      body:
          _isLoading
              ? LoadingIndicator()
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Course Image
                    if (course.imagePath != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          'http://localhost:9000/course/${course.imagePath}',
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 200,
                              color: Colors.grey[300],
                              child: Center(
                                child: Icon(
                                  Icons.broken_image,
                                  size: 50,
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    const SizedBox(height: 16),
                    Text(
                      course.title.getTranslation(
                            _selectedLocale.languageCode,
                          ) ??
                          'No Title',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      course.description.getTranslation(
                            Localizations.localeOf(context).languageCode,
                          ) ??
                          'No Description',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),

                    // Course Created At
                    Text(
                      '${localizations.translate('createdAt')}: ${course.createdAt.toLocal()}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 24),

                    // Modules Section
                    Text(
                      localizations.translate('modules'),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // List of Modules
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: course.modules.length,
                      itemBuilder: (context, index) {
                        final module = course.modules[index];
                        return Card(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Module Title
                                Text(
                                  module.title?.getTranslation(
                                        Localizations.localeOf(
                                          context,
                                        ).languageCode,
                                      ) ??
                                      'No Title',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  module.description?.getTranslation(
                                        Localizations.localeOf(
                                          context,
                                        ).languageCode,
                                      ) ??
                                      'No Description',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 8),

                                // Module Video Path
                                if (module.videoPath != null)
                                  Text(
                                    '${localizations.translate('videoPath')}: ${module.videoPath}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.blue,
                                    ),
                                  ),

                                // Module Order
                                Text(
                                  '${localizations.translate('order')}: ${module.order}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
