import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game2/config.dart';
import 'package:game2/logic/board.dart';
import 'cell_manager.dart';
import 'dart:math' as math_dart;
import 'package:flutter/foundation.dart';

class InfinityNumberMatrixGame extends FlameGame
    with ScrollDetector, ScaleDetector, KeyboardEvents {
  late Board board;
  late final CellManager cellManager;

  @override
  Color backgroundColor() => const Color.fromARGB(255, 255, 249, 225);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // Move board creation to a background isolate
    board = await compute(_createBoardInIsolate, null);
    cellManager = CellManager(this);
    cellManager.selectedCellPosition = null;
    cellManager.initializeBoardView(board);
  }

  // Helper for compute
  static Board _createBoardInIsolate(dynamic _) {
    return Board();
  }

  /// Attempts to claim a tile at the selected position with the given number.
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
      }
    }
  }

  void clampZoom(double zoomDelta) {
    camera.viewfinder.zoom = zoomDelta.clamp(0.5, 3.0);
  }

  static const zoomPerScrollUnit = .3;

  @override
  void onScroll(PointerScrollInfo info) {
    clampZoom(camera.viewfinder.zoom + info.scrollDelta.global.y.sign * zoomPerScrollUnit);
  }

  late double startZoom;

  @override
  void onScaleStart(_) {
    startZoom = camera.viewfinder.zoom;
    
  }

  @override
  void onScaleUpdate(ScaleUpdateInfo info) {
    final currentScale = info.scale.global;
    
    if (!currentScale.isIdentity()) {
      clampZoom((currentScale.y)*startZoom);
    } else {
      final delta = info.delta.global;
      camera.moveBy(-delta);
    }
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
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
    return KeyEventResult.handled;
  }

  /// Animates (highlights) the given list of points, one after another, each for 0.7s.
  Future<void> animateChainHighlight(List<math_dart.Point<int>> points, Duration duration) async {
    for (final point in points) {
      final cell = cellManager.cellComponents[point];
      if (cell != null) {
        await cell.highlight(duration: duration, nth: points.indexOf(point).toDouble());
      }
    }
  }

  /// Animates (highlights) all chains in parallel, each cell for 0.7s.
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
