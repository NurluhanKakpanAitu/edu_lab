import 'dart:io';
import 'package:edu_lab/entities/course/add_module.dart';
import 'package:edu_lab/services/course_service.dart';
import 'package:edu_lab/services/file_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class AddModuleModal extends StatefulWidget {
  final String courseId;
  final Function onModuleAdded;

  const AddModuleModal({
    super.key,
    required this.courseId,
    required this.onModuleAdded,
  });

  @override
  State<AddModuleModal> createState() => _AddModuleModalState();
}

class _AddModuleModalState extends State<AddModuleModal> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _videoUrlController = TextEditingController();
  final _fileService = FileService();
  bool _isSubmitting = false;
  String? _uploadedVideoPath;
  final _courseService = CourseService();

  void _pickFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result != null && result.files.single.path != null) {
      var videoPath = await _uploadFile(File(result.files.single.path!));
      setState(() {
        _videoUrlController.clear();
        _uploadedVideoPath = videoPath;
      });
    }
  }

  Future<String> _uploadFile(File file) async {
    setState(() {
      _isSubmitting = true;
    });

    final response = await _fileService.uploadFile(file);

    setState(() {
      _isSubmitting = false;
    });

    if (response.success) {
      return response.data!;
    } else {
      return '';
    }
  }

  void _submitModule() async {
    if (!_formKey.currentState!.validate()) return;

    final module = AddModule(
      title: _titleController.text,
      description: _descriptionController.text,
      videoPath: _uploadedVideoPath ?? _videoUrlController.text,
      courseId: widget.courseId,
    );

    var response = await _courseService.addModule(module);

    if (!mounted) return;

    if (response.success) {
      widget.onModuleAdded();
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            response.errorMessage ?? 'Модульді қосу сәтсіз аяқталды',
          ),
        ),
      );
    }

    setState(() {
      _isSubmitting = false;
    });
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
                'Модуль қосу',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Атауы (қазақша)',
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
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Сипаттамасы (қазақша)',
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
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _pickFile,
                    child: const Text('Бейне жүктеу'),
                  ),
                  const SizedBox(width: 16),
                  if (_uploadedVideoPath != null)
                    Expanded(
                      child: Text(
                        _uploadedVideoPath!,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Немесе бейненің сілтемесін енгізіңіз:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _videoUrlController,
                decoration: const InputDecoration(
                  labelText: 'Бейне сілтемесі',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submitModule,
                child:
                    _isSubmitting
                        ? const CircularProgressIndicator()
                        : const Text('Қосу'),
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
    _videoUrlController.dispose();
    super.dispose();
  }
}
