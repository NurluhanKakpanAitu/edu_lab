import 'package:edu_lab/entities/models/module_model.dart';
import 'package:edu_lab/services/course_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class ModuleScreen extends StatefulWidget {
  final String moduleId;

  const ModuleScreen({super.key, required this.moduleId});

  @override
  State<ModuleScreen> createState() => _ModuleScreenState();
}

class _ModuleScreenState extends State<ModuleScreen> {
  bool _isLoading = true;
  ModuleModel? _module;

  @override
  void initState() {
    super.initState();
    _loadModule();
  }

  Future<void> _loadModule() async {
    setState(() {
      _isLoading = true;
    });

    final response = await CourseService().getModule(widget.moduleId);

    if (!mounted) return;

    if (response.success) {
      setState(() {
        _module = ModuleModel.fromJson(response.data);
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Модульді жүктеу сәтсіз аяқталды: ${response.errorMessage}',
          ),
        ),
      );
    }
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Сілтемені ашу мүмкін болмады')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Модуль'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/course/${_module?.courseId}');
          },
        ),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _module == null
              ? const Center(child: Text('Модуль табылмады'))
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      _module!.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Description
                    Text(
                      _module!.description ?? 'Сипаттама жоқ',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 24),

                    // Video Section
                    if (_module!.videoPath != null &&
                        _module!.videoPath!.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Бейне:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          AspectRatio(
                            aspectRatio: 16 / 9,
                            child:
                                _module!.videoPath!.startsWith('http')
                                    ? Image.network(
                                      _module!.videoPath!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (
                                        context,
                                        error,
                                        stackTrace,
                                      ) {
                                        return const Center(
                                          child: Text(
                                            'Бейнені жүктеу мүмкін болмады',
                                          ),
                                        );
                                      },
                                    )
                                    : Center(
                                      child: Text(
                                        'MinIO бейне: ${_module!.videoPath}',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 24),

                    // Presentation Section
                    if (_module!.presentationPath != null &&
                        _module!.presentationPath!.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Презентация:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed:
                                () => _openUrl(_module!.presentationPath!),
                            child: const Text('Презентацияны ашу'),
                          ),
                        ],
                      ),
                    const SizedBox(height: 24),

                    // Task Section
                    if (_module!.taskPath != null &&
                        _module!.taskPath!.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Тапсырма:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () => _openUrl(_module!.taskPath!),
                            child: const Text('Тапсырманы ашу'),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
    );
  }
}
