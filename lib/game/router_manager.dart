import 'package:flame/game.dart';
import 'package:flutter/material.dart' hide Route, OverlayRoute;
import 'package:game2/logic/player.dart';
import 'package:game2/widgets/options_screen.dart';
import '../widgets/number_selector_widget.dart';
import '../widgets/player_score_overlay.dart';
import 'screens/main_menu_screen.dart';
import 'screens/win_screen.dart';
import 'inf_matrix_world.dart';

class RouterManager {
  static void setupOverlaysAndRouter({
    required FlameGame game,
    required InfMatrixWorld gameWorld,
    required ValueNotifier<List<Player>> playerScoreNotifier,
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
        players: gameWorld.board.players,
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

    game.overlays.addEntry('WinScreen', (context, game) {
      return WinScreen(
        playerName: gameWorld.board.currentPlayer.name, // Replace with actual winner name
        score: gameWorld.board.currentPlayer.score, // Replace with actual score
        onRestart: () {
          game.overlays.remove('WinScreen');
          startGame(restart: true);
        },
        onQuit: () {
          game.overlays.remove('WinScreen');
          startGame(restart: true);
          // Optionally, navigate to main menu if needed
        },
      );
    });
    int playerCount = 1;
    late final RouterComponent router;
    router = RouterComponent(
      initialRoute: 'main_menu',
      routes: {
        'main_menu': Route(
          () => MainMenuScreen(
            onStart: (count) {
              playerCount = count;
              router.pushReplacementNamed('game');
              addOverlay('NumSelectorBottom');
              addOverlay('NumSelectorTop');
              addOverlay('PlayerScore');
              addOverlay('SettingsIcon');
              Future.delayed(const Duration(milliseconds: 30), () {
                gameWorld.reset(numPlayers: playerCount);
              });
            },
            onOptions: openOptions,
          ),
          maintainState: false,
        ),
        'game': WorldRoute(
          () => gameWorld,
          maintainState: false,
        ),
        'options': OverlayRoute((context, game) => OptionsScreen(
          onBack: closeOptions,
          onRestart: () {
            startGame(restart: true);
          },
          onQuit: () {
            startGame(restart: true);
            removeOverlay("NumSelectorBottom");
            removeOverlay("NumSelectorTop");
            removeOverlay("PlayerScore");
            removeOverlay("SettingsIcon");
            router.pushNamed('main_menu');
          },
          numSelectorMode: numSelectorMode,
          onModeChanged: onModeChanged,
        )),
        'win': OverlayRoute((context, game) => WinScreen(
          playerName: 'Winner', // Replace with actual winner name
          score: 0, // Replace with actual score
          onRestart: () {
            removeOverlay('WinScreen');
            startGame(restart: true);
          },
          onQuit: () {
            removeOverlay('WinScreen');
            startGame(restart: true);
            removeOverlay("NumSelectorBottom");
            removeOverlay("NumSelectorTop");
            removeOverlay("PlayerScore");
            removeOverlay("SettingsIcon");
            router.pushNamed('main_menu');
          },
        )),
      },
    );
    setRouter(router);
  }
}
