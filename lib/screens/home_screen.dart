import 'package:edu_lab/app_localizations.dart';
import 'package:edu_lab/components/app_bar.dart';
import 'package:edu_lab/components/bottom_navbar.dart';
import 'package:edu_lab/entities/course.dart';
import 'package:edu_lab/entities/user.dart';
import 'package:edu_lab/main.dart';
import 'package:edu_lab/services/auth_service.dart';
import 'package:edu_lab/services/course_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late Locale _selectedLocale;

  var courseService = CourseService();
  var authService = AuthService();
  late List<Course> courses = [];
  late User user;
  bool _isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadCourses();
    _selectedLocale = MyApp.getLocale(context) ?? Locale('kk', '');
  }

  void _loadCourses() async {
    setState(() {
      _isLoading = true; // Start loading
    });

    var response = await courseService.getCourses();

    if (!mounted) return;

    if (response.success) {
      setState(() {
        courses =
            (response.data as List)
                .map((course) => Course.fromJson(course))
                .toList();
        _isLoading = false; // Stop loading
      });
    } else {
      setState(() {
        _isLoading = false; // Stop loading even if there's an error
      });
      context.go('/auth');
    }
  }

  void _loadUserData() async {
    var response = await authService.getUser();

    if (!mounted) return;

    if (response.success) {
      setState(() {
        user = User.fromJson(response.data);
      });
    } else {
      context.go('/auth');
    }
  }

  void _changeLanguage(Locale locale) {
    setState(() {
      _selectedLocale = locale;
    });
    MyApp.setLocale(context, locale);
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
              ? Center(
                child: CircularProgressIndicator(), // Show loading indicator
              )
              : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizations.translate('courses'),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: courses.length,
                        itemBuilder: (context, index) {
                          var course = courses[index];
                          var courseTitle =
                              course.title?.getTranslation(
                                _selectedLocale.languageCode,
                              ) ??
                              'No Title';
                          var courseDescription =
                              course.description?.getTranslation(
                                _selectedLocale.languageCode,
                              ) ??
                              'No Description';

                          if (courseDescription.length > 200) {
                            courseDescription =
                                '${courseDescription.substring(0, 200)}...';
                          }

                          var courseImage = course.imagePath;
                          return Card(
                            elevation: 4,
                            margin: EdgeInsets.symmetric(vertical: 8),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.network(
                                      'http://localhost:9000/course/$courseImage',
                                      height: 200,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (
                                        context,
                                        error,
                                        stackTrace,
                                      ) {
                                        return Container(
                                          height: 150,
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
                                  SizedBox(height: 10),
                                  Text(
                                    courseTitle,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    courseDescription,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  SizedBox(height: 15),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: () {},
                                      style: TextButton.styleFrom(
                                        backgroundColor: Colors.blueAccent,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 8,
                                        ),
                                      ),
                                      child: Text(
                                        localizations.translate('goToCourse'),
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontFamily: 'Roboto',
                                        ),
                                      ),
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
              ),
      bottomNavigationBar: BottomNavbar(locale: _selectedLocale.languageCode),
    );
  }
}
