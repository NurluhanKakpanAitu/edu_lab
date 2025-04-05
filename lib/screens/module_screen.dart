import 'package:edu_lab/components/shared/app_bar.dart';
import 'package:edu_lab/components/shared/video_player.dart';
import 'package:edu_lab/entities/models/module_model.dart';
import 'package:edu_lab/services/course_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:highlight/languages/python.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
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
  bool _isWebViewLoading = false; // Track WebView loading state
  late final WebViewController
  _webViewController; // Single WebViewController instance

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
    WebViewPlatform.instance ??= WebKitWebViewPlatform();

    _webViewController =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageStarted: (url) {
                setState(() {
                  _isWebViewLoading = true;
                });
                debugPrint('WebView started loading: $url');
              },
              onPageFinished: (url) {
                setState(() {
                  _isWebViewLoading = false;
                });
                debugPrint('WebView finished loading: $url');
              },
              onWebResourceError: (error) {
                setState(() {
                  _isWebViewLoading = false;
                });
                debugPrint('WebView failed to load: ${error.description}');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Қате: ${error.description}')),
                );
              },
            ),
          );

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
        if (_module!.presentationPath != null &&
            _module!.presentationPath!.isNotEmpty) {
          _webViewController.loadRequest(
            Uri.parse(
              'https://docs.google.com/viewer?url=http://34.67.85.230:9000/course/${_module!.presentationPath!}',
            ),
          );
        }
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Модульді жүктеу сәтсіз аяқталмады: ${response.errorMessage}',
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
          'http://34.67.85.230:5000/api/Module/run',
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
                          Stack(
                            children: [
                              AspectRatio(
                                aspectRatio: 16 / 9,
                                child: WebViewWidget(
                                  controller: _webViewController,
                                ),
                              ),
                              if (_isWebViewLoading)
                                const Center(
                                  child: CircularProgressIndicator(),
                                ),
                            ],
                          ),
                        ],
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
                          VideoViewerWidget(videoUrl: _module!.videoPath!),
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

                    // Python Code Editor Section
                    const Text(
                      'Python Code Editor:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 300, // Increase the height of the code editor
                      child: CodeTheme(
                        data: CodeThemeData(
                          styles: {
                            'root': TextStyle(
                              color: const Color.fromARGB(255, 190, 186, 186),
                            ),
                            'keyword': TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                            'string': TextStyle(color: Colors.green),
                            'comment': TextStyle(color: Colors.grey),
                          },
                        ),
                        child: CodeField(
                          controller: _codeController,
                          textStyle: const TextStyle(
                            fontFamily: 'SourceCodePro',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _isCodeRunning ? null : _runCode,
                      child:
                          _isCodeRunning
                              ? const CircularProgressIndicator()
                              : const Text('Run Code'),
                    ),
                    const SizedBox(height: 16),
                    if (_output.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        color: Colors.black,
                        child: SingleChildScrollView(
                          child: Text(
                            _output,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
    );
  }
}
