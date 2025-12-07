import 'dart:async';
import 'package:flame/components.dart';
import 'package:pixel_adventure/pixel_adventure.dart';
import 'package:flutter/services.dart';

enum PlayerState { idle, running }

enum PlayerDirection { left, right, none }

class Player extends SpriteAnimationGroupComponent<PlayerState>
    with HasGameReference<PixelAdventure>, KeyboardHandler {
  String character;
  Player({super.position, this.character = 'Mask Dude'});

  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runAnimation;
  final double stepTime = 0.05;

  PlayerDirection direction = PlayerDirection.none;
  double moveSpeed = 100; // pixels per second
  Vector2 velocity = Vector2.zero();

  bool isFacingRight = true; // the player commences facing right

  @override
  FutureOr<void> onLoad() async {
    await _loadAllAnimations();
    // Set the current animation state to idle initially
    current = PlayerState.idle;
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updatePlayerMovement(dt);
    super.update(dt);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final isLeftKeyPressed =
        keysPressed.contains(LogicalKeyboardKey.arrowLeft) ||
            keysPressed.contains(LogicalKeyboardKey.keyA);
    final isRightKeyPressed =
        keysPressed.contains(LogicalKeyboardKey.arrowRight) ||
            keysPressed.contains(LogicalKeyboardKey.keyD);

    if (isLeftKeyPressed && !isRightKeyPressed) {
      direction = PlayerDirection.left;
    } else if (isRightKeyPressed && !isLeftKeyPressed) {
      direction = PlayerDirection.right;
    } else {
      direction = PlayerDirection.none;
    }

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

  void _updatePlayerMovement(double dt) {
    double dirX = 0.0;

    switch (direction) {
      case PlayerDirection.left:
        if (isFacingRight) {
          flipHorizontally();
          isFacingRight = false;
        }
        current = PlayerState.running;
        dirX = -moveSpeed;
        break;
      case PlayerDirection.right:
        if (!isFacingRight) {
          flipHorizontally();
          isFacingRight = true;
        }
        current = PlayerState.running;
        dirX = moveSpeed;
        break;
      case PlayerDirection.none:
        current = PlayerState.idle;
        dirX = 0.0;
        break;
    }

    velocity = Vector2(dirX, 0.0);
    position += velocity * dt;
  }
}
