  import 'package:flutter/material.dart';
  import 'package:game2/cell.dart';
  import 'package:game2/cell_state.dart';

  class Board extends StatelessWidget {
    const Board({super.key, required this.boardState, required this.selectedCellIndex, required this.onCellTap});

    final List<CellState> boardState;
    final int selectedCellIndex;
    final Function(int) onCellTap;

    @override
    Widget build(BuildContext context) {
      return GridView(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 10),
        children: List.generate(boardState.length, (index) {
          return Cell(content: boardState[index].value, isSelected: selectedCellIndex == index, isHighlighted: boardState[index].isHighlighted, onTap: () =>
            onCellTap(index)); // Use boardState[index] for onTap
        }),
      );
    }
  }