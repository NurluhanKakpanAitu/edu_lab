import 'dart:io';

import 'package:edu_lab/entities/user_get_info.dart';
import 'package:edu_lab/main.dart';
import 'package:edu_lab/services/auth_service.dart';
import 'package:edu_lab/services/file_service.dart';
import 'package:edu_lab/services/user_service.dart';
import 'package:edu_lab/utils/language_drop_down.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../app_localizations.dart';

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
  Locale _selectedLocale = Locale('en', '');

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    var response = await _authService.getUser();
    var user = UserGetInfo.fromJson(response.data);
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
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context).translate('imageUploadFailed'),
          ),
        ),
      );
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
      await _userService.updateProfile(
        currentUserId,
        _nicknameController.text,
        _emailController.text,
        _aboutController.text,
        _photoPath,
        _passwordController.text.isNotEmpty ? _passwordController.text : null,
      );
      setState(() {
        _isEditing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context).translate('profileUpdated'),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context).translate('profileUpdateFailed'),
          ),
        ),
      );
    }
  }

  void _logout() async {
    await _authService.logout();
    Navigator.pushReplacementNamed(context, '/auth');
  }

  void _changeLanguage(Locale locale) {
    setState(() {
      _selectedLocale = locale;
    });
    MyApp.setLocale(context, locale);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.translate('profile')),
        actions: [
          LanguageDropdown(
            selectedLocale: _selectedLocale,
            onLocaleChange: _changeLanguage,
          ),
          IconButton(icon: Icon(Icons.logout), onPressed: _logout),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _isEditing ? _pickImage : null,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 120,
                    backgroundImage:
                        _photoPath != null
                            ? NetworkImage(
                              'http://localhost:9000/course/$_photoPath',
                            )
                            : AssetImage('assets/default_avatar.png')
                                as ImageProvider<Object>,
                  ),
                  if (_isEditing)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 24),
            TextField(
              controller: _nicknameController,
              enabled: _isEditing,
              decoration: InputDecoration(
                labelText: localizations.translate('nickname'),
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _emailController,
              enabled: _isEditing,
              decoration: InputDecoration(
                labelText: localizations.translate('email'),
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _aboutController,
              enabled: _isEditing,
              decoration: InputDecoration(
                labelText: localizations.translate('about'),
                prefixIcon: Icon(Icons.info),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: 16),
            if (_isEditing) ...[
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: localizations.translate('newPasswordOptional'),
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  localizations.translate('saveChanges'),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_isEditing) {
            _saveProfile();
          } else {
            setState(() {
              _isEditing = true;
            });
          }
        },
        child: Icon(_isEditing ? Icons.save : Icons.edit),
      ),
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
