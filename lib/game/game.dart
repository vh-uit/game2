import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flutter/services.dart';
import 'package:game2/widgets/options_screen.dart';
import '../config.dart';
import 'screens/main_menu_screen.dart';
import 'inf_matrix_world.dart';
import '../widgets/number_selector_widget.dart';
import 'package:flutter/material.dart' hide Route, OverlayRoute;
import '../widgets/player_score_overlay.dart';

/// The main game class for Infinity Number Matrix.
///
/// Handles routing, overlays, and game state management using Flame and Flutter widgets.
class InfinityNumberMatrixGameWithRouter extends FlameGame
    with ScaleDetector, TapDetector, KeyboardEvents, ScrollDetector {
  /// The router component for managing navigation between screens.
  late final RouterComponent router;

  /// Notifies listeners of the player's score changes.
  final ValueNotifier<int> playerScoreNotifier = ValueNotifier<int>(0);

  /// Returns the background color for the game.
  @override
  Color backgroundColor() => gameBackgroundColor;

  /// Loads overlays and initializes the router.
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    overlays.addEntry(
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
          // For demonstration, show two selectors stacked
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
    overlays.addEntry('PlayerScore', (context, game) {
      final world = currentWorld;
      if (world != null) {
        return PlayerScoreOverlay(
          player: world.board.currentPlayer,
          scoreNotifier: playerScoreNotifier,
        );
      } else {
        // fallback empty widget
        return const SizedBox.shrink();
      }
    });
    router = RouterComponent(
      initialRoute: 'main_menu',
      routes: {
        'main_menu': Route(
          () => MainMenuScreen(onStart: () async {
            // Show loading scene before starting game
            overlays.add('Loading');
            await Future.delayed(const Duration(seconds: 1)); // Simulate loading
            overlays.remove('Loading');
            startGame();
          }, onOptions: openOptions),
        ),
        'game': WorldRoute(
          () => InfMatrixWorld(scoreNotifier: playerScoreNotifier),
        ),
        'options': OverlayRoute((context, game) => OptionsScreen(
          onBack: closeOptions,
          onRestart: () {
            overlays.add('Loading');
            Future.delayed(const Duration(seconds: 1), () {
              overlays.remove('Loading');
              startGame(restart: true);
            });
          },
          onQuit: () {
            // Fallback: just pop the overlay and return to main menu
            closeOptions();
            router.pushNamed('main_menu');
          },
          numSelectorMode: numSelectorMode,
          onModeChanged: (mode) {
            numSelectorMode = mode;
            overlays.remove('NumSelector');
            overlays.add('NumSelector');
          },
        )),
      },
    );
    // Register loading overlay
    overlays.addEntry('Loading', (context, game) => const Center(
      child: CircularProgressIndicator(color: Colors.amber),
    ));
    await add(router);
  }

  void startGame({bool restart = false}) {
    if (restart) {
      // Remove the current game world if it exists
      final world = currentWorld;
      if (world != null) {
        world.removeFromParent();
      }
      // Optionally reset score
      playerScoreNotifier.value = 0;
    }
    router.pushNamed('game');
  }

  void openOptions() => router.pushNamed('options');
  void closeOptions() => router.pop();

  InfMatrixWorld? get currentWorld {
    final route = router.currentRoute;
    if (route.name == 'game') {
      for (final child in children) {
        if (child is InfMatrixWorld) return child;
      }
    }
    return null;
  }

  @override
  void onScroll(PointerScrollInfo info) {
    super.onScroll(info);
    final world = currentWorld;
    if (world != null) {
      world.handleScroll(info, camera);
    }
  }

  @override
  void onScaleStart(ScaleStartInfo info) {
    super.onScaleStart(info);
    final world = currentWorld;
    if (world != null) {
      world.handleScaleStart(camera);
    }
  }

  @override
  void onScaleUpdate(ScaleUpdateInfo info) {
    super.onScaleUpdate(info);
    final world = currentWorld;
    if (world != null) {
      world.handleScaleUpdate(info, camera);
    }
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    final world = currentWorld;
    if (world != null) {
      world.handleKeyEvent(event, camera);
      return KeyEventResult.handled;
    }
    return super.onKeyEvent(event, keysPressed);
  }

  void attemptClaimTile(int number) {
    final world = currentWorld;
    if (world != null) {
      world.attemptClaimTile(number);
    }
  }

  // Add a field to InfinityNumberMatrixGameWithRouter:
  NumSelectorMode numSelectorMode = NumSelectorMode.single;
}
