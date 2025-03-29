import 'package:flutter/material.dart';

class ProfileForm extends StatelessWidget {
  final TextEditingController nicknameController;
  final TextEditingController emailController;
  final TextEditingController aboutController;
  final TextEditingController passwordController;
  final bool isEditing;

  const ProfileForm({
    super.key,
    required this.nicknameController,
    required this.emailController,
    required this.aboutController,
    required this.passwordController,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: nicknameController,
          enabled: isEditing,
          decoration: InputDecoration(
            labelText: 'Қолданушы аты',
            prefixIcon: const Icon(Icons.person),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: emailController,
          enabled: isEditing,
          decoration: InputDecoration(
            labelText: 'Электрондық пошта',
            prefixIcon: const Icon(Icons.email),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: aboutController,
          enabled: isEditing,
          decoration: InputDecoration(
            labelText: 'Өзіңіз туралы',
            prefixIcon: const Icon(Icons.info),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (isEditing)
          TextField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Жаңа құпия сөз',
              prefixIcon: const Icon(Icons.lock),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
      ],
    );
  }
}
