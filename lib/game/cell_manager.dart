/// Provides management for cell components within an infinite matrix world.
///
/// Handles creation, updating, and selection of cell components based on the game board state.
///
/// See also: [InfMatrixWorld], [CellComponent], [Board].
library;

// filepath: d:\Workspaces\Projects\FlutterProject\game2\lib\game\cell_manager.dart
import 'dart:math' as math_dart;
import 'package:flame/components.dart';
import 'package:game2/game/inf_matrix_world.dart';
import 'package:game2/logic/board.dart';
import 'package:game2/game/components/cell_component.dart';

/// Manages the lifecycle and state of [CellComponent]s in the game world.
///
/// Responsible for adding, updating, and selecting cells based on the [Board].
class CellManager {
  /// The infinite matrix world where cell components are placed.
  final InfMatrixWorld world;

  /// The map of grid positions to their corresponding [CellComponent]s.
  final Map<math_dart.Point<int>, CellComponent> _cellComponents = {};

  /// The currently selected cell's grid position, or null if none is selected.
  math_dart.Point<int>? selectedCellPosition;

  /// Creates a [CellManager] for the given [world].
  CellManager(this.world);

  /// All cell components managed by this instance, keyed by their grid position.
  Map<math_dart.Point<int>, CellComponent> get cellComponents =>
      _cellComponents;

  /// Initializes the board view by adding cell components for all frontier and claimed tiles.
  ///
  /// [board] is the current game board whose tiles will be visualized.
  void initializeBoardView(Board board) {
    clearAllCellComponents();
    for (final point in board.frontier) {
      addCellComponent(point, TileType.frontier);
    }
    for (final point in board.tiles) {
      addCellComponent(point, TileType.claimed);
    }
  }

  /// Adds a [CellComponent] at the given [gridPos] with the specified [type].
  ///
  /// Does nothing if a component already exists at [gridPos].
  void addCellComponent(math_dart.Point<int> gridPos, TileType type) {
    if (_cellComponents.containsKey(gridPos)) return;
    final component = CellComponent(
      gridPosition: gridPos,
      type: type,
      onTap: handleTileTap,
    );
    
    print("Adding cell component at $gridPos with type $type");
    _cellComponents[gridPos] = component;
    world.add(component);
    print("Added cell component at $gridPos with type $type");
    world.add(PositionComponent(
      position: Vector2(
        100.0,
        100.0,
      ),
      size: Vector2.all(100.0),
      anchor: Anchor.center,  
    ));
  }

  /// Updates the [CellComponent] at [gridPos] to [newType], or adds it if missing.
  void updateCellComponent(math_dart.Point<int> gridPos, TileType newType) {
    if (_cellComponents.containsKey(gridPos)) {
      _cellComponents[gridPos]!.updateType(newType);
    } else {
      addCellComponent(gridPos, newType);
    }
  }

  /// Selects the cell at [tappedGridPosition].
  ///
  /// Deselects the previously selected cell if necessary.
  void selectCell(math_dart.Point<int> tappedGridPosition) {
    if (selectedCellPosition == tappedGridPosition) {
      _cellComponents[selectedCellPosition!]!.isSelected = false;
      selectedCellPosition = null;
    } else {
      if (selectedCellPosition != null) {
        _cellComponents[selectedCellPosition!]!.isSelected = false;
      }
      selectedCellPosition = tappedGridPosition;
      _cellComponents[selectedCellPosition!]!.isSelected = true;
    }
  }

  /// Handles a tap event on a cell at [tappedGridPosition].
  void handleTileTap(math_dart.Point<int> tappedGridPosition) {
    selectCell(tappedGridPosition);
  }

  /// Removes all cell components from the world and clears the map.
  void clearAllCellComponents() {
    for (final component in _cellComponents.values) {
      component.removeFromParent();
    }
    _cellComponents.clear();
  }
}
