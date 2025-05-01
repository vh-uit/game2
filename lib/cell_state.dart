class CellState {
  int value = 0; // The number displayed in the cell (0 for empty).
  bool isHighlighted = false; // Flag to indicate if the cell should be visually highlighted.

  CellState({required this.value, required this.isHighlighted});
}
