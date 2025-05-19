import 'package:flutter_test/flutter_test.dart';
import 'package:game2/logic/board.dart';
import 'dart:math';

void main() {
  group('Board turn-based claiming', () {
    test('Players take turns and tiles are assigned to correct player', () {
      final board = Board(playerNumber: 2);
      expect(board.currentPlayerIndex, 0);
      expect(board.currentPlayer.name, 'Player 1');

      // Player 1 claims the origin
      final result1 = board.claimFrontierTile(const Point(0, 0), 5);
      expect(result1['claimedTile'], const Point(0, 0));
      expect(board.getTileOwner(const Point(0, 0)), 0);
      expect(board.currentPlayerIndex, 1);
      expect(board.currentPlayer.name, 'Player 2');

      // Player 2 claims a new frontier
      final nextFrontier = board.frontier.firstWhere((p) => p != const Point(0, 0));
      final result2 = board.claimFrontierTile(nextFrontier, 7);
      expect(result2['claimedTile'], nextFrontier);
      expect(board.getTileOwner(nextFrontier), 1);
      expect(board.currentPlayerIndex, 0);
      expect(board.currentPlayer.name, 'Player 1');
    });
  });
}
