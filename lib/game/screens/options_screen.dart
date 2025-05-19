import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

/// The options screen for the game.
///
/// Provides toggles and buttons for game options such as showing the number selector, restarting, quitting, or going back.
class OptionsScreen extends Component {
  /// Whether the number selector should be shown.
  final bool showNumSelector;

  /// Callback when the number selector toggle is changed.
  final ValueChanged<bool>? onToggle;

  /// Callback when the restart button is pressed.
  final void Function()? onRestart;

  /// Callback when the quit button is pressed.
  final void Function()? onQuit;

  /// Callback when the back button is pressed.
  final void Function()? onBack;

  OptionsScreen({
    this.showNumSelector = true,
    this.onToggle,
    this.onRestart,
    this.onQuit,
    this.onBack,
  });

  /// Loads the options screen and adds option controls as children.
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(
      _HudSwitchRow(
        label: 'Show Number Selector',
        value: showNumSelector,
        onChanged: onToggle,
        position: Vector2(100, 100),
      ),
    );
    add(
      _HudButton(
        label: 'Restart Game',
        onPressed: onRestart,
        position: Vector2(100, 200),
      ),
    );
    add(
      _HudButton(
        label: 'Quit Game',
        onPressed: onQuit,
        position: Vector2(100, 300),
      ),
    );
    add(
      _HudButton(label: 'Back', onPressed: onBack, position: Vector2(100, 400)),
    );
  }
}

class _HudButton extends PositionComponent with TapCallbacks {
  final String label;
  final void Function()? onPressed;

  _HudButton({required this.label, this.onPressed, required Vector2 position}) {
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

class _HudSwitchRow extends PositionComponent with TapCallbacks {
  final String label;
  final bool value;
  final ValueChanged<bool>? onChanged;

  _HudSwitchRow({
    required this.label,
    required this.value,
    this.onChanged,
    required Vector2 position,
  }) {
    this.position = position;
    size = Vector2(320, 60);
  }

  @override
  void render(Canvas canvas) {
    final rect = size.toRect();
    final paint = Paint()..color = Colors.amber[100]!;
    canvas.drawRect(rect, paint);
    final textPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(color: Colors.brown[900], fontSize: 20),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
    )..layout(maxWidth: size.x - 80);
    textPainter.paint(canvas, Offset(10, (size.y - textPainter.height) / 2));
    // Draw switch (as a simple rectangle for now)
    final switchRect = Rect.fromLTWH(size.x - 70, 15, 50, 30);
    final switchPaint = Paint()..color = value ? Colors.green : Colors.red;
    canvas.drawRect(switchRect, switchPaint);
  }

  @override
  bool onTapDown(TapDownEvent event) {
    onChanged?.call(!value);
    return true;
  }
}
