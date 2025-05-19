import 'package:flutter/material.dart';
import 'package:game2/game/infinity_number_matrix_game.dart';
import 'package:flame/game.dart';
import "package:game2/widgets/number_selector_widget.dart";
import 'package:game2/widgets/main_menu_screen.dart';
import 'package:game2/widgets/options_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  bool showNumSelector = true;

  @override
  Widget build(BuildContext context) {
    final game = InfinityNumberMatrixGame();
    return NumSelectorOptions(
      showNumSelector: showNumSelector,
      onToggle: (value) => setState(() => showNumSelector = value),
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) => const MainMenuScreen(),
          '/game': (context) => Scaffold(
                body: Stack(
                  children: [
                    GameWidget(game: game),
                    if (NumSelectorOptions.of(context)?.showNumSelector ?? true)
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: NumSelectorWidget(
                          onNumberSelected: (number) {
                            game.attemptClaimTile(number);
                          },
                          buttonSize: 56,
                          spacing: 8,
                          borderRadius: 16,
                          fontSize: 24,
                        ),
                      ),
                    Positioned(
                      top: 32,
                      right: 16,
                      child: IconButton(
                        icon: Icon(Icons.settings),
                        tooltip: 'Options',
                        onPressed: () {
                          Navigator.pushNamed(context, '/options');
                        },
                      ),
                    ),
                  ],
                ),
              ),
          '/options': (context) => const OptionsScreen(),
        },
      ),
    );
  }
}
