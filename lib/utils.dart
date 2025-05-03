import 'package:game2/cell_state.dart';

bool isValidMove(int index, List<CellState> cells) {
  if (index < 0 || index >= cells.length) {
    return false;
  }

  if (cells[index].value != 0) {
    return false;
  }

  int rowLength = 10;
  List<int> adjacentIndices = [
    if (index % rowLength != 0) index - 1,
    if (index % rowLength != rowLength - 1) index + 1,
    if (index - rowLength >= 0) index - rowLength, 
    if (index + rowLength < cells.length) index + rowLength, 
  ];
  for (int adjacentIndex in adjacentIndices) {
    if (cells[adjacentIndex].value != 0) {
      return true;
    }
  }
  return false;
}
List<List<int>> sequencesOfSum(int targetSum, int index, int rowLength, List<CellState> cells) {
  List<List<int>> result = [];
  // Use a standard Set, HashSet might offer marginal performance benefits
  // depending on usage patterns, but Set is fine.
  Set<int> visitedInPath = <int>{};
  List<int> currentPath = [];

  void dfs(int currentSumNeeded, int currentIndex) {
    // --- Boundary and Invalid State Checks ---
    if (currentIndex < 0 || currentIndex >= cells.length) {
      return; // Out of bounds
    }
    if (visitedInPath.contains(currentIndex)) {
      return; // Already visited in this specific path exploration (cycle prevention)
    }
    int currentValue = cells[currentIndex].value;
    if (currentValue == 0) {
       return; // Cannot traverse through or end on a 0-value cell (assumption)
    }
    if (currentValue > currentSumNeeded) {
      return; // Current cell value alone exceeds the remaining needed sum
    }

    // --- Mark current node as visited for this path ---
    visitedInPath.add(currentIndex);
    currentPath.add(currentIndex);

    // --- Check for Solution ---
    if (currentValue == currentSumNeeded) {
      // Found a valid sequence ending at this node
      result.add(List.from(currentPath)); // Add a copy
      // We stop exploring further from this node as the sum is met
    } else {
      // --- Explore Neighbors ---
      int nextSumNeeded = currentSumNeeded - currentValue;

      // Calculate neighbors (only if we need to continue exploring)
       List<int> neighbors = [];
       // Left
       if (currentIndex % rowLength != 0) neighbors.add(currentIndex - 1);
       // Right
       if (currentIndex % rowLength != rowLength - 1) neighbors.add(currentIndex + 1);
       // Up
       if (currentIndex - rowLength >= 0) neighbors.add(currentIndex - rowLength);
       // Down
       if (currentIndex + rowLength < cells.length) neighbors.add(currentIndex + rowLength);


      for (int neighbor in neighbors) {
        // Check neighbor validity *before* recursive call (optional optimization)
        // if (neighbor >= 0 && neighbor < cells.length && cells[neighbor] != 0 && !visitedInPath.contains(neighbor)) {
             dfs(nextSumNeeded, neighbor);
        // }
        // Note: The checks at the start of dfs handle these conditions anyway.
      }
    }

    // --- Backtrack ---
    // Crucial: Un-mark the current node when returning from recursion
    // to allow other paths to potentially use it.
    visitedInPath.remove(currentIndex);
    currentPath.removeLast();
  }

  // Initial check: Can the starting cell even participate?
  if (index >= 0 && index < cells.length && cells[index].value > 0 && cells[index].value <= targetSum) {
     dfs(targetSum, index);
  } else if (index >= 0 && index < cells.length && cells[index].value == targetSum && targetSum == 0) {
     // Handle edge case if targetSum is 0 and start cell is 0, if needed.
     // Based on the code, 0s are blockers, so likely nothing.
     // If targetSum can be 0 and cells[index] can be 0, define behavior.
     // Current logic assumes targetSum > 0 or cells[index] > 0.
  } else if (index >= 0 && index < cells.length && cells[index].value  == targetSum && targetSum > 0) {
      // If the start node itself is the target sum
      result.add([index]);
  }


  return result;
}