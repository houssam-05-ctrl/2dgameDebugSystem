import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

class Level extends World {
  // create first components of the level here
  late TiledComponent level;

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load(
      'Level-01.tmx',
      Vector2.all(16),
    ); // creating without adding the level 1)
    add(level); // adding the level to the world 2)
    return super.onLoad();
  }
}
