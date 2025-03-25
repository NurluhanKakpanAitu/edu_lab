import 'dart:io';

import 'package:edu_lab/app_localizations.dart';
import 'package:edu_lab/entities/course/add_module.dart';
import 'package:edu_lab/entities/translation.dart';
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

    final title = {
      for (var entry in _titleControllers.entries) entry.key: entry.value.text,
    };

    final description = {
      for (var entry in _descriptionControllers.entries)
        entry.key: entry.value.text,
    };

    final videoPath = _uploadedVideoPath ?? _videoUrlController.text;

    final module = AddModule(
      title: Translation.fromJson(title),
      description: Translation.fromJson(description),
      videoPath: videoPath,
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
            AppLocalizations.of(context).translate('moduleAddFailed'),
          ),
        ),
      );
    }

    setState(() {
      _isSubmitting = true;
    });

    if (!mounted) return;

    setState(() {
      _isSubmitting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

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
                localizations.translate('addModule'),
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
                      labelText: localizations.translate('title_$language'),
                      border: const OutlineInputBorder(),
                    ),
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
                      labelText: localizations.translate(
                        'description_$language',
                      ),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 16),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _pickFile,
                    child: Text(localizations.translate('uploadVideo')),
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
              Text(
                localizations.translate('videoUrl'),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _videoUrlController,
                decoration: InputDecoration(
                  labelText: localizations.translate('videoUrlHint'),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submitModule,
                child:
                    _isSubmitting
                        ? const CircularProgressIndicator()
                        : Text(localizations.translate('submit')),
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
    _videoUrlController.dispose();
    super.dispose();
  }
}
