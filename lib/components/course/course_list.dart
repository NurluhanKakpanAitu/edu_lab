import 'package:edu_lab/entities/models/course_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'course_card.dart';

class CourseList extends StatelessWidget {
  final List<CourseModel> courses;
  final Function onDeleteCourse;
  final Function onEditCourse;
  final int role;

  const CourseList({
    super.key,
    required this.courses,
    required this.onDeleteCourse,
    required this.onEditCourse,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        return CourseCard(
          role: role,
          course: courses[index],
          onGoToCourse: () {
            context.go('/course/${courses[index].id}');
          },
          onDeleteCourse: () {
            onDeleteCourse(courses[index].id);
          },
          onEditCourse: () {
            onEditCourse(
              courses[index].id,
              courses[index].title,
              courses[index].description,
              courses[index].imagePath,
            );
          },
        );
      },
    );
  }
}
