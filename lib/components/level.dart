import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/foundation.dart';
import 'package:pixel_adventure/components/collision_block.dart';
import 'package:pixel_adventure/components/player.dart';

class Level extends World {
  final String levelName;
  final Player player;

  Level({required this.levelName, required this.player});

  late TiledComponent level;
  List<CollisionBlock> collisionsBlocks = [];

  @override
  FutureOr<void> onLoad() async {
    // Charge la carte Tiled
    level = await TiledComponent.load(
      '$levelName.tmx',
      Vector2.all(16),
    );

    // Debug : affiche les couches disponibles
    if (kDebugMode) {
      print('=== DEBUG: Layers in $levelName.tmx ===');
      for (final layer in level.tileMap.map.layers) {
        print('  ${layer.name} (${layer.runtimeType})');
      }
      print('====================================');
    }

    add(level);

    // appel de fonction
    _setupSpawnPoint();

    // appel de fonction de config de collisions
    _setupCollisions();

    return super.onLoad();
  }

  /// configure le spawn point
  void _setupSpawnPoint() {
    final spawnPointLayer = level.tileMap.getLayer<ObjectGroup>('Spawnpoint');

    if (spawnPointLayer != null) {
      if (kDebugMode) {
        print(
            'Found Spawnpoint layer with ${spawnPointLayer.objects.length} objects');
      }

      // Cherche l'objet "Player" dans les points de spawn
      bool playerAdded = false;
      for (final spawnpoint in spawnPointLayer.objects) {
        // Vérifie si cet objet est le joueur
        if (spawnpoint.class_ == 'Player' ||
            spawnpoint.name == 'Player' ||
            spawnpoint.type == 'Player') {
          // Positionne le joueur au point de spawn
          player.position = Vector2(spawnpoint.x, spawnpoint.y);
          add(player);
          playerAdded = true;

          if (kDebugMode) {
            print(
                'Player added at position (${spawnpoint.x}, ${spawnpoint.y})');
          }
          break;
        }
      }

      // Si pas de joueur trouvé, utilise une position par défaut
      if (!playerAdded) {
        _addDefaultPlayer();
      }
    } else {
      // Si pas de couche Spawnpoint, utilise une position par défaut
      if (kDebugMode) {
        print('Warning: Spawnpoint layer not found');
      }
      _addDefaultPlayer();
    }
  }

  /// Configure les blocs de collision depuis la carte Tiled.
  void _setupCollisions() {
    final collisionsLayer = level.tileMap.getLayer<ObjectGroup>('Collisions');

    if (collisionsLayer != null) {
      for (final collision in collisionsLayer.objects) {
        // Crée un bloc de collision selon son type
        CollisionBlock block;

        switch (collision.class_) {
          case 'Platform':
            // Plateforme traversable par le bas
            block = CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
              isPlatform: true,
            );
            break;
          default:
            // Bloc solide normal
            block = CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
              isPlatform: false,
            );
        }

        // Ajoute le bloc à la liste et au monde
        collisionsBlocks.add(block);
        add(block);
      }

      // Transfère la liste des collisions au joueur
      player.collisionsBlocks = collisionsBlocks;
    } else if (kDebugMode) {
      print('Warning: Collisions layer not found');
    }
  }

  /// Ajoute le joueur à une position par défaut.
  void _addDefaultPlayer() {
    player.position = Vector2(100, 100);
    add(player);

    if (kDebugMode) {
      print('Player added at default position (100, 100)');
    }
  }
}
