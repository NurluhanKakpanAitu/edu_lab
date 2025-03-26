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
      "title": {
        "en": _titleControllers['en']!.text,
        "ru": _titleControllers['ru']!.text,
        "kz": _titleControllers['kz']!.text,
      },
      "description": {
        "en": _descriptionControllers['en']!.text,
        "ru": _descriptionControllers['ru']!.text,
        "kz": _descriptionControllers['kz']!.text,
      },
      "imagePath": _selectedImage?.path,
      "moduleId": widget.moduleId,
    };

    var response = await TestService().addPracticeWork(practiceWorkData);

    setState(() {
      _isSubmitting = false;
    });

    if (!response.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.errorMessage ?? 'Failed to add practice work'),
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
                'Add Practice Work',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
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
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Pick Image'),
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
