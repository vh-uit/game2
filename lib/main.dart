import 'package:flutter/material.dart';
import 'package:game2/game/infinity_number_matrix_game.dart';
import "package:flutter/widgets.dart";
import 'package:flame/game.dart';
import "package:game2/widgets/number_selector_widget.dart";

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            GameWidget(
              game: InfinityNumberMatrixGame(),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: NumSelectorWidget(
                onNumberSelected: (number) {
                  // TODO: handle number selection
                },
                buttonSize: 56,
                spacing: 8,
                borderRadius: 16,
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
