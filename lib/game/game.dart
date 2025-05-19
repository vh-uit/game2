import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flutter/services.dart';
import '../config.dart';
import 'screens/main_menu_screen.dart';
import 'screens/options_screen.dart';
import 'inf_matrix_world.dart';
import 'package:flutter/widgets.dart' hide Route;
import '../widgets/number_selector_widget.dart';
import 'package:flutter/material.dart' hide Route;
import '../widgets/player_score_overlay.dart';

/// The main game class for Infinity Number Matrix.
///
/// Handles routing, overlays, and game state management using Flame and Flutter widgets.
class InfinityNumberMatrixGameWithRouter extends FlameGame with ScaleDetector, TapDetector, KeyboardEvents, ScrollDetector {
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
      (context, game) => NumSelectorWidget(
        onNumberSelected: (number) {
          attemptClaimTile(number);
        },
        buttonSize: 48,
        spacing: 8,
        borderRadius: 12,
        fontSize: 24,
      ),
    );
    overlays.addEntry(
      'PlayerScore',
      (context, game) {
        final world = currentWorld;
        if (world != null) {
          return PlayerScoreOverlay(player: world.player, scoreNotifier: playerScoreNotifier);
        } else {
          // fallback empty widget
          return const SizedBox.shrink();
        }
      },
    );
    router = RouterComponent(
      initialRoute: 'main_menu',
      routes: {
        'main_menu': Route(() => MainMenuScreen(
              onStart: startGame,
              onOptions: openOptions,
            )),
        'game': WorldRoute(() => InfMatrixWorld(scoreNotifier: playerScoreNotifier)),
        'options': Route(() => OptionsScreen(
              onBack: closeOptions,
            )),
      },
    );
    await add(router);
  }


  void startGame() => router.pushNamed('game');
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
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
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
}
