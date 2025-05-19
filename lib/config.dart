// lib/config.dart
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

const double cellSize = 50.0;
const double cellMargin = 2.0; // Margin between cells

// Colors for different tile states
final PaletteEntry claimedColor = BasicPalette.darkPink;
final PaletteEntry frontierColor = claimedColor.withAlpha(50);
final PaletteEntry emptyColor = BasicPalette.gray.withAlpha(50);
final PaletteEntry defaultBorderColor = BasicPalette.blue.withAlpha(50);
final PaletteEntry highlight1Color = BasicPalette.green.withAlpha(50);
final PaletteEntry highlight2Color = BasicPalette.red.withAlpha(50);
// Game specific constants
const gameBackgroundColor = Colors.black87;