import 'package:edu_lab/entities/models/module_model.dart';
import 'package:edu_lab/entities/requests/module_request.dart';
import 'package:edu_lab/services/course_service.dart';
import 'package:flutter/material.dart';

class ModuleModal extends StatefulWidget {
  final String courseId;
  final ModuleModel? module; // If provided, modal will update the module
  final Function onModuleAdded;
  final Function onModuleUpdated;

  const ModuleModal({
    super.key,
    required this.courseId,
    this.module,
    required this.onModuleAdded,
    required this.onModuleUpdated,
  });

  @override
  State<ModuleModal> createState() => _ModuleModalState();
}

class _ModuleModalState extends State<ModuleModal> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _courseService = CourseService();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    if (widget.module != null) {
      // Pre-fill fields if updating a module
      _titleController.text = widget.module!.title;
      _descriptionController.text = widget.module!.description ?? '';
    }
  }

  void _submitModule() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    final request = ModuleRequest(
      title: _titleController.text,
      description: _descriptionController.text,
      videoPath: widget.module?.videoPath,
      presentationPath: widget.module?.presentationPath,
      taskPath: widget.module?.taskPath,
      courseId: widget.courseId,
    );



    if (widget.module == null) {
      final response = await _courseService.addModule(request);

      if (!mounted) return;

      setState(() {
        _isSubmitting = false;
      });

      if (response.success) {
        widget.onModuleAdded();
        Navigator.pop(context); // Close the modal
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Модульді қосу сәтсіз аяқталды: ${response.errorMessage}',
            ),
          ),
        );
      }
    } else {
      // Updating an existing module
      final response = await _courseService.updateModule(
        widget.module!.id,
        request,
      );

      if (!mounted) return;

      setState(() {
        _isSubmitting = false;
      });

      if (response.success) {
        widget.onModuleUpdated();
        Navigator.pop(context); // Close the modal
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Модульді өзгерту сәтсіз аяқталды: ${response.errorMessage}',
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
                widget.module == null ? 'Модуль қосу' : 'Модульді өзгерту',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Модуль атауы',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Модуль атауы міндетті түрде толтырылуы керек';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Модуль сипаттамасы',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Модуль сипаттамасы міндетті түрде толтырылуы керек';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submitModule,
                child:
                    _isSubmitting
                        ? const CircularProgressIndicator()
                        : Text(widget.module == null ? 'Қосу' : 'Өзгерту'),
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
