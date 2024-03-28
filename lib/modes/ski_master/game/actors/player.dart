import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/widgets.dart';
import '../../helpers/skimaster_direction.dart';
import '../game.dart';
import '../routes/gameplay.dart';

//PositionComponent derives from component class and represent game obj with transformation data
//to get reference to the root game objects in any of the downstream components we can add the HasGameRef
// this will expose the game. getter
//HasAncestor is similar to hasgameref mix in but isntead of looking for instance of gameplay upstream
//it looks for a component of given type and expose it as a getter called ancestor
//but unlike hasgame reference this can only be safley accsessed when the component is mounted to the component tree
class Player extends PositionComponent
    with HasGameReference<SkiMasterGame>, HasAncestor<Gameplay>, HasTimeScale {
  Player({super.position, super.priority, required Sprite sprite})
      : _body = SpriteComponent(sprite: sprite, anchor: Anchor.center);

  // finalSpriteComponent Can render sprite or ennemies lib/game/player.dart
  final SpriteComponent _body;
  //unit vector that represent the position in which the player is moving at any given point
  final _moveDirection = Vector2(0, 1);
  double leftDirection = 0.0;
  double rightDirection = 0.0;

  static const _maxSpeed = 80;
  static const _acceleration = 0.5;
  var speed = 0.0;

  final maxHAxis = 1.5;
  final sensitivity = 3;

  var hAxis = 0.0;
  bool active = false;

  Direction direction = Direction.none;

  @override
  FutureOr<void> onLoad() async {
    await add(_body);
    await add(
      CircleHitbox.relative(1, parentSize: _body.size, anchor: Anchor.center),
    );
  }

  @override
  void update(double dt) {
    if (!ancestor.hud.intervalCountdown.isRunning()) {
      double targetLeft = 0.0, targetRight = 0.0;
      // Set target speed based on direction
      switch (direction) {
        case Direction.left:
          targetRight = 0;
          targetLeft = maxHAxis;
          break;
        case Direction.right:
          targetLeft = 0;
          targetRight = maxHAxis;
          break;
        case Direction.none:
          targetLeft = 0;
          targetRight = 0;
          break;
        case Direction.up:
          break;
        case Direction.down:
          break;
      }

      leftDirection = lerpDouble(
        leftDirection,
        targetLeft,
        sensitivity * dt,
      )!;
      rightDirection = lerpDouble(
        rightDirection,
        targetRight,
        sensitivity * dt,
      )!;

      hAxis = rightDirection - leftDirection;

      _moveDirection.x = hAxis;
      _moveDirection.y = 1;
      _moveDirection.normalize();
      speed = lerpDouble(speed, _maxSpeed, _acceleration * dt)!;
      angle = _moveDirection.screenAngle() + pi;
      position.addScaled(_moveDirection, speed * dt);
    }
  }

  void resetTo(Vector2 resetPosition) {
    position.setFrom(resetPosition);
    speed *= 0.5;
  }

  double jump() {
    final jumpFactor = speed / _maxSpeed;
    speed = lerpDouble(speed, _maxSpeed * 1.2, 2)!;
    final jumpScale = lerpDouble(1, 1.2, jumpFactor)!;
    final jumpDuration = lerpDouble(0, 0.3, jumpFactor)!;

    _body.add(
      ScaleEffect.by(
        Vector2.all(jumpScale),
        EffectController(
          duration: jumpDuration,
          alternate: true,
          curve: Curves.easeInOut,
        ),
      ),
    );
    return jumpFactor;
  }
}
