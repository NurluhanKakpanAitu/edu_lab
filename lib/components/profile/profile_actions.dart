import 'package:flutter/material.dart';

class ProfileActions extends StatelessWidget {
  final bool isEditing;
  final VoidCallback onSaveProfile;
  final VoidCallback onEditProfile;
  final VoidCallback onLogout;

  const ProfileActions({
    super.key,
    required this.isEditing,
    required this.onSaveProfile,
    required this.onEditProfile,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: isEditing ? onSaveProfile : onEditProfile,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: Text(
            isEditing ? 'Өзгерістерді сақтау' : 'Профильді өңдеу',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: onLogout,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: Text(
            'Шығу',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
