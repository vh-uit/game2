import 'dart:math' as math_dart;
import 'package:game2/logic/board.dart';
import 'package:game2/game/components/cell_component.dart';
import 'infinity_number_matrix_game.dart';

class CellManager {
  final InfinityNumberMatrixGame game;
  final Map<math_dart.Point<int>, CellComponent> _cellComponents = {};
  math_dart.Point<int>? _selectedCellPosition;

  CellManager(this.game);

  Map<math_dart.Point<int>, CellComponent> get cellComponents => _cellComponents;
  math_dart.Point<int>? get selectedCellPosition => _selectedCellPosition;
  set selectedCellPosition(math_dart.Point<int>? pos) => _selectedCellPosition = pos;

  void initializeBoardView(Board board) {
    for (final point in board.frontier) {
      addCellComponent(point, TileType.frontier);
    }
    for (final point in board.tiles) {
      addCellComponent(point, TileType.claimed);
    }
  }

  void addCellComponent(math_dart.Point<int> gridPos, TileType type) {
    if (_cellComponents.containsKey(gridPos)) return;
    final component = CellComponent(
      gridPosition: gridPos,
      type: type,
      gameRef: game,
    );
    _cellComponents[gridPos] = component;
    game.world.add(component);
  }

  void updateCellComponent(math_dart.Point<int> gridPos, TileType newType) {
    if (_cellComponents.containsKey(gridPos)) {
      _cellComponents[gridPos]!.updateType(newType);
    } else {
      addCellComponent(gridPos, newType);
    }
  }

  void selectCell(math_dart.Point<int> tappedGridPosition) {
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

  void handleTileTap(math_dart.Point<int> tappedGridPosition) {
    selectCell(tappedGridPosition);
  }
}
