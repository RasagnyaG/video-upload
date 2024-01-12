import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:video_upload/widgets/play_button.dart';

class VideoWidget extends StatefulWidget {
  final File video;
  const VideoWidget({super.key, required this.video});

  @override
  State<VideoWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  late VideoPlayerController _controller;
  late VoidCallback _listener;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.video)
      ..initialize().then((_) {
        setState(() {
          _controller.seekTo(const Duration(seconds: 0));
          _controller.pause();
        });
      });

    _listener = () {
      if (_controller.value.position == _controller.value.duration) {
        _controller.seekTo(const Duration(seconds: 0));
        _controller.pause();
        setState(() {});
      }
    };
    _controller.addListener(_listener);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Center(
        child: Stack(
          children: [
            _controller.value.isInitialized
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                      border:
                          Border.all(color: const Color(0xFF3E6D9C), width: 10),
                    ),
                    child: GestureDetector(
                      onTap: handleTap,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF3E6D9C),
                        ),
                        child: AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: Opacity(
                              opacity: _controller.value.isPlaying ? 1 : 0.3,
                              child: VideoPlayer(_controller)),
                        ),
                      ),
                    ),
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
            _controller.value.isPlaying || !_controller.value.isInitialized
                ? Container()
                : PlayButton(onTap: handleTap),
          ],
        ),
      ),
    );
  }

  void handleTap() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
