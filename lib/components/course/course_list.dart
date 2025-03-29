import 'package:flutter/material.dart';
import 'package:edu_lab/entities/course/course.dart';
import 'package:go_router/go_router.dart';
import 'course_card.dart';

class CourseList extends StatelessWidget {
  final List<Course> courses;

  const CourseList({super.key, required this.courses});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        return CourseCard(
          course: courses[index],
          onGoToCourse: () {
            context.go('/course/${courses[index].id}');
          },
        );
      },
    );
  }
}
