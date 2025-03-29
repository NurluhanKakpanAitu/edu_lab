import 'dart:io';
import 'package:edu_lab/entities/models/course_model.dart';
import 'package:edu_lab/entities/requests/course_request.dart';
import 'package:edu_lab/services/file_service.dart';
import 'package:flutter/material.dart';
import 'package:edu_lab/services/course_service.dart';
import 'package:image_picker/image_picker.dart';

class CourseModal extends StatefulWidget {
  final String? courseId; // If provided, modal will update the course
  final CourseRequest? course; // If provided, modal will update the course
  final Function(CourseModel)? onCourseAdded;
  final Function(CourseModel)? onCourseUpdated;

  const CourseModal({
    super.key,
    this.courseId,
    this.course,
    this.onCourseAdded,
    this.onCourseUpdated,
  });

  @override
  State<CourseModal> createState() => _CourseModalState();
}

class _CourseModalState extends State<CourseModal> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _courseService = CourseService();
  final _fileService = FileService();
  bool _isSubmitting = false;
  String? _uploadedFilePath;
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.course != null) {
      // Pre-fill fields if updating a course
      _titleController.text = widget.course!.title;
      _descriptionController.text = widget.course!.description ?? '';
      _uploadedFilePath = widget.course!.imagePath;
    }
  }

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
          content: Text('Суретті жүктеу сәтсіз аяқталды: ${e.toString()}'),
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

    final request = CourseRequest(
      title: _titleController.text,
      description: _descriptionController.text,
      imagePath: _uploadedFilePath,
    );

    setState(() {
      _isSubmitting = true;
    });

    if (widget.course == null) {
      // Adding a new course
      final response = await _courseService.addCourse(request);

      if (!mounted) return;

      setState(() {
        _isSubmitting = false;
      });

      if (response.success) {
        widget.onCourseAdded?.call(
          CourseModel.fromRequest(response.data!, request),
        );
        Navigator.pop(context); // Close the modal
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Курсты қосу сәтсіз аяқталды: ${response.errorMessage}',
            ),
          ),
        );
      }
    } else {
      // Updating an existing course
      final response = await _courseService.updateCourse(
        widget.courseId!,
        request,
      );

      if (!mounted) return;

      setState(() {
        _isSubmitting = false;
      });

      if (response.success) {
        widget.onCourseUpdated?.call(
          CourseModel.fromRequest(widget.courseId!, request),
        );
        Navigator.pop(context); // Close the modal
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Курсты өзгерту сәтсіз аяқталды: ${response.errorMessage}',
            ),
          ),
        );
      }
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
                widget.course == null ? 'Курс қосу' : 'Курсты өзгерту',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Курстың атауы',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                maxLines: 1,
                decoration: const InputDecoration(
                  labelText: 'Атауы',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Атауы міндетті түрде толтырылуы керек';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Курстың сипаттамасы',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Сипаттамасы',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Сипаттамасы міндетті түрде толтырылуы керек';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: const Text('Суретті жүктеу'),
                  ),
                  const SizedBox(height: 16),
                  if (_uploadedFilePath != null)
                    Container(
                      width: double.infinity,
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
                        : Text(
                          widget.course == null
                              ? 'Курсты қосу'
                              : 'Курсты өзгерту',
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
