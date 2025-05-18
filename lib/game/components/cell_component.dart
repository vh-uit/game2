// lib/game/components/cell_component.dart
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/cupertino.dart';
import 'package:game2/game/infinity_number_matrix_game.dart'; // To call back to game
import 'package:game2/logic/board.dart' show TileType; // Avoid Point ambiguity
import 'package:game2/config.dart';
import 'dart:math' as math; // For Point

class CellComponent extends PositionComponent with TapCallbacks {
  final math.Point<int> gridPosition;
  TileType type;
  final InfinityNumberMatrixGame gameRef;
  int value = 0; 
  bool isSelected = false;
  late Paint _paint;

  // Remove value parameter from constructor, always use explicit setter for value.
  CellComponent({
    required this.gridPosition,
    required this.type,
    required this.gameRef,
    this.isSelected = false,
  }) : super(
          position: Vector2(
            gridPosition.x * (cellSize + cellMargin),
            gridPosition.y * (cellSize + cellMargin),
          ),
          size: Vector2.all(cellSize),
        ) {
    _updatePaint();
  }

  // Remove value from _updatePaint, only add TextComponent if type is claimed and value != 0
  void _updatePaint() {
    switch (type) {
      case TileType.claimed:
        _paint = claimedColor.paint();
        if (value != 0) {
          add(TextComponent(
            text: value.toString(),
            position: Vector2(cellSize / 2, cellSize / 2),
            anchor: Anchor.center,
            textRenderer: TextPaint(
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                fontSize: cellSize * 0.7,
                color: CupertinoColors.white,
              ),
            ),
          ));
        }
        break;
      case TileType.frontier:
        _paint = frontierColor.paint();
        break;
      case TileType.empty:
        _paint = emptyColor.paint(); 
        break;
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRect(size.toRect(), _paint);

    final borderPaint = Paint()
      ..color = isSelected ? frontierColor.color.withAlpha(150) : defaultBorderColor.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawRect(size.toRect().deflate(1.5), borderPaint);
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (type == TileType.frontier) {
      print("CellComponent tapped at $gridPosition (Frontier)");
      gameRef.handleTileTap(gridPosition);
    } else {
      print("CellComponent tapped at $gridPosition (Type: $type) - No action");
    }
  }

  void updateType(TileType newType) {
    if (type != newType) {
      type = newType;
      _updatePaint();
    }
  }

  /// Atomically set the value and type of the cell, and update paint.
  void setValueAndType(int newValue, TileType newType) {
    value = newValue;
    updateType(newType);
  }
}