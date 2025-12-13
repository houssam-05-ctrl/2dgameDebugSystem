import 'dart:async';
import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';
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

  // Constantes
  final double stepTime = 0.05;
  final double _gravity = 500; // AUGMENTÉ
  final double _jumpForce = 460;
  final double _terminalVelocity = 300;

  List<CollisionBlock> collisionsBlocks = [];
  double horizontalMovement = 0;
  double moveSpeed = 100;
  Vector2 velocity = Vector2.zero();
  bool isOnGround = false;

  @override
  FutureOr<void> onLoad() async {
    await _loadAllAnimations();
    debugMode = true;
    current = PlayerState.idle;
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updatePlayerMovement(dt);
    _applyGravity(dt);
    _checkVerticalCollisions();
    _checkHorizontalCollisions();
    _updatePlayerState();
    super.update(dt);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    // Mouvement horizontal
    horizontalMovement = 0;
    final isLeftKeyPressed =
        keysPressed.contains(LogicalKeyboardKey.arrowLeft) ||
            keysPressed.contains(LogicalKeyboardKey.keyA);
    final isRightKeyPressed =
        keysPressed.contains(LogicalKeyboardKey.arrowRight) ||
            keysPressed.contains(LogicalKeyboardKey.keyD);

    horizontalMovement += isLeftKeyPressed ? -1 : 0;
    horizontalMovement += isRightKeyPressed ? 1 : 0;

    // jump only when the key is pressed and we are on the floor :
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.space &&
        isOnGround) {
      velocity.y = -_jumpForce;
      isOnGround = false;
    }

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
      game.images.fromCache('Main Characters/$character/$state (32x32).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: Vector2.all(32),
      ),
    );
  }

  void _updatePlayerState() {
    PlayerState playerState = PlayerState.idle;

    // Flip l'orientation
    if (velocity.x < 0 && scale.x > 0) {
      flipHorizontallyAroundCenter();
    } else if (velocity.x > 0 && scale.x < 0) {
      flipHorizontallyAroundCenter();
    }

    // Définit l'état (idle ou running)
    if (velocity.x.abs() > 0.1) {
      // Utilise abs() pour éviter les petites valeurs
      playerState = PlayerState.running;
    }

    current = playerState;
  }

  void _updatePlayerMovement(double dt) {
    velocity.x = horizontalMovement * moveSpeed;
    position.x += velocity.x * dt;
  }

  void _checkHorizontalCollisions() {
    for (final block in collisionsBlocks) {
      if (!block.isPlatform && checkCollision(this, block)) {
        if (velocity.x > 0) {
          // Vers la droite
          velocity.x = 0;
          position.x = block.position.x - size.x;
          break;
        }
        if (velocity.x < 0) {
          // Vers la gauche
          velocity.x = 0;
          position.x = block.position.x + block.size.x;
          break;
        }
      }
    }
  }

  void _checkVerticalCollisions() {
    isOnGround = false; // Réinitialise

    for (final block in collisionsBlocks) {
      if (checkCollision(this, block)) {
        if (velocity.y > 0) {
          // Tombe sur le bloc
          velocity.y = 0;
          position.y =
              block.position.y - size.y - 1.0; // -1 pour éviter oscillation
          isOnGround = true;
          break;
        }
        if (velocity.y < 0) {
          // Saute contre le plafond
          velocity.y = 0;
          position.y = block.position.y +
              block.size.y +
              1.0; // +1 pour éviter oscillation
          break;
        }
      }
    }
  }

  void _applyGravity(double dt) {
    velocity.y += _gravity;
    velocity.y = velocity.y.clamp(-_jumpForce, _terminalVelocity);
    position.y += velocity.y * dt;

    // Si on tombe (vitesse positive), on n'est plus au sol
    if (velocity.y > 0) {
      isOnGround = false;
    }
  }
}
