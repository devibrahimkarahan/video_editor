import 'package:flutter/material.dart';
import 'package:video_editor/utils/styles.dart';

class TrimSliderPainter extends CustomPainter {
  TrimSliderPainter(this.rect, this.position, {this.style});

  final Rect rect;
  final double position;
  final TrimSliderStyle style;

  @override
  void paint(Canvas canvas, Size size) {
    final double width = style.lineWidth;
    final double dotWidth = style.dotWidth;
    final double halfWidth = width / 2;
    final double halfHeight = rect.height / 2;
    final Paint dotPaint = Paint()..color = style.dotColor;
    final Paint linePaint = Paint()..color = style.lineColor;
    final Paint progressPaint = Paint()..color = style.positionLineColor;
    final Paint background = Paint()..color = Colors.white.withOpacity(0.5);

    canvas.drawRect(
      Rect.fromPoints(
        Offset(position - halfWidth / 2, 0.0),
        Offset(position + halfWidth / 2, size.height),
      ),
      progressPaint..color = Colors.red,
    );

    //BACKGROUND LEFT
    canvas.drawRect(
      Rect.fromPoints(
        Offset.zero,
        rect.bottomLeft,
      ),
      background,
    );

    //BACKGROUND RIGHT
    canvas.drawRect(
      Rect.fromPoints(
        rect.topRight - Offset(12, 0),
        Offset(size.width, size.height),
      ),
      background,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromPoints(rect.topLeft, rect.bottomRight),
        Radius.circular(2),
      ),
      Paint()
        ..color = style.lineColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = dotWidth,
    );

    //LEFT LINE
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromPoints(rect.bottomLeft - Offset(-width, 0), rect.topLeft),
        bottomLeft: Radius.circular(2),
        topLeft: Radius.circular(2),
      ),
      linePaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromPoints(
          rect.centerLeft + Offset(dotWidth * 1.5, halfHeight / 2),
          rect.centerLeft - Offset(-dotWidth, halfHeight / 2),
        ),
        Radius.circular(6),
      ),
      dotPaint,
    );

    //RIGHT LINE
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromPoints(rect.bottomRight - Offset(width, 0), rect.topRight),
        bottomRight: Radius.circular(2),
        topRight: Radius.circular(2),
      ),
      linePaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromPoints(
          rect.centerRight + Offset(-dotWidth * 1.5, halfHeight / 2),
          rect.centerRight - Offset(dotWidth, halfHeight / 2),
        ),
        Radius.circular(6),
      ),
      dotPaint,
    );
  }

  @override
  bool shouldRepaint(TrimSliderPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(TrimSliderPainter oldDelegate) => false;
}
