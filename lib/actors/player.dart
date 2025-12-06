import 'dart:async';

import 'package:flame/components.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

enum PlayerState { idle, running }

class Player
    extends SpriteAnimationGroupComponent<PlayerState> // 1. Added Generic Type
    with
        HasGameReference<PixelAdventure> {
  // 3. Moved character to a parameter in the constructor
  String character;
  Player({super.position, required this.character});
  // Maintained variables
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runAnimation;
  final double stepTime = 0.05;

  @override
  FutureOr<void> onLoad() async {
    await _loadAllAnimations();

    // to set the component size
    size = Vector2.all(32);
    position = Vector2(32, 32);

    return super.onLoad();
  }

  // Maintained function name and logic, but made it asynchronous
  Future<void> _loadAllAnimations() async {
    idleAnimation = _spriteAnimation('Idle', 11);
    runAnimation = _spriteAnimation('Run', 12);

    // liste de toutes les animations
    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runAnimation
    };
  }

// set our current state of the player
  PlayerState currentState = PlayerState.running;

  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache(
        'Main Characters/$character/$state (32x32).png',
      ), // Use the loaded image
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: Vector2.all(32),
      ),
    );
  }
}
