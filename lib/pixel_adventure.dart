import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure/levels/level.dart';
import 'package:pixel_adventure/actors/player.dart';

class PixelAdventure extends FlameGame {
  @override
  Color backgroundColor() => const Color(0xFF211F30); // sky blue color
  late final CameraComponent cam;
  @override
  final world = Level();
  final Player player = Player(character: 'Ninja Frog');
  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages();
    await world.onLoad();
    cam = CameraComponent.withFixedResolution(
      world: world,
      width: 640,
      height: 360,
    );
    cam.viewfinder.anchor = Anchor.topLeft;
    cam.viewfinder.position = Vector2.zero();
    addAll([cam, world]); // adding the level to the game
  }
}
