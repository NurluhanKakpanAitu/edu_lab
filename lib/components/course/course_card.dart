import 'package:edu_lab/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:edu_lab/entities/course.dart';

class CourseCard extends StatelessWidget {
  final Course course;
  final Locale locale;
  final VoidCallback onGoToCourse;

  const CourseCard({
    super.key,
    required this.course,
    required this.locale,
    required this.onGoToCourse,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    var courseTitle =
        course.title?.getTranslation(locale.languageCode) ?? 'No Title';
    var courseDescription =
        course.description?.getTranslation(locale.languageCode) ??
        'No Description';

    if (courseDescription.length > 200) {
      courseDescription = '${courseDescription.substring(0, 200)}...';
    }

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
                'http://localhost:9000/course/${course.imagePath}',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
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
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              courseDescription,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            SizedBox(height: 15),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: onGoToCourse,
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
  }
}
