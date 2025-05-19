import 'package:flame/game.dart';
import 'package:flutter/material.dart' hide Route, OverlayRoute;
import 'package:game2/widgets/options_screen.dart';
import '../widgets/number_selector_widget.dart';
import '../widgets/player_score_overlay.dart';
import 'screens/main_menu_screen.dart';
import 'inf_matrix_world.dart';

class RouterManager {
  static void setupOverlaysAndRouter({
    required FlameGame game,
    required InfMatrixWorld gameWorld,
    required ValueNotifier<int> playerScoreNotifier,
    required Function(int) attemptClaimTile,
    required Function() openOptions,
    required Function() closeOptions,
    required Function({bool restart}) startGame,
    required NumSelectorMode numSelectorMode,
    required void Function(NumSelectorMode) onModeChanged,
    required void Function(String) addOverlay,
    required void Function(String) removeOverlay,
    required void Function(RouterComponent) setRouter,
  }) {
    
    game.overlays.addEntry(
      'NumSelectorBottom',
      (context, game) => NumSelectorWidget(
      onNumberSelected: (number) {
        attemptClaimTile(number);
      },
      buttonSize: 48,
      spacing: 8,
      borderRadius: 12,
      fontSize: 24,
      bottomAlignment: true,
      ),
    );

    game.overlays.addEntry(
      'NumSelectorTop',
      (context, game) => NumSelectorWidget(
      onNumberSelected: (number) {
        attemptClaimTile(number);
      },
      buttonSize: 48,
      spacing: 8,
      borderRadius: 12,
      fontSize: 24,
      bottomAlignment: false,
      ),
    );
    game.overlays.addEntry('PlayerScore', (context, game) {
      return PlayerScoreOverlay(
        player: gameWorld.board.currentPlayer,
        scoreNotifier: playerScoreNotifier,
      );
    });
    game.overlays.addEntry('SettingsIcon', (context, game) {
      return Positioned(
        top: 24,
        right: 24,
        child: GestureDetector(
          onTap: openOptions,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.settings,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
      );
    });
    late final RouterComponent router;
    router = RouterComponent(
      initialRoute: 'main_menu',
      routes: {
        'main_menu': Route(
          () => MainMenuScreen(onStart: () async {
            startGame();
          }, onOptions: openOptions),
          maintainState: false,
        ),
        'game': WorldRoute(
          () => gameWorld,
          maintainState: false,
        ),
        'options': OverlayRoute((context, game) => OptionsScreen(
          onBack: closeOptions,
          onRestart: () {
            closeOptions();
            startGame(restart: true);
          },
          onQuit: () {
            closeOptions();
            startGame(restart: true);
            router.pushNamed('main_menu');
          },
          numSelectorMode: numSelectorMode,
          onModeChanged: onModeChanged,
        )),
      },
    );
    setRouter(router);
  }
}
