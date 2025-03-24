import 'dart:io';

import 'package:edu_lab/services/file_service.dart';
import 'package:edu_lab/utils/response.dart';
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
  final _orderController = TextEditingController();
  final _fileService = FileService();
  bool _isSubmitting = false;
  File? _selectedFile;
  String? _uploadedVideoPath;

  void _pickFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.video);

    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _uploadFile() async {
    if (_selectedFile == null) return;

    setState(() {
      _isSubmitting = true;
    });

    final response = await _fileService.uploadFile(_selectedFile!);

    setState(() {
      _isSubmitting = false;
    });

    if (response.success) {
      setState(() {
        _uploadedVideoPath =
            response.data; // Assuming the backend returns the file path
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to upload video: ${response.errorMessage}'),
        ),
      );
    }
  }

  void _submitModule() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedFile != null && _uploadedVideoPath == null) {
      await _uploadFile();
    }

    if (_uploadedVideoPath == null && _selectedFile != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please upload the selected video before submitting.'),
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final response = ApiResponse(true, null, null);

    setState(() {
      _isSubmitting = false;
    });

    if (response.success) {
      widget.onModuleAdded();
      Navigator.pop(context); // Close the modal
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add module: ${response.errorMessage}'),
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
                'Add Module',
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
              TextFormField(
                controller: _orderController,
                decoration: const InputDecoration(
                  labelText: 'Order',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Order is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _pickFile,
                    child: const Text('Pick Video'),
                  ),
                  const SizedBox(width: 16),
                  if (_selectedFile != null)
                    Expanded(
                      child: Text(
                        _selectedFile!.path.split('/').last,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submitModule,
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
    _orderController.dispose();
    super.dispose();
  }
}
