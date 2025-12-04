import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/flame.dart'; // Needed for Flame.images.load
import 'package:pixel_adventure/pixel_adventure.dart';

enum PlayerState { idle, running }

class Player
    extends
        SpriteAnimationGroupComponent<PlayerState> // 1. Added Generic Type
    with HasGameReference<PixelAdventure> {
  // Maintained variables
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runAnimation;
  final double stepTime = 0.05;

  // 2. Set initial state in the constructor
  Player() : super(current: PlayerState.idle);

  @override
  FutureOr<void> onLoad() async {
    // 3. Added 'async'
    // Load animations and assign them to the maintained fields
    await _loadAllAnimations();

    // Set the component size (Essential for rendering)
    size = Vector2.all(32);

    return super.onLoad();
  }

  // Maintained function name and logic, but made it asynchronous
  Future<void> _loadAllAnimations() async {
    // 4. Use await Flame.images.load for safe asynchronous asset loading
    final idleSpriteSheet = await Flame.images.load(
      'Main characters/Ninja Frog/Idle (32x32).png',
    );

    idleAnimation = SpriteAnimation.fromFrameData(
      idleSpriteSheet, // Use the loaded image
      SpriteAnimationData.sequenced(
        amount: 11,
        stepTime: stepTime,
        textureSize: Vector2.all(32),
      ),
    );

    // list of animations - maintained the original logic
    animations = {PlayerState.idle: idleAnimation};
    current = PlayerState.idle;
    // The current animation is already set in the constructor (PlayerState.idle)
    // No need to set it again here.
  }
}
