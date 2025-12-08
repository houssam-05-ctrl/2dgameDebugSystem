import 'dart:async';
import 'package:flame/components.dart';
import 'package:pixel_adventure/components/collision_block.dart';
import 'package:pixel_adventure/components/utils.dart';
import 'package:pixel_adventure/pixel_adventure.dart';
import 'package:flutter/services.dart';

enum PlayerState { idle, running }

class Player extends SpriteAnimationGroupComponent<PlayerState>
    with HasGameReference<PixelAdventure>, KeyboardHandler {
  String character;
  Player({super.position, this.character = 'Mask Dude'});

  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runAnimation;
  final double stepTime = 0.05;
  List<CollisionBlock> collisionsBlocks = [];
  double horizontalMovement = 0;
  double moveSpeed = 100; // pixels per second
  Vector2 velocity = Vector2.zero();

  @override
  FutureOr<void> onLoad() async {
    await _loadAllAnimations();
    debugMode = true;
    // Set the current animation state to idle initially
    current = PlayerState.idle;
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updatePlayerState();
    _checkHorizontalCollisions();
    _updatePlayerMovement(dt);
    super.update(dt);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalMovement = 0;
    final isLeftKeyPressed =
        keysPressed.contains(LogicalKeyboardKey.arrowLeft) ||
            keysPressed.contains(LogicalKeyboardKey.keyA);
    final isRightKeyPressed =
        keysPressed.contains(LogicalKeyboardKey.arrowRight) ||
            keysPressed.contains(LogicalKeyboardKey.keyD);

    horizontalMovement += isLeftKeyPressed ? -1 : 0;
    horizontalMovement += isRightKeyPressed ? 1 : 0;
    // We are handling the key event, so return true.
    return true;
  }

  Future<void> _loadAllAnimations() async {
    idleAnimation = _spriteAnimation('Idle', 11);
    runAnimation = _spriteAnimation('Run', 12);

    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runAnimation
    };
  }

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

  void _updatePlayerState() {
    PlayerState playerState = PlayerState.idle;

    if (velocity.x < 0 && scale.x > 0) {
      flipHorizontallyAroundCenter();
    } else if (velocity.x > 0 && scale.x < 0) {
      flipHorizontallyAroundCenter();
    }
    // to check if the player is moving and set running
    if (velocity.x > 0 || velocity.x < 0) playerState = PlayerState.running;
    current = playerState;
  }

  void _updatePlayerMovement(double dt) {
    velocity.x = horizontalMovement * moveSpeed;
    position.x += velocity.x * dt;
  }

  void _checkHorizontalCollisions() {
    for (final block in collisionsBlocks) {
      if (!block.isPlatform) {
        if (checkCollision(this, block)) {
          // a voir
          if (velocity.x > 0) {}
        }
      }
    }
  }
}
