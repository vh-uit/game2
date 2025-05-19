import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart' show KeyEventResult;
import 'inf_matrix_world.dart';

mixin InputHandler on FlameGame implements ScaleDetector, TapDetector, KeyboardEvents, ScrollDetector {
  late InfMatrixWorld gameWorld;

  @override
  void onScroll(PointerScrollInfo info) {
    gameWorld.handleScroll(info, camera);
  }

  @override
  void onScaleStart(ScaleStartInfo info) {
    gameWorld.handleScaleStart(camera);
  }

  @override
  void onScaleUpdate(ScaleUpdateInfo info) {
    gameWorld.handleScaleUpdate(info, camera);
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    gameWorld.handleKeyEvent(event, camera);
    return KeyEventResult.handled;
  }
}
