import 'dart:io';

import 'package:edu_lab/services/test_service.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class AddPracticeWorkModal extends StatefulWidget {
  final String moduleId;
  final Function onPracticeWorkAdded;

  const AddPracticeWorkModal({
    super.key,
    required this.moduleId,
    required this.onPracticeWorkAdded,
  });

  @override
  State<AddPracticeWorkModal> createState() => _AddPracticeWorkModalState();
}

class _AddPracticeWorkModalState extends State<AddPracticeWorkModal> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  File? _selectedImage;
  bool _isSubmitting = false;

  void _pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedImage = File(result.files.single.path!);
      });
    }
  }

  void _submitPracticeWork() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    final practiceWorkData = {
      "title": {"kz": _titleController.text},
      "description": {"kz": _descriptionController.text},
      "imagePath": _selectedImage?.path,
      "moduleId": widget.moduleId,
    };

    var response = await TestService().addPracticeWork(practiceWorkData);

    setState(() {
      _isSubmitting = false;
    });

    if (!response.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Тәжірибелік жұмысты қосу сәтсіз аяқталды'),
        ),
      );
      return;
    }

    widget.onPracticeWorkAdded();
    Navigator.pop(context);
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
                'Тәжірибелік жұмыс қосу',
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
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Суретті жүктеу'),
              ),
              if (_selectedImage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    _selectedImage!.path.split('/').last,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submitPracticeWork,
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
    super.dispose();
  }
}
