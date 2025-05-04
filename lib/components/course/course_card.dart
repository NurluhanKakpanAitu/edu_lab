import 'package:edu_lab/entities/models/course_model.dart';
import 'package:flutter/material.dart';

class CourseCard extends StatelessWidget {
  final CourseModel course;
  final VoidCallback onGoToCourse;
  final VoidCallback? onDeleteCourse;
  final VoidCallback? onEditCourse;
  final int role;

  const CourseCard({
    super.key,
    required this.course,
    required this.onGoToCourse,
    this.onDeleteCourse,
    this.onEditCourse,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    var courseTitle = course.title;
    var courseDescription = course.description ?? '';

    if (courseDescription.length > 200) {
      courseDescription = '${courseDescription.substring(0, 200)}...';
    }

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                'http://82.115.49.230:9000/course/${course.imagePath}'.trim(),
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 150,
                    color: Colors.grey[300],
                    child: const Center(
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
            const SizedBox(height: 10),
            Text(
              courseTitle,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              courseDescription,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment
                      .spaceBetween, // Separate left and right groups
              children: [
                // Left side: Edit and Delete buttons
                Row(
                  children: [
                    if (onEditCourse != null && role == 1)
                      IconButton(
                        onPressed: onEditCourse,
                        icon: const Icon(Icons.edit, color: Colors.orange),
                        tooltip: 'Өңдеу',
                      ),
                    if (onDeleteCourse != null && role == 1)
                      IconButton(
                        onPressed: onDeleteCourse,
                        icon: const Icon(Icons.delete, color: Colors.red),
                        tooltip: 'Жою',
                      ),
                  ],
                ),
                // Right side: Go to Course button
                TextButton(
                  onPressed: onGoToCourse,
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  child: const Text(
                    'Курсқа өту',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
