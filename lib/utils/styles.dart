import 'package:flutter/material.dart';

class CropGridStyle {
  ///Style for [CropGridViewer]. It's use on VideoEditorController
  CropGridStyle({
    Color croppingBackground,
    this.background = Colors.transparent,
    this.gridLineColor = Colors.white,
    this.gridLineWidth = 1,
    this.gridSize = 3,
    this.boundariesColor = const Color(0xff392F5A),
    this.boundariesLenght = 20,
    this.boundariesWidth = 5,
  }) : this.croppingBackground =
            croppingBackground ?? Colors.black.withOpacity(0.48);

  ///It is the deactive color background when is cropping. Default `Colors.black.withOpacity(0.48)`
  final Color croppingBackground;

  ///It is the background color when is not cropping.
  final Color background;

  final double gridLineWidth;

  final Color gridLineColor;

  ///The amount columns and rows
  final int gridSize;

  final Color boundariesColor;
  final double boundariesLenght;
  final double boundariesWidth;
}

class TrimSliderStyle {
  ///Style for [TrimSlider]. It's use on VideoEditorController
  TrimSliderStyle({
    Color background,
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
