import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:pixel_adventure/actors/player.dart';

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

    final spawnPointsLayer = level.tileMap.getLayer<ObjectGroup>('Spawnpoints');
    for (final spawnPoint in spawnPointsLayer!.objects) {
      switch (spawnPoint.class_) {
        case 'Player':
          final player = Player(
              character: 'Mask Dude',
              position: Vector2(spawnPoint.x, spawnPoint.y));
          add(player);
          break;
        default:
      }
    }
    return super.onLoad();
  }
}

/*
 final spawnPoint = level.tileMap
        .getLayer<ObjectGroup>(
            'Spawn Points')! // we need to specify the layer type
        .objects // to loop thru the objects and find the one we want
        .firstWhere((element) => element.name == 'Player Spawn');
    player.position = Vector2(spawnPoint.x, spawnPoint.y);
    add(player);

    thats also a good way to do add a player in spwn place but the problenm is the scale if we have multiple spawn points.
    */
