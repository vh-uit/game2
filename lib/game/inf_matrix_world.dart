import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/services.dart';
import 'package:game2/config.dart';
import 'package:game2/logic/board.dart';
import 'package:game2/logic/player.dart';
import 'cell_manager.dart';
import 'dart:math' as math_dart;
import 'package:flutter/foundation.dart';

class InfMatrixWorld extends World  {
  late Board board;
  late final CellManager cellManager;
  late double startZoom;
  late Player player;
  final ValueNotifier<int> scoreNotifier;

  InfMatrixWorld({required this.scoreNotifier});

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    board = await compute(_createBoardInIsolate, null);
    cellManager = CellManager(this);
    cellManager.selectedCellPosition = null;
    cellManager.initializeBoardView(board);
    player = Player(name: 'Player 1');
    // Remove NumSelectorComponent from world, use overlay instead
    final game = findGame();
    game?.overlays.add('NumSelector');
    game?.overlays.add('PlayerScore');
  }

  static Board _createBoardInIsolate(dynamic _) {
    return Board();
  }

  void attemptClaimTile(int number) => _attemptClaimTile(number);

  void _attemptClaimTile(int number) {
    if (cellManager.selectedCellPosition == null) return;
    final result = board.claimFrontierTile(cellManager.selectedCellPosition!, number);
    if (result['claimedTile'] != null) {
      cellManager.cellComponents[cellManager.selectedCellPosition!]!.setValueAndType(number, TileType.claimed);
      for (final frontier in result['addedFrontier'] as List<math_dart.Point<int>>) {
        cellManager.updateCellComponent(frontier, TileType.frontier);
      }
      final chains = board.findChainsWithSum(cellManager.selectedCellPosition!, 20);
      if (chains.isNotEmpty) {
        animateChainsHighlight(chains);
        player.updateScore(calcScore(chains));
        scoreNotifier.value = player.score;
      }
    }
  }

  int calcScore(List<List<math_dart.Point<int>>> chains) {
    int score = 0;
    final uniqueCells = <math_dart.Point<int>>{};
    for (final chain in chains) {
      uniqueCells.addAll(chain);
    }
    score = uniqueCells.length;
    print("Score calculated: $score");
    return score;
  }


  // The following input handlers must be called from the parent FlameGame
  void handleScroll(PointerScrollInfo info, CameraComponent camera) {
    clampZoom(camera.viewfinder.zoom + info.scrollDelta.global.y.sign * zoomPerScrollUnit, camera);
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

  Future<void> animateChainHighlight(List<math_dart.Point<int>> points, Duration duration) async {
    for (final point in points) {
      final cell = cellManager.cellComponents[point];
      if (cell != null) {
        await cell.highlight(duration: duration, nth: points.indexOf(point).toDouble());
      }
    }
  }

  Future<void> animateChainsHighlight(List<List<math_dart.Point<int>>> chains) async {
    final futures1 = <Future>[];
    for (final chain in chains) {
      futures1.add(animateChainHighlight(chain, const Duration(milliseconds: 700)));
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
        futures.add(cell.highlight(duration: const Duration(milliseconds: 700), nth: 1, color: highlight2Color.color));
      }
    }
    await Future.wait(futures);
  }
}
