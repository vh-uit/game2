import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui; // Import for Gradient

/// The main menu screen for the game.
///
/// Provides buttons to start the game or open the options screen.
class MainMenuScreen extends Component with HasGameReference {
  /// Callback when the start button is pressed.
  final void Function()? onStart;

  /// Callback when the options button is pressed.
  final void Function()? onOptions;

  MainMenuScreen({this.onStart, this.onOptions});

  /// Loads the main menu and adds menu buttons as children.
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final double buttonWidth = 250; // Slightly wider buttons
    final double buttonHeight = 70; // Slightly taller buttons
    final double spacing = 30; // Reduced spacing slightly

    // Center buttons on the screen
    final screenSize = game.size;
    final centerX = (screenSize.x - buttonWidth) / 2;
    final totalHeight = buttonHeight * 2 + spacing;
    final startY = (screenSize.y - totalHeight) / 2;

    add(
      HudButton(
        label: 'Start Game',
        onPressed: onStart,
        position: Vector2(centerX, startY),
        size: Vector2(buttonWidth, buttonHeight), // Pass size to button
      ),
    );

    add(
      HudButton(
        label: 'Options',
        onPressed: onOptions,
        position: Vector2(centerX, startY + buttonHeight + spacing),
        size: Vector2(buttonWidth, buttonHeight), // Pass size to button
      ),
    );
  }
}

class HudButton extends PositionComponent with TapCallbacks {
  final String label;
  final void Function()? onPressed;
  final double borderRadius; // Added border radius

  HudButton({
    required this.label,
    this.onPressed,
    required Vector2 position,
    required Vector2 size, // Receive size
    this.borderRadius = 12.0, // Default border radius
  }) {
    this.position = position;
    this.size = size; // Use passed size
  }

  // Paint for the button background
  late final Paint _buttonPaint = Paint()
    ..shader = ui.Gradient.linear(
      Offset(0, 0),
      Offset(size.x, size.y),
      [
        Colors.amber[400]!, // Start color
        Colors.orange[700]!, // End color
      ],
    );

  // Paint for the button border
  late final Paint _borderPaint = Paint()
    ..color = Colors.brown[900]!
    ..style = PaintingStyle.stroke
    ..strokeWidth = 3.0; // Border thickness

  // Text painter for the button label
  late final TextPainter _textPainter = TextPainter(
    text: TextSpan(
      text: label,
      style: TextStyle(
        color: Colors.brown[900],
        fontSize: 28, // Slightly larger font
        fontWeight: FontWeight.bold,
        shadows: [ // Add text shadow
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

    // Draw button background with gradient and rounded corners
    canvas.drawRRect(rRect, _buttonPaint);

    // Draw button border with rounded corners
    canvas.drawRRect(rRect, _borderPaint);

    // Layout and paint the text
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
    // Optional: Add a subtle visual feedback on tap, like scaling or color change
    // For simplicity, we'll just call the onPressed callback here.
    onPressed?.call();
    return true;
  }
}
