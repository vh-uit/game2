// lib/game/components/cell_component.dart
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/cupertino.dart';
import 'package:game2/logic/board.dart' show TileType; // Avoid Point ambiguity
import 'package:game2/config.dart';
import 'dart:math' as math; // For Point

class CellComponent extends PositionComponent with TapCallbacks {
  final math.Point<int> gridPosition;
  TileType type;
  final void Function(math.Point<int>)? onTap;
  int value = 0; 
  bool _isSelected = false;
  bool get isSelected => _isSelected;
  set isSelected(bool value) {
    if (_isSelected != value) {
      _isSelected = value;
      _updatePaint();
    }
  }
  late Paint _paint;
  late Paint _borderPaint;

  CellComponent({
    required this.gridPosition,
    required this.type,
    this.onTap,
    bool isSelected = false,
  }) : _isSelected = isSelected,
        super(
          position: Vector2(
            gridPosition.x * (cellSize + cellMargin),
            gridPosition.y * (cellSize + cellMargin),
          ),
          size: Vector2.all(cellSize),
        ) {
    _updatePaint();
  }

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
        if (isSelected) {
          _paint.color = Color.alphaBlend(frontierColor.color.withAlpha(600), highlight2Color.color.withAlpha(50));
        }
        break;
      case TileType.empty:
        _paint = emptyColor.paint(); 
        break;
    }

    _borderPaint = Paint()
      ..color = isSelected && type == TileType.frontier ? frontierColor.color.withAlpha(150) : defaultBorderColor.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRect(size.toRect(), _paint);
    canvas.drawRect(size.toRect().deflate(1.5), _borderPaint);
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (type == TileType.frontier) {
      print("CellComponent tapped at $gridPosition (Frontier)");
      onTap?.call(gridPosition);
    } else {
      print("CellComponent tapped at $gridPosition (Type: $type) - No action");
    }
  }

  void updateType(TileType newType) {
    if (type != newType) {
      type = newType;
    }
  }

  void setValueAndType(int newValue, TileType newType) {
    value = newValue;
    updateType(newType);
    _updatePaint();
  }

  Future<void> highlight({Duration duration = const Duration(milliseconds: 700), double nth = 1, Color? color }) async {
    int alpha = (255 ~/ (nth + 1)).clamp(30, 255);
    _paint = Paint()..color = color?.withAlpha(alpha) ?? highlight1Color.color.withAlpha(alpha);
    _borderPaint = Paint()
      ..color = defaultBorderColor.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    await Future.delayed(duration);
    _updatePaint();
  }
}