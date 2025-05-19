import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class MainMenuScreen extends Component {
  final void Function()? onStart;
  final void Function()? onOptions;

  MainMenuScreen({this.onStart, this.onOptions});

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
