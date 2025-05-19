import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class HudButton extends PositionComponent with TapCallbacks {
  final String label;
  final void Function()? onPressed;
  final double borderRadius;

  HudButton({
    required this.label,
    this.onPressed,
    required Vector2 position,
    required Vector2 size,
    this.borderRadius = 12.0,
  }) {
    this.position = position;
    this.size = size;
  }

  late final Paint _buttonPaint = Paint()
    ..shader = ui.Gradient.linear(
      Offset(0, 0),
      Offset(size.x, size.y),
      [
        Colors.amber[400]!,
        Colors.orange[700]!,
      ],
    );

  late final Paint _borderPaint = Paint()
    ..color = Colors.brown[900]!
    ..style = PaintingStyle.stroke
    ..strokeWidth = 3.0;

  late final TextPainter _textPainter = TextPainter(
    text: TextSpan(
      text: label,
      style: TextStyle(
        color: Colors.brown[900],
        fontSize: 28,
        fontWeight: FontWeight.bold,
        shadows: [
          Shadow(
            blurRadius: 4.0,
            color: Colors.black.withOpacity(0.5),
            offset: Offset(2.0, 2.0),
          ),
        ],
      ),
    ),
    textDirection: TextDirection.ltr,
    textAlign: TextAlign.center,
  );

  @override
  void render(Canvas canvas) {
    final rect = size.toRect();
    final rRect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));
    canvas.drawRRect(rRect, _buttonPaint);
    canvas.drawRRect(rRect, _borderPaint);
    _textPainter.layout(maxWidth: size.x);
    _textPainter.paint(
      canvas,
      Offset(
        (size.x - _textPainter.width) / 2,
        (size.y - _textPainter.height) / 2,
      ),
    );
  }

  @override
  bool onTapDown(TapDownEvent event) {
    onPressed?.call();
    return true;
  }
}
