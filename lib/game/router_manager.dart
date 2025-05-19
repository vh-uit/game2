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
      'NumSelector',
      (context, game) {
        if (numSelectorMode == NumSelectorMode.none) {
          return const SizedBox.shrink();
        } else if (numSelectorMode == NumSelectorMode.single) {
          return NumSelectorWidget(
            onNumberSelected: (number) {
              attemptClaimTile(number);
            },
            buttonSize: 48,
            spacing: 8,
            borderRadius: 12,
            fontSize: 24,
            bottomAlignment: true,
          );
        } else if (numSelectorMode == NumSelectorMode.double) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              NumSelectorWidget(
                onNumberSelected: (number) {
                  attemptClaimTile(number);
                },
                buttonSize: 48,
                spacing: 8,
                borderRadius: 12,
                fontSize: 24,
                bottomAlignment: false,
              ),
              NumSelectorWidget(
                onNumberSelected: (number) {
                  attemptClaimTile(number);
                },
                buttonSize: 48,
                spacing: 8,
                borderRadius: 12,
                fontSize: 24,
                bottomAlignment: true,
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
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
            addOverlay('Loading');
            startGame();
          }, onOptions: openOptions),
        ),
        'game': WorldRoute(
          () => gameWorld,
        ),
        'options': OverlayRoute((context, game) => OptionsScreen(
          onBack: closeOptions,
          onRestart: () {
            closeOptions();
            addOverlay('Loading');
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
    game.overlays.addEntry('Loading', (context, game) => const Center(
      child: CircularProgressIndicator(color: Colors.amber),
    ));
    setRouter(router);
  }
}
