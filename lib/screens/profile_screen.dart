import 'dart:io';

import 'package:edu_lab/components/profile/profile_actions.dart';
import 'package:edu_lab/components/profile/profile_avatar.dart';
import 'package:edu_lab/components/profile/profile_form.dart';
import 'package:edu_lab/components/shared/app_bar.dart';
import 'package:edu_lab/components/shared/bottom_navbar.dart';
import 'package:edu_lab/entities/user.dart';
import 'package:edu_lab/services/auth_service.dart';
import 'package:edu_lab/services/file_service.dart';
import 'package:edu_lab/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  final _nicknameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _aboutController = TextEditingController();
  String? _photoPath;
  bool _isEditing = false;
  final ImagePicker _picker = ImagePicker();
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();
  final FileService _fileService = FileService();
  late String currentUserId;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    var response = await _authService.getUser();
    var user = User.fromJson(response.data);
    setState(() {
      _nicknameController.text = user.nickname;
      _emailController.text = user.email;
      _aboutController.text = user.about ?? '';
      _photoPath = user.photoPath;
      currentUserId = user.id;
    });
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        String imagePath = await _uploadImageToMinIO(image);
        setState(() {
          _photoPath = imagePath;
        });
      }
      if (!mounted) return;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('')));
    }
  }

  Future<String> _uploadImageToMinIO(XFile image) async {
    try {
      var response = await _fileService.uploadFile(File(image.path));
      return response.data ?? '';
    } catch (e) {
      return '';
    }
  }

  Future<void> _saveProfile() async {
    try {
      var response = await _userService.updateProfile(
        currentUserId,
        _nicknameController.text,
        _emailController.text,
        _aboutController.text,
        _photoPath,
        _passwordController.text.isNotEmpty ? _passwordController.text : null,
      );

      if (!mounted) return;

      setState(() {
        _isEditing = false;
      });

      if (response.success) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Профиль обновлен')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.errorMessage ?? 'Profile update failed'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error occurred while updating profile: $e')),
      );
    }
  }

  void _logout() async {
    var response = await _authService.logout();

    if (!mounted) return;

    if (response.success) {
      context.go('/auth');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.errorMessage ?? 'Logout failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'EduLab'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ProfileAvatar(
              photoPath: _photoPath,
              isEditing: _isEditing,
              onPickImage: _pickImage,
            ),
            const SizedBox(height: 24),
            ProfileForm(
              nicknameController: _nicknameController,
              emailController: _emailController,
              aboutController: _aboutController,
              passwordController: _passwordController,
              isEditing: _isEditing,
            ),
            const SizedBox(height: 24),
            ProfileActions(
              isEditing: _isEditing,
              onSaveProfile: _saveProfile,
              onEditProfile: () {
                setState(() {
                  _isEditing = true;
                });
              },
              onLogout: _logout,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavbar(),
    );
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _aboutController.dispose();
    super.dispose();
  }
}
