import 'package:edu_lab/app_localizations.dart';
import 'package:edu_lab/components/course/add_course_modal.dart';
import 'package:edu_lab/components/course/course_list.dart';
import 'package:edu_lab/components/shared/app_bar.dart';
import 'package:edu_lab/components/shared/bottom_navbar.dart';
import 'package:edu_lab/components/shared/loading_indicator.dart';
import 'package:edu_lab/entities/course/course.dart';
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
  int userRole = 2;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadCourses();
    _selectedLocale = MyApp.getLocale(context) ?? Locale('kk', '');
    getUserRole();
  }

  void getUserRole() async {
    var response = await authService.getUserRole();
    setState(() {
      userRole = response;
    });
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

  void _showAddCourseModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return AddCourseModal(
          onCourseAdded: (course) {
            setState(() {
              courses.add(course); // Add the new course to the list
            });
          },
        );
      },
    );
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
              ? const LoadingIndicator() // Use the LoadingIndicator component
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
                      CourseList(
                        courses: courses,
                        locale: _selectedLocale,
                      ), // Use the CourseList component
                    ],
                  ),
                ),
              ),
      bottomNavigationBar: BottomNavbar(locale: _selectedLocale.languageCode),
      floatingActionButton:
          userRole == 1
              ? FloatingActionButton(
                onPressed: () {
                  _showAddCourseModal(context);
                },
                backgroundColor: Colors.blue,
                child: const Icon(Icons.add),
              )
              : null, //
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
