import 'package:edu_lab/components/course/course_header.dart';
import 'package:edu_lab/components/course/module/module_modal.dart';
import 'package:edu_lab/components/course/module/module_list.dart';
import 'package:edu_lab/components/shared/app_bar.dart';
import 'package:edu_lab/components/shared/loading_indicator.dart';
import 'package:edu_lab/entities/models/course_model.dart';
import 'package:edu_lab/entities/models/module_model.dart';
import 'package:edu_lab/entities/user.dart';
import 'package:edu_lab/services/auth_service.dart';
import 'package:edu_lab/services/course_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CourseScreen extends StatefulWidget {
  final String courseId;
  const CourseScreen({super.key, required this.courseId});

  @override
  CourseScreenState createState() => CourseScreenState();
}

class CourseScreenState extends State<CourseScreen> {
  late CourseModel course;
  var courseService = CourseService();
  var _isLoading = true;
  Map<String, bool> _expandedModules =
      {}; // Track expanded state for each module

  User user = User(id: '', nickname: '', email: '', role: 2);

  @override
  void initState() {
    super.initState();
    _loadCourse();
    _loadUser();
  }

  void _loadCourse() async {
    setState(() {
      _isLoading = true;
    });

    var response = await courseService.getCourse(widget.courseId);

    if (!mounted) return;

    if (response.success) {
      setState(() {
        course = CourseModel.fromJson(response.data);
        _isLoading = false;
        _expandedModules = {
          for (var module in course.modules) module.id: false,
        };
      });
    } else {
      context.go('/auth');
    }
  }

  void _loadUser() async {
    var response = await AuthService().getUser();

    if (!mounted) return;

    if (response.success) {
      setState(() {
        user = User.fromJson(response.data);
      });
    } else {
      context.go('/auth');
    }
  }

  void _showModuleModal(BuildContext context, {ModuleModel? module}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return ModuleModal(
          courseId: widget.courseId,
          module: module, // Pass the module if updating
          onModuleAdded: _loadCourse,
          onModuleUpdated: _loadCourse,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'EduLab',
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
                      title: course.title,
                      description: course.description ?? '',
                    ),
                    Text(
                      'Модульдар',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (user.role == 1)
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: InkWell(
                          onTap: () {
                            _showModuleModal(context);
                          },
                          borderRadius: BorderRadius.circular(8.0),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.add, color: Colors.blue),
                                const SizedBox(width: 8),
                                Text(
                                  'Модуль қосу',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                          ),
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
                      onEditModule: (module) {
                        _showModuleModal(
                          context,
                          module: module,
                        ); // Open modal for editing
                      },
                    ),
                  ],
                ),
              ),
    );
  }
}
