import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class PlayerCountSelector extends PositionComponent {
  int selectedCount;
  final void Function(int) onChanged;

  PlayerCountSelector({
    required Vector2 position,
    required Vector2 size,
    required int initialCount,
    required this.onChanged,
  }) : selectedCount = initialCount {
    this.position = position;
    this.size = size;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _buildButtons();
  }

  void _buildButtons() {
    children.clear();
    for (int i = 1; i <= 4; i++) {
      // Calculate button width and spacing
      const double buttonWidth = 120;
      const double buttonHeight = 70;
      const double spacing = 20;
      final totalWidth = 4 * buttonWidth + 3 * spacing;
      final startX = (size.x - totalWidth) / 2;

      add(
        _PlayerCountButton(
          label: '$i Player${i > 1 ? 's' : ''}',
          isSelected: i == selectedCount,
          onTap: () {
        selectedCount = i;
        onChanged(i);
        _buildButtons();
          },
          position: Vector2(
        startX + (i - 1) * (buttonWidth + spacing),
        (size.y - buttonHeight) / 2,
          ),
          size: Vector2(buttonWidth, buttonHeight),
        ),
      );
    }
  }
}

class _PlayerCountButton extends PositionComponent with TapCallbacks {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  _PlayerCountButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required Vector2 position,
    required Vector2 size,
  }) {
    this.position = position;
    this.size = size;
  }

  @override
  void render(Canvas canvas) {
    // Make the cell visually larger by adding a margin around the cell
    const double margin = 6.0;
    final rect = Rect.fromLTWH(
      margin,
      margin,
      size.x - 2 * margin,
      size.y - 2 * margin,
    );
    final rRect = RRect.fromRectAndRadius(rect, Radius.circular(20));
    final Paint paint = Paint()
      ..shader = LinearGradient(
        colors: isSelected
            ? [Colors.amber.shade300, Colors.amber.shade600]
            : [Colors.grey.shade200, Colors.grey.shade400],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(rect);
    canvas.drawRRect(rRect, paint);

    // Draw border
    final borderPaint = Paint()
      ..color = isSelected ? Colors.brown.shade900 : Colors.grey.shade600
      ..style = PaintingStyle.stroke
      ..strokeWidth = isSelected ? 3.0 : 1.5;
    canvas.drawRRect(rRect, borderPaint);

    // Draw shadow for selected
    if (isSelected) {
      final shadowPaint = Paint()
        ..color = Colors.amber.withOpacity(0.3)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 8);
      canvas.drawRRect(rRect.shift(const Offset(0, 2)), shadowPaint);
    }

    // Draw label with padding
    final textPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(
          color: isSelected ? Colors.brown[900] : Colors.black87,
          fontWeight: FontWeight.bold,
          fontSize: 20, // Slightly larger font
          shadows: isSelected
              ? [
                  Shadow(
                    blurRadius: 4,
                    color: Colors.amber.withOpacity(0.5),
                    offset: const Offset(1, 2),
                  ),
                ]
              : [],
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout(maxWidth: rect.width);
    textPainter.paint(
      canvas,
      Offset(
        rect.left + (rect.width - textPainter.width) / 2,
        rect.top + (rect.height - textPainter.height) / 2,
      ),
    );
  }

  @override
  bool onTapDown(TapDownEvent event) {
    onTap();
    return true;
  }
}
