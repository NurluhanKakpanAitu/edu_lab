import 'dart:io';

import 'package:edu_lab/entities/course/add_course.dart';
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

  final _titleControllers = TextEditingController();
  final _descriptionControllers = TextEditingController();
  final _courseService = CourseService();
  final _fileService = FileService();
  bool _isSubmitting = false;
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
        SnackBar(content: Text('Failed to upload image: ${e.toString()}')),
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

    final addCourse = AddCourse(
      title: _titleControllers.text,
      description: _descriptionControllers.text,
      imagePath: _uploadedFilePath,
    );

    setState(() {
      _isSubmitting = true;
    });

    final response = await _courseService.addCourse(addCourse);

    if (!mounted) return;

    setState(() {
      _isSubmitting = false;
    });

    if (response.success) {
      // widget.onCourseAdded(Course.fromModal(addCourse, response.data));
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
              Text(
                'Курс қосу',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                'Қурстың атауы',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleControllers,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Атауы',
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Курстың сипаттамасы',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionControllers,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Сипаттамасы',
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: Text('Суретті жүктеу'),
                  ),
                  const SizedBox(height: 16),
                  if (_uploadedFilePath != null)
                    Container(
                      width:
                          double
                              .infinity, // Ensure the text does not expand indefinitely
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        _uploadedFilePath!,
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
                        : Text('Курсты қосу'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleControllers.dispose();
    _descriptionControllers.dispose();
    super.dispose();
  }
}
