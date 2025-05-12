class Player {
  String name;
  int score;
  int remainingPoints;

  Player({required this.name, this.score = 0, this.remainingPoints = 100});

  bool makeMove(int points) {
    if (remainingPoints >= points) {
      remainingPoints -= points;
      return true; 
    } else {
      return false;
    }
  }

  void updateScore(int points) {
    score += points;
  }

  @override
  String toString() {
    return 'Player{name: $name, score: $score, remainingPoints: $remainingPoints}';
  }
}