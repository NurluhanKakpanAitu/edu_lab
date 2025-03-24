import 'dart:io';

import 'package:edu_lab/app_localizations.dart';
import 'package:edu_lab/entities/course/add_course.dart';
import 'package:edu_lab/entities/translation.dart';
import 'package:edu_lab/services/file_service.dart';
import 'package:flutter/material.dart';
import 'package:edu_lab/entities/course/course.dart';
import 'package:edu_lab/services/course_service.dart';
import 'package:image_picker/image_picker.dart';

class AddCourseModal extends StatefulWidget {
  final Function(Course) onCourseAdded;

  const AddCourseModal({super.key, required this.onCourseAdded});

  @override
  State<AddCourseModal> createState() => _AddCourseModalState();
}

class _AddCourseModalState extends State<AddCourseModal> {
  final _formKey = GlobalKey<FormState>();
  final _titleControllers = {
    'en': TextEditingController(),
    'ru': TextEditingController(),
    'kz': TextEditingController(),
  };
  final _descriptionControllers = {
    'en': TextEditingController(),
    'ru': TextEditingController(),
    'kz': TextEditingController(),
  };
  final _courseService = CourseService();
  final _fileService = FileService();
  bool _isSubmitting = false;
  File? _selectedFile;
  String? _uploadedFilePath;
  final _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        String imagePath = await _uploadImageToMinIO(image);
        setState(() {
          _uploadedFilePath = imagePath;
        });
      }
      if (!mounted) return;
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

  void _submitCourse() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedFile != null && _uploadedFilePath == null) {
      await _uploadImageToMinIO(_selectedFile! as XFile);
    }

    if (_uploadedFilePath == null && _selectedFile != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please upload the selected file before submitting.'),
        ),
      );
      return;
    }

    final addCourse = AddCourse(
      title: Translation(
        en: _titleControllers['en']!.text,
        ru: _titleControllers['ru']!.text,
        kz: _titleControllers['kz']!.text,
      ),
      description: Translation(
        en: _descriptionControllers['en']!.text,
        ru: _descriptionControllers['ru']!.text,
        kz: _descriptionControllers['kz']!.text,
      ),
      imagePath: _uploadedFilePath,
    );

    setState(() {
      _isSubmitting = true;
    });

    final response = await _courseService.addCourse(addCourse);

    setState(() {
      _isSubmitting = false;
    });

    if (response.success) {
      widget.onCourseAdded(Course.fromModal(addCourse, response.data));
      Navigator.pop(context); // Close the modal
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add course: ${response.errorMessage}'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Add Course',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'Title',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ..._titleControllers.entries.map((entry) {
                final language = entry.key;
                final controller = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: TextFormField(
                    controller: controller,
                    decoration: InputDecoration(
                      labelText: 'Title ($language)',
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Title ($language) is required';
                      }
                      return null;
                    },
                  ),
                );
              }),
              const SizedBox(height: 16),
              const Text(
                'Description',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ..._descriptionControllers.entries.map((entry) {
                final language = entry.key;
                final controller = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: TextFormField(
                    controller: controller,
                    decoration: InputDecoration(
                      labelText: 'Description ($language)',
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Description ($language) is required';
                      }
                      return null;
                    },
                  ),
                );
              }),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: const Text('Pick Image'),
                  ),
                  const SizedBox(height: 16),
                  if (_uploadedFilePath != null || _selectedFile != null)
                    Container(
                      width:
                          double
                              .infinity, // Ensure the text does not expand indefinitely
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        _uploadedFilePath ??
                            _selectedFile!.path.split('/').last,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submitCourse,
                child:
                    _isSubmitting
                        ? const CircularProgressIndicator()
                        : const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _titleControllers.values) {
      controller.dispose();
    }
    for (var controller in _descriptionControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
}
