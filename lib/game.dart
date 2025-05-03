import 'package:flutter/material.dart';
import 'board.dart';
import 'utils.dart';
import 'cell_state.dart';
import 'dart:async';
import "animation_utils.dart";

class GameState extends StatefulWidget {
  const GameState({super.key});

  @override
  State<GameState> createState() => _GameStateState();
}

class _GameStateState extends State<GameState> {
  int round = 0;
  List<CellState> cells = List.generate(100, (index) => CellState(value: 0, isHighlighted: false));
  int selectedCellIndex = -1;

  void _handleCellTap(int index) {
    setState(() {
      if (selectedCellIndex == index) {
        selectedCellIndex = -1;
      } else {
        selectedCellIndex = index;
      }
    });
  }

  void _placeNumber(int number) {
    if (selectedCellIndex != -1 && (round == 0 || isValidMove(selectedCellIndex, cells))) {
      List<List<int>> sequencesToHighlight = [];

      setState(() {
        cells[selectedCellIndex].value = number;
        print(round);
        round++;
        sequencesToHighlight = sequencesOfSum(12, selectedCellIndex, 10, cells);
      });
      highlightSequencesStepByStep(cells, sequencesToHighlight, Durations.short1, () {});

      Timer(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
             for (var sequence in sequencesToHighlight) {
               for (var index in sequence) {
                 if (index >= 0 && index < cells.length) {
                    cells[index].isHighlighted = false;
                 }
               }
             }
          });
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
           content: Text(selectedCellIndex == -1 ? 'Please select a cell first.' : 'Invalid move.'),
           duration: const Duration(seconds: 1),
         ),
       );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Game'),
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
      ),
      body: Board(
        boardState: cells,
        selectedCellIndex: selectedCellIndex,
        onCellTap: _handleCellTap,
      ),
      bottomNavigationBar: selectedCellIndex != -1
        ? BottomAppBar(
            color: Colors.teal.shade100,
            child: SizedBox(
              height: 80.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 12,
                itemBuilder: (context, index) {
                  final number = index + 1;
                  return GestureDetector(
                    onTap: () => _placeNumber(number),
                    child: Container(
                      width: 60,
                      margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                           BoxShadow(
                             color: Colors.grey.withValues(alpha: .5),
                             spreadRadius: 1,
                             blurRadius: 3,
                             offset: const Offset(0, 2),
                           ),
                        ]
                      ),
                      child: Center(
                        child: Text(
                          '$number',
                          style: const TextStyle(
                              color: Colors.teal,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          )
        : null,
    );
  }
}
