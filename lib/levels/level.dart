import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/foundation.dart';
import 'package:pixel_adventure/actors/player.dart';

class Level extends World {
  final String levelName;
  final Player player;
  Level({required this.levelName, required this.player});

  late TiledComponent level;

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load(
      '$levelName.tmx',
      Vector2.all(16),
    );

    if (kDebugMode) {
      print('=== DEBUG: Layers in $levelName.tmx ===');
      for (final layer in level.tileMap.map.layers) {
        print('  ${layer.name} (${layer.runtimeType})');
      }
      print('====================================');
    }

    add(level);

    // Try to get the Spawnpoint layer
    final spawnPointLayer = level.tileMap.getLayer<ObjectGroup>('Spawnpoint');

    if (spawnPointLayer != null) {
      if (kDebugMode) {
        print(
            'Found Spawnpoint layer with ${spawnPointLayer.objects.length} objects');
        for (final obj in spawnPointLayer.objects) {
          print(
              '  Object: name="${obj.name}", class="${obj.class_}", type="${obj.type}", '
              'position=(${obj.x}, ${obj.y}), size=(${obj.width}×${obj.height})');
        }
      }

      // Look for the Player object
      bool playerAdded = false;
      for (final spawnpoint in spawnPointLayer.objects) {
        if (kDebugMode) {
          print(
              'Checking object: ${spawnpoint.name} with class: ${spawnpoint.class_}');
        }

        // Check multiple possible properties where the class might be stored
        if (spawnpoint.class_ == 'Player' ||
            spawnpoint.name == 'Player' ||
            spawnpoint.type == 'Player') {
          player.position = Vector2(spawnpoint.x, spawnpoint.y);
          add(player);
          playerAdded = true;

          if (kDebugMode) {
            print(
                'Player added at position (${spawnpoint.x}, ${spawnpoint.y})');
          }
          break; // Found player, break out of loop
        }
      }

      if (!playerAdded) {
        if (kDebugMode) {
          print('Warning: No Player object found in Spawnpoint layer');
          print('Available objects in Spawnpoint layer:');
          for (final obj in spawnPointLayer.objects) {
            print(
                '  - Name: "${obj.name}", Class: "${obj.class_}", Type: "${obj.type}"');
          }
        }
        // Add player at default position
        addDefaultPlayer();
      }
    } else {
      if (kDebugMode) {
        print('Warning: Spawnpoint layer not found. Available layers:');
        for (final layer in level.tileMap.map.layers) {
          print('  - ${layer.name} (${layer.runtimeType})');
        }
      }
      // Add player at default position
      addDefaultPlayer();
    }

    return super.onLoad();
  }

  void addDefaultPlayer() {
    player.position = Vector2(100, 100);
    add(player);

    if (kDebugMode) {
      print('Player added at default position (100, 100)');
    }
  }
}
