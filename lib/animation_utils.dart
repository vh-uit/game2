import 'dart:async';
import 'package:flutter/material.dart';
import 'cell_state.dart';
Future<void> highlightSequencesStepByStep(
  List<CellState> cells,
  List<List<int>> sequences,
  Duration duration,
  VoidCallback triggerSetState,
) async {
  if (sequences.isEmpty) {
    return;
  }

  int maxSequenceLength = 0;
  for (var sequence in sequences) {
    if (sequence.length > maxSequenceLength) {
      maxSequenceLength = sequence.length;
    }
  }

  if (maxSequenceLength == 0) {
    return;
  }

 
  final Duration stepDuration = Duration(
    milliseconds: 700,
  );

  for (int step = 0; step < maxSequenceLength; step++) {
    await Future.delayed(stepDuration*2, () {});
    for (var sequence in sequences) {
      if (step < sequence.length) {
        final int currentIndex = sequence[step];
        print("Highlighting index: $currentIndex");
        
        cells[currentIndex].isHighlighted = true;
        Future.delayed(stepDuration, () {
          print("Removing highlight from index: $currentIndex");
          cells[currentIndex].isHighlighted = false;
        });
      }
    }
  }
}
