import 'package:flutter/material.dart';
import 'package:game2/logic/player.dart';

class PlayerScoreOverlay extends StatefulWidget {
  final Player player;
  final ValueNotifier<int> scoreNotifier;

  const PlayerScoreOverlay({
    super.key,
    required this.player,
    required this.scoreNotifier,
  });

  @override
  State<PlayerScoreOverlay> createState() => _PlayerScoreOverlayState();
}

class _PlayerScoreOverlayState extends State<PlayerScoreOverlay> {
  @override
  void initState() {
    super.initState();
    widget.scoreNotifier.addListener(_onScoreChanged);
  }

  @override
  void dispose() {
    widget.scoreNotifier.removeListener(_onScoreChanged);
    super.dispose();
  }

  void _onScoreChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 24,
      left: 24, // Changed to left: 24
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.star, // Keeping the star icon next to score
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Score: ${widget.player.score}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
