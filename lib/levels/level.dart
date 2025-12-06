import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:pixel_adventure/actors/player.dart';

class Level extends World {
  // create first components of the level here
  late TiledComponent level;
  final Player player = Player(character: 'Ninja Frog');

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load(
      'Level-01.tmx',
      Vector2.all(16),
    ); // creating without adding the level 1)
    add(level); // adding the level to the world 2)
    add(player); // added the player to the level 3)
    return super.onLoad();
  }
}
