/// A world representing the infinite number matrix game board.
///
/// Manages the board state, cell components, player, and score updates.
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/services.dart';
import 'package:game2/config.dart';
import 'package:game2/logic/board.dart';
import 'package:game2/logic/player.dart';
import 'cell_manager.dart';
import 'dart:math' as math_dart;

class InfMatrixWorld extends World {
  /// The logical board for the game.
  late Board board;

  /// Manages cell components within this world.
  late CellManager cellManager;

  /// The initial zoom level for the world view.
  late double startZoom;

  /// Creates an [InfMatrixWorld].
  InfMatrixWorld();

  /// Loads the board, cell manager, and player, and sets up overlays.
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    board = Board();
    cellManager = CellManager(this);
    await reset();
  }

  Future<void> reset({int numPlayers = 1}) async {
    board.reset(playerNumber: numPlayers);
    cellManager.initializeBoardView(board);
    cellManager.selectedCellPosition = null;
    final game = findGame();
    game?.overlays.remove("PlayerScore");
    game?.overlays.add('PlayerScore');
    game?.overlays.add('SettingsIcon');
    game?.overlays.add('NumSelectorBottom');
  }

  /// Attempts to claim a tile with the given [number].
  void attemptClaimTile(int number) => _attemptClaimTile(number);

  /// Internal logic for claiming a tile and updating components.
  void _attemptClaimTile(int number) {
    if (cellManager.selectedCellPosition == null) return;
    final result = board.claimFrontierTile(
      cellManager.selectedCellPosition!,
      number,
    );
    if (result['claimedTile'] != null) {
      cellManager.cellComponents[cellManager.selectedCellPosition!]!
          .setValueAndType(number, TileType.claimed);
      for (final frontier
          in result['addedFrontier'] as List<math_dart.Point<int>>) {
        cellManager.updateCellComponent(frontier, TileType.frontier);
      }
      final chains = board.findChainsWithSum(
        cellManager.selectedCellPosition!,
        20,
      );
      if (chains.isNotEmpty) {
        animateChainsHighlight(chains);
        board.currentPlayer.updateScore(
          board.currentPlayer.calculateScoreFromChains(chains),
        );
      }
      if (board.nextPlayer()) {
        findGame()?.overlays.add('WinScreen');
      }
      print(board.currentPlayer.name);

      findGame()?.overlays.remove('PlayerScore');
      findGame()?.overlays.add('PlayerScore');
    }
  }

  // The following input handlers must be called from the parent FlameGame
  void handleScroll(PointerScrollInfo info, CameraComponent camera) {
    clampZoom(
      camera.viewfinder.zoom +
          info.scrollDelta.global.y.sign * zoomPerScrollUnit,
      camera,
    );
  }

  void handleScaleStart(CameraComponent camera) {
    startZoom = camera.viewfinder.zoom;
  }

  void handleScaleUpdate(ScaleUpdateInfo info, CameraComponent camera) {
    final currentScale = info.scale.global;
    if (!currentScale.isIdentity()) {
      clampZoom((currentScale.y) * startZoom, camera);
    } else {
      final delta = info.delta.global;
      camera.moveBy(-delta);
    }
  }

  void handleKeyEvent(KeyEvent event, CameraComponent camera) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        camera.moveBy(Vector2(0, -10));
      } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        camera.moveBy(Vector2(0, 10));
      } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        camera.moveBy(Vector2(-10, 0));
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        camera.moveBy(Vector2(10, 0));
      } else if (event.logicalKey.keyLabel.length == 1 &&
          int.tryParse(event.logicalKey.keyLabel) != null) {
        int number = int.parse(event.logicalKey.keyLabel);
        if (number >= 0 && number <= 9) {
          _attemptClaimTile(number);
        }
      }
    }
  }

  void clampZoom(double zoomDelta, CameraComponent camera) {
    camera.viewfinder.zoom = zoomDelta.clamp(0.5, 3.0);
  }

  static const zoomPerScrollUnit = .3;

  Future<void> animateChainHighlight(
    List<math_dart.Point<int>> points,
    Duration duration,
  ) async {
    for (final point in points) {
      final cell = cellManager.cellComponents[point];
      if (cell != null) {
        await cell.highlight(
          duration: duration,
          nth: points.indexOf(point).toDouble(),
        );
      }
    }
  }

  Future<void> animateChainsHighlight(
    List<List<math_dart.Point<int>>> chains,
  ) async {
    final futures1 = <Future>[];
    for (final chain in chains) {
      futures1.add(
        animateChainHighlight(chain, const Duration(milliseconds: 700)),
      );
    }
    await Future.wait(futures1);
    final allPoints = <math_dart.Point<int>>{};
    for (final chain in chains) {
      allPoints.addAll(chain);
    }
    final futures = <Future>[];
    for (final point in allPoints) {
      final cell = cellManager.cellComponents[point];
      if (cell != null) {
        futures.add(
          cell.highlight(
            duration: const Duration(milliseconds: 700),
            nth: 1,
            color: highlight2Color.color,
          ),
        );
      }
    }
    await Future.wait(futures);
  }
}
