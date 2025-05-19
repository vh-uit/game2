import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flutter/services.dart';
import 'package:game2/widgets/options_screen.dart';
import '../config.dart';
import 'inf_matrix_world.dart';
import 'router_manager.dart';
import 'input_handler.dart';
import 'package:flutter/material.dart' hide Route, OverlayRoute;

/// The main game class for Infinity Number Matrix.
///
/// Handles routing, overlays, and game state management using Flame and Flutter widgets.
class InfinityNumberMatrixGameWithRouter extends FlameGame
    with ScaleDetector, TapDetector, KeyboardEvents, ScrollDetector, InputHandler {
  /// The router component for managing navigation between screens.
  late final RouterComponent router;

  @override
  late InfMatrixWorld gameWorld;

  /// Notifies listeners of the player's score changes.
  final ValueNotifier<int> playerScoreNotifier = ValueNotifier<int>(0);

  /// Returns the background color for the game.
  @override
  Color backgroundColor() => gameBackgroundColor;

  /// Loads overlays and initializes the router.
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    gameWorld = InfMatrixWorld(scoreNotifier: playerScoreNotifier);
    RouterManager.setupOverlaysAndRouter(
      game: this,
      gameWorld: gameWorld,
      playerScoreNotifier: playerScoreNotifier,
      attemptClaimTile: attemptClaimTile,
      openOptions: openOptions,
      closeOptions: closeOptions,
      startGame: startGame,
      numSelectorMode: numSelectorMode,
      onModeChanged: (mode) {
        numSelectorMode = mode;
        print('NumSelectorMode changed to: $mode');
        overlays.remove('NumSelectorBottom');
        overlays.remove('NumSelectorTop');
        if (mode == NumSelectorMode.none) {
          return;
        }
        overlays.add("NumSelectorBottom");
        if (mode == NumSelectorMode.double) {
          overlays.add("NumSelectorTop");
        }
      },
      addOverlay: overlays.add,
      removeOverlay: overlays.remove,
      setRouter: (routerComponent) => router = routerComponent,
    );
    await add(router);
  }

  void startGame({bool restart = false}) {
    if (restart) {
      // Remove the current game world if it exists
      gameWorld.reset();
    }
    router.popUntilNamed('main_menu');
    router.pushNamed('game');
  }

  void openOptions() => router.pushNamed('options');
  void closeOptions() => router.pop();

  @override
  void onScroll(PointerScrollInfo info) {
    super.onScroll(info);
    gameWorld.handleScroll(info, camera);
  }

  @override
  void onScaleStart(ScaleStartInfo info) {
    super.onScaleStart(info);
    gameWorld.handleScaleStart(camera);
  }

  @override
  void onScaleUpdate(ScaleUpdateInfo info) {
    super.onScaleUpdate(info);
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

  void attemptClaimTile(int number) {
    gameWorld.attemptClaimTile(number);
  }

  // Add a field to InfinityNumberMatrixGameWithRouter:
  NumSelectorMode numSelectorMode = NumSelectorMode.single;
}
