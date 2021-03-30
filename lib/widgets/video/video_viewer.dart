import 'package:flutter/material.dart';
import 'package:video_editor/utils/controller.dart';
import 'package:video_player/video_player.dart';

class VideoViewer extends StatefulWidget {
  VideoViewer({
    Key key,
    @required this.controller,
    this.child,
    this.ignoring = false,
  }) : super(key: key);

  final VideoEditorController controller;
  final Widget child;
  final bool ignoring;

  @override
  _VideoViewerState createState() => _VideoViewerState();
}

class _VideoViewerState extends State<VideoViewer> {
  VideoPlayerController _controller;

  @override
  void initState() {
    _controller = widget.controller.video;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_controller.value.isPlaying)
          _controller.pause();
        else
          _controller.play();
      },
      child: Center(
        child: Stack(children: [
          AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: IgnorePointer(
              ignoring: widget.ignoring,
              child: VideoPlayer(_controller),
            ),
          ),
          if (widget.child != null)
            AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: widget.child,
            ),
        ]),
      ),
    );
  }
}
