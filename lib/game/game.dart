import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:game2/game/inf_matrix_world.dart';

class InfinityNumberMatrixGame extends FlameGame {
  @override
  late final InfMatrixWorld world = InfMatrixWorld();

  @override
  Color backgroundColor() => const Color.fromARGB(255, 255, 249, 225);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await add(world);
  }

  void attemptClaimTile(int number) => world.attemptClaimTile(number);
}
