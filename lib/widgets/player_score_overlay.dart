import 'package:flutter/material.dart';
import 'package:game2/logic/player.dart';
import 'player_score_column.dart';

class PlayerScoreOverlay extends StatelessWidget {
  final List<Player> players;

  const PlayerScoreOverlay({
    super.key,
    required this.players,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 24,
      left: 24,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(16),
        ),
        child: PlayerScoreColumn(players: players),
      ),
    );
  }
}
