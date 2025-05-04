import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String? photoPath;
  final bool isEditing;
  final VoidCallback onPickImage;

  const ProfileAvatar({
    super.key,
    required this.photoPath,
    required this.isEditing,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEditing ? onPickImage : null,
      child: Stack(
        children: [
          CircleAvatar(
            radius: 120,
            backgroundImage:
                photoPath != null
                    ? NetworkImage(
                      'http://82.115.49.230:9000/course/$photoPath'.trim(),
                    )
                    : const AssetImage('assets/default_avatar.png')
                        as ImageProvider<Object>,
          ),
          if (isEditing)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
