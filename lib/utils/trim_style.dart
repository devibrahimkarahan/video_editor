import 'package:flutter/material.dart';

class TrimSliderStyle {
  ///Style for [TrimSlider]. It's use on VideoEditorController
  TrimSliderStyle({
    Color? background,
    this.dotWidth = 4,
    this.lineWidth = 12,
    this.dotColor = Colors.white,
    this.lineColor = const Color(0xff392F5A),
    this.positionLineColor = Colors.red,
  }) : this.background = background ?? Colors.black.withOpacity(0.6);

  ///It is the color line that indicate the video position
  final Color positionLineColor;

  ///It is the deactive color. Default `Colors.black.withOpacity(0.6)
  final Color background;

  final Color dotColor;
  final double dotWidth;

  final Color lineColor;
  final double lineWidth;
}
