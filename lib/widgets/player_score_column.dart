import 'package:flutter/material.dart';
import 'package:game2/logic/player.dart';

class PlayerScoreColumn extends StatelessWidget {
  final List<Player> players;
  const PlayerScoreColumn({super.key, required this.players});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final player in players)
          PlayerScoreRow(player: player),
      ],
    );
  }
}

class PlayerScoreRow extends StatelessWidget {
  final Player player;
  const PlayerScoreRow({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star, color: Colors.amber, size: 20),
          const SizedBox(width: 8),
          Text(
            player.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Score: ${player.score} / ${player.remainingPoints}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
