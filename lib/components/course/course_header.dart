import 'package:flutter/material.dart';

class CourseHeader extends StatelessWidget {
  final String? imagePath;
  final String title;
  final String description;

  CourseHeader({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (imagePath != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              'http://34.57.171.38:9000/course/$imagePath'.trim(),
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 200,
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
        const SizedBox(height: 16),
        Text(
          title,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          description,
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
