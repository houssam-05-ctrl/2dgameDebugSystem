import 'dart:async';
import 'package:flame/components.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

enum PlayerState { idle, running }

enum PlayerDirection { left, right, none }

class Player extends SpriteAnimationGroupComponent<PlayerState>
    with HasGameReference<PixelAdventure> {
  String character;
  Player({super.position, required this.character});

  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runAnimation;
  final double stepTime = 0.05;

  PlayerDirection direction = PlayerDirection.none;
  double moveSpeed = 100; // pixels per second
  Vector2 velocity = Vector2.zero();

  @override
  FutureOr<void> onLoad() async {
    // COMMENTED OUT: Don't override position here - use the constructor position
    // position = Vector2(32, 32);

    await _loadAllAnimations();

    // Set the current animation state
    current = PlayerState.running; // Changed from currentState

    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updatePlayerMovement(dt);
    super.update(dt);
  }

  Future<void> _loadAllAnimations() async {
    idleAnimation = _spriteAnimation('Idle', 11);
    runAnimation = _spriteAnimation('Run', 12);

    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runAnimation
    };
  }

  // REMOVED: PlayerState currentState = PlayerState.running; // Use "current" instead

  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache(
        'Main Characters/$character/$state (32x32).png',
      ),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: Vector2.all(32),
      ),
    );
  }

  void _updatePlayerMovement(double dt) {
    double dirX = 00;
    switch (direction) {
      case PlayerDirection.left:
        current = PlayerState.running;
        dirX -= moveSpeed;
        break;
      case PlayerDirection.right:
        current = PlayerState.running;
        dirX += moveSpeed;
        break;
      case PlayerDirection.none:
        dirX = 0;
        break;
    }
    velocity = Vector2(dirX, 0.0);
    position += velocity * dt;
  }
}
