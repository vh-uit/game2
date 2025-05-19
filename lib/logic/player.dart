/// Represents a player in the game.
///
/// Stores the player's name, score, and remaining points, and provides methods for making moves and updating the score.
class Player {
  /// The name of the player.
  String name;

  /// The current score of the player.
  int score;

  /// The number of points the player can still spend.
  int remainingPoints;

  /// Creates a [Player] with the given [name], [score], and [remainingPoints].
  Player({required this.name, this.score = 0, this.remainingPoints = 100});

  /// Attempts to make a move by spending [points].
  ///
  /// Returns `true` if the move is successful, or `false` if not enough points remain.
  bool makeMove(int points) {
    if (remainingPoints >= points) {
      remainingPoints -= points;
      return true;
    } else {
      return false;
    }
  }

  /// Adds [points] to the player's score.
  void updateScore(int points) {
    score += points;
  }

  /// Calculates the score based on unique cells in chains.
  int calculateScoreFromChains(List<List<dynamic>> chains) {
    final uniqueCells = <dynamic>{};
    for (final chain in chains) {
      uniqueCells.addAll(chain);
    }
    final score = uniqueCells.length;
    return score;
  }

  @override
  String toString() {
    return 'Player{name: $name, score: $score, remainingPoints: $remainingPoints}';
  }
}
