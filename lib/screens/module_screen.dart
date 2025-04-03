import 'package:edu_lab/components/shared/app_bar.dart';
import 'package:edu_lab/components/shared/video_player.dart';
import 'package:edu_lab/entities/models/module_model.dart';
import 'package:edu_lab/services/course_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

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
              'https://docs.google.com/viewer?url=http://85.202.192.76:9000/course/${_module!.presentationPath!}',
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
                              backgroundColor:
                                  Colors.blue, // Button background color
                              foregroundColor: Colors.white, // Text color
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  12,
                                ), // Rounded corners
                              ),
                              elevation: 4, // Shadow effect
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.open_in_new,
                                  size: 20,
                                ), // Add an icon
                                const SizedBox(
                                  width: 8,
                                ), // Spacing between icon and text
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
                  ],
                ),
              ),
    );
  }
}
