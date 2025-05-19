import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

/// The main menu screen for the game.
///
/// Provides buttons to start the game or open the options screen.
class MainMenuScreen extends Component {
  /// Callback when the start button is pressed.
  final void Function()? onStart;

  /// Callback when the options button is pressed.
  final void Function()? onOptions;

  MainMenuScreen({this.onStart, this.onOptions});

  /// Loads the main menu and adds menu buttons as children.
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(
      HudButton(
        label: 'Start Game',
        onPressed: onStart,
        position: Vector2(100, 200),
      ),
    );
    add(
      HudButton(
        label: 'Options',
        onPressed: onOptions,
        position: Vector2(100, 300),
      ),
    );
  }
}

class HudButton extends PositionComponent with TapCallbacks {
  final String label;
  final void Function()? onPressed;

  HudButton({required this.label, this.onPressed, required Vector2 position}) {
    this.position = position;
    size = Vector2(200, 60);
  }

  @override
  void render(Canvas canvas) {
    final rect = size.toRect();
    final paint = Paint()..color = Colors.amber[200]!;
    canvas.drawRect(rect, paint);
    final textPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(
          color: Colors.brown[900],
          fontSize: 24,
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
    onPressed?.call();
    return true;
  }
}
