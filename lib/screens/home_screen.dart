import 'package:edu_lab/components/course/course_modal.dart';
import 'package:edu_lab/components/course/course_list.dart';
import 'package:edu_lab/components/shared/app_bar.dart';
import 'package:edu_lab/components/shared/bottom_navbar.dart';
import 'package:edu_lab/components/shared/loading_indicator.dart';
import 'package:edu_lab/entities/models/course_model.dart';
import 'package:edu_lab/entities/requests/course_request.dart';
import 'package:edu_lab/entities/user.dart';
import 'package:edu_lab/services/auth_service.dart';
import 'package:edu_lab/services/course_service.dart';
import 'package:edu_lab/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  var courseService = CourseService();
  var authService = AuthService();
  late List<CourseModel> courses = [];
  User user = User(id: '', email: '', role: 2, nickname: '');
  bool _isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadCourses();
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
                .map((course) => CourseModel.fromJson(course))
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
        Storage.saveRole(user.role);
      });
    } else {
      context.go('/auth');
    }
  }

  void _showCourseModal(
    BuildContext context,
    String? courseId,
    CourseRequest? request,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return CourseModal(
          onCourseAdded: (course) {
            setState(() {
              courses.add(course); // Add the new course to the list
            });
          },
          onCourseUpdated: (course) {
            setState(() {
              int index = courses.indexWhere((c) => c.id == course.id);
              if (index != -1) {
                courses[index] = course;
              }
            });
          },
          courseId: courseId,
          course: request,
        );
      },
    );
  }

  void _deleteCourse(String id) async {
    var response = await courseService.deleteCourse(id);

    if (!mounted) return;

    if (response.success) {
      setState(() {
        courses.removeWhere((course) => course.id == id);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete course: ${response.errorMessage}'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'EduLab'),
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
                        'Курстар',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      CourseList(
                        role: user.role,
                        courses: courses,
                        onDeleteCourse: (String id) {
                          _deleteCourse(id);
                        },
                        onEditCourse: (
                          String id,
                          String title,
                          String? description,
                          String? imagePath,
                        ) {
                          _showCourseModal(
                            context,
                            id,
                            CourseRequest(
                              title: title,
                              description: description,
                              imagePath: imagePath,
                            ),
                          );
                        },
                      ), // Use the CourseList component
                    ],
                  ),
                ),
              ),
      bottomNavigationBar: BottomNavbar(),
      floatingActionButton:
          user.role == 1
              ? FloatingActionButton(
                onPressed: () {
                  _showCourseModal(context, null, null);
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
