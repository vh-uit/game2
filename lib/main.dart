import 'package:flutter/material.dart';
import 'package:game2/game/infinity_number_matrix_game.dart';
import "package:flutter/widgets.dart";
import 'package:flame/game.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GameWidget(
      game: InfinityNumberMatrixGame(),
      
    );
  }
}
