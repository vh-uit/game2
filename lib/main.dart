import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';
import 'game/game.dart';

void main() {
  final game = InfinityNumberMatrixGameWithRouter();
  runApp(GameWidget(game: game));
}
