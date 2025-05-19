import 'dart:math';

import 'package:game2/logic/player.dart';

enum TileType {
  claimed,
  frontier,
  empty, // Represents a space not yet frontier or claimed
}

/// Represents the game board, including claimed tiles, frontier tiles, and player management.
///
/// Provides methods for claiming tiles, finding chains, and querying tile types.
class Board {
  final Map<Point<int>, int> _tiles = {};
  final Set<Point<int>> _frontier = {};
  late final List<Player> _players;
  int _currentPlayerIndex = 0;

  Board({int playerNumber = 1}) {
    // Start with one frontier tile at the origin
    _frontier.add(const Point(0, 0));
    _players = List.generate(
      playerNumber,
      (index) => Player(name: 'Player ${index + 1}'),
    );
  }

  /// Returns a list of direct orthogonal neighbors for a given tile coordinate.
  List<Point<int>> _getPotentialNeighbors(Point<int> tile) {
    final directions = [
      const Point(1, 0),
      const Point(-1, 0),
      const Point(0, 1),
      const Point(0, -1),
    ];
    List<Point<int>> neighbors = [];
    for (final dir in directions) {
      neighbors.add(Point(tile.x + dir.x, tile.y + dir.y));
    }
    return neighbors;
  }

  /// Claims a frontier tile, updates tiles and frontier sets,
  /// and returns a map with the new frontier and newly claimed tile positions.
  ///
  /// Returns a map with keys:
  ///   - 'addedFrontier': [Point<int>, ...], the new frontier tiles created
  ///   - 'claimedTile': Point<int>, the tile that was just claimed
  Map<String, dynamic> claimFrontierTile(Point<int> tileToClaim, int value) {
    print("Attempting to claim tile: $tileToClaim with value: $value");
    if (!_frontier.contains(tileToClaim)) {
      print("Error: Tile $tileToClaim is not a frontier tile.");
      return {'addedFrontier': <Point<int>>[], 'claimedTile': null};
    }

    _claimTile(tileToClaim, value);
    final newlyAddedFrontier = _addNewFrontier(tileToClaim);

    return {'addedFrontier': newlyAddedFrontier, 'claimedTile': tileToClaim};
  }

  /// Finds all chains (paths of adjacent claimed tiles) whose values sum to [targetSum].
  ///
  /// Returns a list of chains, where each chain is a list of [Point<int>].
  List<List<Point<int>>> findChainsWithSum(Point<int> start, int targetSum) {
    List<List<Point<int>>> result = [];
    Set<Point<int>> visited = {};

    _dfs(start, targetSum, [], 0, result, visited);
    return result;
  }

  void _dfs(
    Point<int> current,
    int targetSum,
    List<Point<int>> path,
    int currentSum,
    List<List<Point<int>>> result,
    Set<Point<int>> globalVisited,
  ) {
    // Avoid revisiting the same tile in the same path
    if (path.contains(current)) return;

    int value = _tiles[current]!;
    int newSum = currentSum + value;
    List<Point<int>> newPath = List.from(path)..add(current);

    if (newSum == targetSum) {
      result.add(newPath);
      // Do not return; allow for longer chains that also sum to targetSum
    }
    if (newSum > targetSum) return;

    for (final neighbor in _getPotentialNeighbors(current)) {
      if (_tiles.containsKey(neighbor) && !newPath.contains(neighbor)) {
        _dfs(neighbor, targetSum, newPath, newSum, result, globalVisited);
      }
    }
  }

  void _claimTile(Point<int> tile, int value) {
    _frontier.remove(tile);
    _tiles[tile] = value;
  }

  List<Point<int>> _addNewFrontier(Point<int> tile) {
    List<Point<int>> newlyAddedFrontier = [];
    for (final neighbor in _getPotentialNeighbors(tile)) {
      if (!_tiles.containsKey(neighbor) && !_frontier.contains(neighbor)) {
        _frontier.add(neighbor);
        newlyAddedFrontier.add(neighbor);
        print("New frontier added: $neighbor");
      }
    }
    return newlyAddedFrontier;
  }

  /// Gets all currently claimed tiles.
  List<Point<int>> get tiles => _tiles.keys.toList();

  /// Gets all current frontier tiles.
  List<Point<int>> get frontier => _frontier.toList();

  /// Determines the type of a tile at a given point.
  TileType getTileType(Point<int> point) {
    if (_tiles.containsKey(point)) {
      return TileType.claimed;
    } else if (_frontier.contains(point)) {
      return TileType.frontier;
    }
    return TileType.empty;
  }

  List<Player> get players => _players;
  Player get currentPlayer => _players[_currentPlayerIndex];
  int get currentPlayerIndex => _currentPlayerIndex;

  void nextPlayer() {
    _currentPlayerIndex = (_currentPlayerIndex + 1) % _players.length;
  }

  void reset() {
    _tiles.clear();
    _frontier.clear();
    _frontier.add(const Point(0, 0));
    _currentPlayerIndex = 0;
    for (final player in _players) {
      player.reset();
    }
  }
}
