import 'dart:ui';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';

class ScanningTextDetectorPainter extends CustomPainter {
  ScanningTextDetectorPainter(this.absoluteImageSize, this.elements);

  final Size absoluteImageSize;
  final List<TextBlock> elements;

  @override
  void paint(Canvas canvas, Size size) {
    final double scaleX = size.width / absoluteImageSize.width;
    final double scaleY = size.height / absoluteImageSize.height;

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.red
      ..strokeWidth = 2.0;

    for (TextBlock element in elements) {
      canvas.drawRect(scaleRect(element, scaleX, scaleY), paint);
    }
  }

  @override
  bool shouldRepaint(ScanningTextDetectorPainter oldDelegate) {
    return true;
  }

  Rect scaleRect(TextContainer container, double scaleX, double scaleY) {
    return Rect.fromLTRB(
      container.boundingBox.left * scaleX,
      container.boundingBox.top * scaleY,
      container.boundingBox.right * scaleX,
      container.boundingBox.bottom * scaleY,
    );
  }
}