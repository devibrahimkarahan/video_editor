import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:video_editor/utils/controller.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class ThumbnailSlider extends StatefulWidget {
  ThumbnailSlider({
    @required this.controller,
    this.height = 60,
    this.quality = 25,
    this.previewMode = false,
  }) : assert(controller != null);

  ///MAX QUALITY IS 100 - MIN QUALITY IS 0
  final int quality;

  ///THUMBNAIL HEIGHT
  final double height;

  final VideoEditorController controller;

  final bool previewMode;

  @override
  _ThumbnailSliderState createState() => _ThumbnailSliderState();
}

class _ThumbnailSliderState extends State<ThumbnailSlider> {
  double _aspect = 1.0;

  double _width = 1.0;
  int _thumbnails = 8;

  Size _size = Size.zero;

  Stream<List<Uint8List>> _stream;

  StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    _aspect = widget.controller.video.value.aspectRatio;
    if (widget.previewMode) {
      _subscription = widget.controller.thumbnailController.stream.listen(
        (value) {
          setState(() {
            _stream = _generateThumbnails();
          });
        },
      );
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(ThumbnailSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.controller.isPlaying) setState(() {});
  }

  Stream<List<Uint8List>> _generateThumbnails() async* {
    final String path = widget.controller.file.path;
    final ms = widget.controller.videoDuration.inMilliseconds;
    final minT = widget.controller.minTrim;
    final maxT = widget.controller.maxTrim;

    final int duration = widget.previewMode ? (minT).toInt() : ms;
    final double eachPart = duration / _thumbnails;
    final double eachPartPreview = ((maxT - minT) * ms) / _thumbnails;

    List<Uint8List> _byteList = [];

    for (int i = 0; i < _thumbnails; i++) {
      Uint8List _bytes = await VideoThumbnail.thumbnailData(
        imageFormat: ImageFormat.JPEG,
        video: path,
        timeMs: widget.previewMode
            ? (minT * ms).toInt() + (eachPartPreview * i).toInt()
            : (eachPart * i).toInt(),
        quality: widget.quality,
      );
      _byteList.add(_bytes);

      yield _byteList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, box) {
      final double width = box.maxWidth;
      if (_width != width) {
        _width = width;
        _size = _aspect <= 1.0
            ? Size(widget.height * _aspect, widget.height)
            : Size(widget.height, widget.height / _aspect);
        _thumbnails = (_width ~/ _size.width) + 1;
        _stream = _generateThumbnails();
      }

      return StreamBuilder(
        stream: _stream,
        builder: (_, AsyncSnapshot<List<Uint8List>> snapshot) {
          final data = snapshot.data;
          return snapshot.hasData
              ? ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.zero,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: data.length,
                  itemBuilder: (_, int index) {
                    return ClipRRect(
                      child: SizedBox(
                        height: _size.height,
                        width: _width / _thumbnails,
                        child: Image(
                          image: MemoryImage(data[index]),
                          width: _size.width,
                          height: _size.height,
                          alignment: Alignment.topLeft,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                )
              : SizedBox();
        },
      );
    });
  }
}
