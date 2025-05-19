/// The entry point of the application.
///
/// Initializes the game and runs the Flutter app with the [InfinityNumberMatrixGameWithRouter].

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:game2/game/screens/win_screen.dart';
import 'game/game.dart';

void main() {
  final game = InfinityNumberMatrixGameWithRouter();
  runApp(GameWidget(game: game));
}
