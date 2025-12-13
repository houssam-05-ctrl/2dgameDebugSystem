import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure/components/player.dart';
import 'package:pixel_adventure/components/level.dart';

class PixelAdventure extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  @override
  Color backgroundColor() => const Color(0xFF211F30);
  late final CameraComponent cam;
  late final Player player = Player(character: 'Mask Dude');
  late JoystickComponent joystick;
  bool showJoystick = true;

  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages();
    final world = Level(
      levelName: 'Level-01',
      player: player,
    );
    await world.onLoad();
    cam = CameraComponent.withFixedResolution(
      world: world,
      width: 640,
      height: 360,
    );
    cam.viewfinder.anchor = Anchor.topLeft;
    addAll([cam, world]); // adding the level to the game
    if (showJoystick) {
      addJoystick();
    }
  }

  @override
  void update(double dt) {
    if (showJoystick) {
      updateJoystick();
    }
    super.update(dt);
  }

  void addJoystick() {
    joystick = JoystickComponent(
      knob: CircleComponent(radius: 20, paint: Paint()..color = Colors.blue),
      background:
          CircleComponent(radius: 50, paint: Paint()..color = Colors.blueGrey),
      margin: const EdgeInsets.only(left: 40, bottom: 40),
    );
    add(joystick);
  }

  void updateJoystick() {
    if (kDebugMode) {
      print('=== JOYSTICK UPDATE ===');
      print('Direction: ${joystick.direction}');
      print('Delta: ${joystick.delta}');
      print('Relative Delta X: ${joystick.relativeDelta.x}');
    }

    // Utilise la valeur X du joystick directement (plus précis)
    double joystickValue = joystick.relativeDelta.x;

    if (joystickValue.abs() > 0.1) {
      // Joystick déplacé
      player.horizontalMovement = joystickValue;

      if (kDebugMode) {
        print('Joystick active! Value: $joystickValue');
      }

      // Saut si on tire vers le haut assez fort
      if (joystick.relativeDelta.y < -0.7 && player.isOnGround) {
        player.velocity.y = -player.jumpForce;
        player.isOnGround = false;
        if (kDebugMode) print('JUMP from joystick!');
      }
    } else {
      // Joystick au centre
      player.horizontalMovement = 0;
      if (kDebugMode) print('Joystick idle');
    }
  }
}

/*

// Color constants with proper opacity
si on veut ajouter un joystick plus stylé avec effet 3d mais no need ...



  static const _joystickKnobColorLight = Color(0xFF4FC3F7);
  static const _joystickKnobColorDark = Color(0xFF0277BD);
  static const _joystickBgColorInner = Color(0xCC5D7B8C); // 80% opacity
  static const _joystickBgColorOuter = Color(0x665D7B8C); // 40% opacity

  static const _joystickKnobRadius = 20.0;
  static const _joystickBackgroundRadius = 50.0;
  static const _joystickMargin = EdgeInsets.only(left: 40, bottom: 40);
  static const _joystickDeadzone = 0.1;

  void addJoystick() {
    joystick = JoystickComponent(
      knob: CircleComponent(
          radius: _joystickKnobRadius, paint: _createKnobPaint()),
      background: CircleComponent(
          radius: _joystickBackgroundRadius, paint: _createBackgroundPaint()),
      margin: _joystickMargin,
      priority: 2,
    );

    add(joystick);
  }

  Paint _createKnobPaint() {
    return Paint()
      ..shader = const RadialGradient(
        colors: [_joystickKnobColorLight, _joystickKnobColorDark],
        stops: [0.0, 1.0],
      ).createShader(Rect.fromCircle(
        center: Offset.zero,
        radius: _joystickKnobRadius,
      ))
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.5);
  }

  Paint _createBackgroundPaint() {
    return Paint()
      ..shader = const RadialGradient(
        colors: [_joystickBgColorInner, _joystickBgColorOuter],
        stops: [0.0, 1.0],
      ).createShader(Rect.fromCircle(
        center: Offset.zero,
        radius: _joystickBackgroundRadius,
      ))
      ..style = PaintingStyle.fill;
  }

  void updateJoystick() {
    player.direction = joystick.delta.length2 < _joystickDeadzone
        ? PlayerDirection.none
        : joystick.direction.isHorizontal
            ? joystick.direction == JoystickDirection.left
                ? PlayerDirection.left
                : PlayerDirection.right
            : PlayerDirection.none;
  }
extension on JoystickDirection {
  bool get isHorizontal =>
      this == JoystickDirection.left || this == JoystickDirection.right;
}
*/
