import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game2/logic/board.dart';
import 'package:game2/game/components/cell_component.dart';
import 'dart:math' as math_dart;

class InfinityNumberMatrixGame extends FlameGame
    with ScrollDetector, ScaleDetector, KeyboardEvents {
  late Board board;
  math_dart.Point<int>? _selectedCellPosition;
  final Map<math_dart.Point<int>, CellComponent> _cellComponents = {};

  @override
  Color backgroundColor() => const Color.fromARGB(255, 255, 249, 225);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    board = Board();
    _selectedCellPosition = null;

    _initializeBoardView();
  }

  void _initializeBoardView() {
    for (final point in board.frontier) {
      _addCellComponent(point, TileType.frontier);
    }
    for (final point in board.tiles) {
      _addCellComponent(point, TileType.claimed);
    }
  }

  void _addCellComponent(math_dart.Point<int> gridPos, TileType type) {
    if (_cellComponents.containsKey(gridPos)) return; // Already exists

    final component = CellComponent(
      gridPosition: gridPos,
      type: type,
      gameRef: this,
    );
    _cellComponents[gridPos] = component;
    world.add(component);
  }

  void _updateCellComponent(math_dart.Point<int> gridPos, TileType newType) {
    if (_cellComponents.containsKey(gridPos)) {
      _cellComponents[gridPos]!.updateType(newType);
    } else {
      _addCellComponent(gridPos, newType);
    }
  }

  void handleTileTap(math_dart.Point<int> tappedGridPosition) {
    if (_selectedCellPosition == tappedGridPosition) {
      _cellComponents[_selectedCellPosition!]!.isSelected = false;
      _selectedCellPosition = null;
    } else {
      if (_selectedCellPosition != null) {
        _cellComponents[_selectedCellPosition!]!.isSelected = false;
      }
      _selectedCellPosition = tappedGridPosition;
      _cellComponents[_selectedCellPosition!]!.isSelected = true;
    }
  }

  void clampZoom(double zoomDelta) {
    double newZoom = camera.viewfinder.zoom + zoomDelta;
    camera.viewfinder.zoom = newZoom.clamp(0.5, 3.0);
  }

  static const zoomPerScrollUnit = .3;

  @override
  void onScroll(PointerScrollInfo info) {
    clampZoom(info.scrollDelta.global.y.sign * zoomPerScrollUnit);
  }

  late double startZoom;

  @override
  void onScaleStart(_) {
    startZoom = camera.viewfinder.zoom;
  }

  @override
  void onScaleUpdate(ScaleUpdateInfo info) {
    final currentScale = info.scale.global;
    print("Scale: $currentScale");
    print("Zoom level: ${camera.viewfinder.zoom}");
    if (!currentScale.isIdentity()) {
      clampZoom(startZoom * currentScale.y);
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
        if (number >= 0 && number <= 9 && _selectedCellPosition != null) {
          final result = board.claimFrontierTile(
            _selectedCellPosition!,
            number,
          );
          if (result['claimedTile'] != null) {
            _cellComponents[_selectedCellPosition!]!.value = number;
            _updateCellComponent(_selectedCellPosition!, TileType.claimed);
            for (final frontier
                in result['addedFrontier'] as List<math_dart.Point<int>>) {
              _updateCellComponent(frontier, TileType.frontier);
            }
            print(board.findChainsWithSum(_selectedCellPosition!, 20));
          }
        }
      }
    }
    return KeyEventResult.handled;
  }
}
