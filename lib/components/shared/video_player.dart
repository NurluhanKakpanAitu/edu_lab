import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:url_launcher/url_launcher.dart';

class VideoViewerWidget extends StatefulWidget {
  final String videoUrl;

  const VideoViewerWidget({super.key, required this.videoUrl});

  @override
  State<VideoViewerWidget> createState() => _VideoViewerWidgetState();
}

class _VideoViewerWidgetState extends State<VideoViewerWidget> {
  VideoPlayerController? _videoController;
  bool _isLoading = true;
  bool _isDirectVideo = false;
  final String minioBaseUrl = 'http://85.202.192.76:9000/course/';

  @override
  void initState() {
    super.initState();

    // Check if the video URL is a direct video file (e.g., ends with .mp4)
    _isDirectVideo = widget.videoUrl.endsWith('.mp4');

    if (_isDirectVideo) {
      // Initialize Video Player for direct video URLs
      _videoController = VideoPlayerController.network(
          minioBaseUrl + widget.videoUrl,
        )
        ..initialize()
            .then((_) {
              setState(() {
                _isLoading = false;
              });
            })
            .catchError((error) {
              debugPrint('Error initializing video player: $error');
              setState(() {
                _isLoading = false;
              });
            });

      // Listen for video completion to reset to the beginning
      _videoController!.addListener(() {
        if (_videoController!.value.position ==
            _videoController!.value.duration) {
          _videoController!.seekTo(Duration.zero); // Reset to the beginning
        }
      });
    } else {
      // For non-direct video URLs, stop loading and handle externally
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_isDirectVideo) {
      // Render video player for direct video URLs
      return Column(
        children: [
          AspectRatio(
            aspectRatio: _videoController!.value.aspectRatio,
            child: VideoPlayer(_videoController!),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Play Button
              IconButton(
                icon: const Icon(Icons.play_arrow),
                iconSize: 36,
                color: Colors.blue,
                onPressed: () {
                  _videoController!.play();
                },
              ),

              // Pause Button
              IconButton(
                icon: const Icon(Icons.pause),
                iconSize: 36,
                color: Colors.blue,
                onPressed: () {
                  _videoController!.pause();
                },
              ),

              // Stop Button
              IconButton(
                icon: const Icon(Icons.stop),
                iconSize: 36,
                color: Colors.red,
                onPressed: () {
                  _videoController!.pause();
                  _videoController!.seekTo(
                    Duration.zero,
                  ); // Reset to the beginning
                },
              ),
            ],
          ),
          VideoProgressIndicator(
            _videoController!,
            allowScrubbing: true,
            colors: VideoProgressColors(
              playedColor: Colors.blue,
              bufferedColor: Colors.grey,
              backgroundColor: Colors.black,
            ),
          ),
        ],
      );
    } else {
      // Render a button to open the video in an external browser
      return Center(
        child: ElevatedButton.icon(
          onPressed: () async {
            final uri = Uri.parse(widget.videoUrl);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Сілтемені ашу мүмкін болмады')),
              );
            }
          },
          icon: const Icon(Icons.open_in_browser),
          label: const Text('Видеоны ашу'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      );
    }
  }
}
