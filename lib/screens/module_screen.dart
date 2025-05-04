import 'package:edu_lab/components/shared/app_bar.dart';
import 'package:edu_lab/entities/models/module_model.dart';
import 'package:edu_lab/services/course_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:highlight/languages/python.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ModuleScreen extends StatefulWidget {
  final String moduleId;

  const ModuleScreen({super.key, required this.moduleId});

  @override
  State<ModuleScreen> createState() => _ModuleScreenState();
}

class _ModuleScreenState extends State<ModuleScreen> {
  bool _isLoading = true;
  ModuleModel? _module;

  final CodeController _codeController = CodeController(
    text: '''
# Write your Python code here
print("Hello, World!")
''',
    language: python,
  );

  String _output = '';
  bool _isCodeRunning = false;

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

        // Load the presentation URL into the WebView
      });
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

  Future<void> _runCode() async {
    setState(() {
      _isCodeRunning = true;
      _output = '';
    });

    if (_codeController.text.isEmpty) {
      setState(() {
        _output = 'Код бос';
        _isCodeRunning = false;
      });
      return;
    }
    try {
      final response = await http.post(
        Uri.parse(
          'http://82.115.49.230:5000/api/Module/run',
        ), // Replace with your backend URL
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'code': _codeController.text}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _output = data['output'] ?? '';
          if (data['error'] != null && data['error'].isNotEmpty) {
            _output += '\nError:\n${data['error']}';
          }
        });
      } else {
        setState(() {
          _output = 'Error: ${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        _output = 'Error: $e';
      });
    } finally {
      setState(() {
        _isCodeRunning = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Модуль',
        onBackButtonPressed: () {
          context.go('/course/${_module?.courseId}');
        },
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

                    // Presentation Section
                    // Replace the existing Presentation Section with this:

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
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed:
                                  () => _openUrl(
                                    'http://82.115.49.230:9000/course/${_module!.presentationPath!}'
                                        .trim(),
                                  ),
                              icon: const Icon(
                                Icons.download_rounded,
                                size: 24,
                              ),
                              label: const Text(
                                'Презентацияны жүктеу',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 24),

                    // Video Section
                    // Replace the Video Section with this:

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
                          Container(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                final videoPath = _module!.videoPath!;
                                if (videoPath.startsWith('http')) {
                                  // If it's a web URL, redirect to the video
                                  _openUrl(videoPath);
                                } else {
                                  // If it's a MinIO file, generate download URL
                                  _openUrl(
                                    'http://82.115.49.230:9000/course/$videoPath'
                                        .trim(),
                                  );
                                }
                              },
                              icon: Icon(
                                _module!.videoPath!.startsWith('http')
                                    ? Icons.play_circle_outline
                                    : Icons.download_rounded,
                                size: 24,
                              ),
                              label: Text(
                                _module!.videoPath!.startsWith('http')
                                    ? 'Бейнені қарау'
                                    : 'Бейнені жүктеу',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 4,
                              ),
                            ),
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
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 4,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.open_in_new, size: 20),
                                const SizedBox(width: 8),
                                const Text(
                                  'Тапсырманы ашу',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 24),
                    // Replace the Python Code Editor Section with this:

                    // Python Code Editor Section
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E1E), // Dark theme background
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Editor Header
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Python код редакторы',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                ElevatedButton.icon(
                                  onPressed: _isCodeRunning ? null : _runCode,
                                  icon: const Icon(Icons.play_arrow),
                                  label: Text(
                                    _isCodeRunning ? 'Running...' : 'Run Code',
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Code Editor
                          Container(
                            height: 300,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2D2D2D),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: CodeTheme(
                              data: CodeThemeData(
                                styles: {
                                  'root': const TextStyle(color: Colors.white),
                                  'keyword': const TextStyle(
                                    color: Color(0xFF569CD6),
                                    fontWeight: FontWeight.bold,
                                  ),
                                  'string': const TextStyle(
                                    color: Color(0xFFCE9178),
                                  ),
                                  'number': const TextStyle(
                                    color: Color(0xFFB5CEA8),
                                  ),
                                  'comment': const TextStyle(
                                    color: Color(0xFF6A9955),
                                  ),
                                  'type': const TextStyle(
                                    color: Color(0xFF4EC9B0),
                                  ),
                                },
                              ),
                              child: CodeField(
                                controller: _codeController,
                                textStyle: const TextStyle(
                                  fontFamily: 'JetBrains Mono',
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),

                          // Output Section
                          if (_output.isNotEmpty)
                            Container(
                              width: double.infinity,
                              margin: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2D2D2D),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color:
                                      _output.contains('Error')
                                          ? Colors.red.withOpacity(0.5)
                                          : Colors.green.withOpacity(0.5),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          _output.contains('Error')
                                              ? Colors.red.withOpacity(0.1)
                                              : Colors.green.withOpacity(0.1),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(8),
                                        topRight: Radius.circular(8),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          _output.contains('Error')
                                              ? Icons.error_outline
                                              : Icons.check_circle_outline,
                                          color:
                                              _output.contains('Error')
                                                  ? Colors.red
                                                  : Colors.green,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          _output.contains('Error')
                                              ? 'Error'
                                              : 'Output',
                                          style: TextStyle(
                                            color:
                                                _output.contains('Error')
                                                    ? Colors.red
                                                    : Colors.green,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    child: SelectableText(
                                      _output,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'JetBrains Mono',
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
