import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerWidget({super.key, required this.videoUrl});

  @override
  VideoPlayerWidgetState createState() => VideoPlayerWidgetState();
}

class VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() async {
    try {
      _controller = VideoPlayerController.networkUrl(
          Uri.parse('http://localhost:9000/course/${widget.videoUrl}'),
        )
        ..initialize()
            .then((_) {
              setState(
                () {},
              ); // Refresh the widget once the video is initialized
            })
            .catchError((error) {
              setState(() => _isError = true);
            });
    } catch (e) {
      setState(() => _isError = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isError) {
      return const Center(
        child: Text("Error loading video", style: TextStyle(color: Colors.red)),
      );
    }

    return Column(
      children: [
        // Video Player
        _controller.value.isInitialized
            ? Stack(
              alignment: Alignment.bottomCenter,
              children: [
                AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
                _buildControls(),
              ],
            )
            : const Center(child: CircularProgressIndicator()),
      ],
    );
  }

  Widget _buildControls() {
    return Container(
      color: Colors.black54, // Semi-transparent background for controls
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          // Play/Pause Button
          IconButton(
            icon: Icon(
              _isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _isPlaying ? _controller.pause() : _controller.play();
                _isPlaying = !_isPlaying;
              });
            },
          ),

          // Progress Bar
          Expanded(
            child: VideoProgressIndicator(
              _controller,
              allowScrubbing: true,
              colors: VideoProgressColors(
                playedColor: Colors.blue,
                bufferedColor: Colors.grey,
                backgroundColor: Colors.black,
              ),
            ),
          ),

          // Fullscreen Button
          IconButton(
            icon: const Icon(Icons.fullscreen, color: Colors.white),
            onPressed: () {
              _goFullScreen(context);
            },
          ),
        ],
      ),
    );
  }

  void _goFullScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => Scaffold(
              backgroundColor: Colors.black,
              body: Center(
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
              ),
            ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
