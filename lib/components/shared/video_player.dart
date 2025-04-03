import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoViewerWidget extends StatefulWidget {
  final String videoUrl;

  const VideoViewerWidget({super.key, required this.videoUrl});

  @override
  State<VideoViewerWidget> createState() => _VideoViewerWidgetState();
}

class _VideoViewerWidgetState extends State<VideoViewerWidget> {
  late VideoPlayerController _videoController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    // Initialize Video Player for direct video URLs
    _videoController = VideoPlayerController.network(widget.videoUrl)
      ..initialize()
          .then((_) {
            setState(() {
              _isLoading = false;
            });
            _videoController.play(); // Auto-play the video
          })
          .catchError((error) {
            debugPrint('Error initializing video player: $error');
            setState(() {
              _isLoading = false;
            });
          });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : AspectRatio(
          aspectRatio: _videoController.value.aspectRatio,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              VideoPlayer(_videoController),
              _ControlsOverlay(controller: _videoController),
              VideoProgressIndicator(
                _videoController,
                allowScrubbing: true,
                colors: VideoProgressColors(
                  playedColor: Colors.blue,
                  bufferedColor: Colors.grey,
                  backgroundColor: Colors.black,
                ),
              ),
            ],
          ),
        );
  }
}

class _ControlsOverlay extends StatelessWidget {
  final VideoPlayerController controller;

  const _ControlsOverlay({required this.controller});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        controller.value.isPlaying ? controller.pause() : controller.play();
      },
      child: Stack(
        children: [
          if (!controller.value.isPlaying)
            const Center(
              child: Icon(Icons.play_arrow, size: 64, color: Colors.white),
            ),
        ],
      ),
    );
  }
}
