import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:video_editor/utils/controller.dart';
import 'package:video_editor/utils/transform_data.dart';
import 'package:video_editor/widgets/video/transform.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class ThumbnailSlider extends StatefulWidget {
  ThumbnailSlider({
    required this.controller,
    this.height = 60,
    this.quality = 10,
  }) : assert(controller != null);

  ///MAX QUALITY IS 100 - MIN QUALITY IS 0
  final int quality;

  ///THUMBNAIL HEIGHT
  final double height;

  final VideoEditorController controller;

  @override
  _ThumbnailSliderState createState() => _ThumbnailSliderState();
}

class _ThumbnailSliderState extends State<ThumbnailSlider> {
  ValueNotifier<Rect> _rect = ValueNotifier<Rect>(Rect.zero);
  ValueNotifier<TransformData> _transform = ValueNotifier<TransformData>(
    TransformData(rotation: 0.0, scale: 1.0, translate: Offset.zero),
  );

  double _aspect = 1.0, _width = 1.0;
  int _thumbnails = 8;

  Size _layout = Size.zero;
  Stream<List<Uint8List>>? _stream;

  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    _aspect = widget.controller.video.value.aspectRatio;
    widget.controller.addListener(_scaleRect);
    _subscription = widget.controller.thumbnailController.stream.listen(
      (value) {
        setState(() {
          _stream = _generateThumbnails();
        });
      },
    );
  }

  @override
  void dispose() {
    widget.controller.removeListener(_scaleRect);
    _transform.dispose();
    _rect.dispose();
    _subscription?.cancel();
    super.dispose();
  }

  void _scaleRect() {
    _rect.value = _calculateTrimRect();
    _transform.value = TransformData.fromRect(
      _rect.value,
      _layout,
      widget.controller,
    );
  }

  Stream<List<Uint8List>> _generateThumbnails() async* {
    final String path = widget.controller.file.path;
    final ms = widget.controller.video.value.duration.inMilliseconds;
    final double eachPart = ms / _thumbnails;

    List<Uint8List?> _byteList = [];

    print(">>>>>> PATH: $path");

    for (int i = 0; i < _thumbnails; i++) {
      Uint8List? _bytes = await VideoThumbnail.thumbnailData(
        imageFormat: ImageFormat.JPEG,
        video: path,
        timeMs: (eachPart * i).toInt(),
        quality: widget.quality,
      );
      _byteList.add(_bytes);

      yield _byteList as List<Uint8List>;
    }
  }

  Rect _calculateTrimRect() {
    final Offset min = widget.controller.minCrop;
    final Offset max = widget.controller.maxCrop;
    return Rect.fromPoints(
      Offset(
        min.dx * _layout.width,
        min.dy * _layout.height,
      ),
      Offset(
        max.dx * _layout.width,
        max.dy * _layout.height,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, box) {
      final double width = box.maxWidth;
      if (_width != width) {
        _width = width;
        _layout = _aspect <= 1.0
            ? Size(widget.height * _aspect, widget.height)
            : Size(widget.height, widget.height / _aspect);
        _thumbnails = (_width ~/ _layout.width) + 1;
        _stream = _generateThumbnails();
        _rect.value = _calculateTrimRect();
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
                  itemCount: data!.length,
                  itemBuilder: (_, int index) {
                    if (data[index] == null) return SizedBox();
                    return ValueListenableBuilder(
                      valueListenable: _transform,
                      builder: (_, TransformData transform, __) {
                        return CropTransform(
                          transform: transform,
                          child: Container(
                            alignment: Alignment.center,
                            height: _layout.height,
                            width: _layout.width,
                            child: Image(
                              image: MemoryImage(data[index]),
                              width: _layout.width,
                              height: _layout.height,
                              alignment: Alignment.topLeft,
                            ),
                          ),
                        );
                      },
                    );
                    // return ClipRRect(
                    //   child: SizedBox(
                    //     height: _size.height,
                    //     width: _width / _thumbnails,
                    //     child: Image(
                    //       image: MemoryImage(data[index]),
                    //       width: _size.width,
                    //       height: _size.height,
                    //       alignment: Alignment.topLeft,
                    //       fit: BoxFit.cover,
                    //     ),
                    //   ),
                    // );
                  },
                )
              : SizedBox();
        },
      );
    });
  }
}
