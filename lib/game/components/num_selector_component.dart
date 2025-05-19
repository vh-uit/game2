import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

typedef NumberSelectedCallback = void Function(int number);

class NumSelectorComponent extends PositionComponent with HasGameReference {
  final NumberSelectedCallback onNumberSelected;
  final double buttonSize;
  final double spacing;
  final double borderRadius;
  final double fontSize;

  NumSelectorComponent({
    required this.onNumberSelected,
    this.buttonSize = 56,
    this.spacing = 8,
    this.borderRadius = 16,
    this.fontSize = 24,
    Vector2? position,
    Vector2? size,
  }) : super(position: position ?? Vector2.zero(), size: size ?? Vector2(600, 80));

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // Add number buttons as children
    final numbers = List.generate(10, (i) => i);
    final double totalWidth = buttonSize * 10 + spacing * 9;
    final double y = size.y / 2 - buttonSize / 2;
    for (int i = 0; i < numbers.length; i++) {
      final x = i * (buttonSize + spacing) + (size.x - totalWidth) / 2;
      add(_NumberButton(
        number: numbers[i],
        onPressed: () => onNumberSelected(numbers[i]),
        position: Vector2(x, y),
        size: Vector2(buttonSize, buttonSize),
        borderRadius: borderRadius,
        fontSize: fontSize,
      ));
    }
  }
}

class _NumberButton extends PositionComponent with TapCallbacks {
  final int number;
  final VoidCallback onPressed;
  final double borderRadius;
  final double fontSize;

  _NumberButton({
    required this.number,
    required this.onPressed,
    required Vector2 position,
    required Vector2 size,
    required this.borderRadius,
    required this.fontSize,
  }) : super(position: position, size: size);

  @override
  void render(Canvas canvas) {
    final rect = size.toRect();
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));
    final paint = Paint()..color = Colors.amber[200]!;
    final borderPaint = Paint()
      ..color = Colors.brown[900]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRRect(rrect, paint);
    canvas.drawRRect(rrect, borderPaint);
    final textPainter = TextPainter(
      text: TextSpan(
        text: '$number',
        style: TextStyle(
          color: Colors.brown[900],
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout(maxWidth: size.x);
    textPainter.paint(
      canvas,
      Offset(
        (size.x - textPainter.width) / 2,
        (size.y - textPainter.height) / 2,
      ),
    );
  }

  @override
  bool onTapDown(TapDownEvent event) {
    onPressed();
    return true;
  }
}
