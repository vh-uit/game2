import 'package:flame/components.dart';
import 'package:flutter/material.dart';

/// A simple loading scene to show while the game is initializing.
class LoadingScene extends Component {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    final size = canvas.getLocalClipBounds();
    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'Loading...',
        style: TextStyle(
          color: Colors.white,
          fontSize: 36,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout();
    textPainter.paint(
      canvas,
      Offset((size.width - textPainter.width) / 2, (size.height - textPainter.height) / 2),
    );
  }
}
