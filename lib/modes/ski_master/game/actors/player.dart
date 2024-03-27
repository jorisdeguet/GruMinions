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
  double targetXSpeed = 0.0;

  static const _maxSpeed = 80;
  static const _acceleration = 0.5;
  var _speed = 0.0;

  final maxHAxis = 1.5;
  final sensitivity = 2;

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
      //print("Player update $direction");
      double targetLeft = 0.0, targetRight = 0.0;
      if (direction != Direction.none) {
        print("Player update direction is $direction");
        //return;
      }
      // Set target speed based on direction
      switch (direction!) {
        case Direction.left:
          targetLeft = maxHAxis;
          break;
        case Direction.right:
          targetRight = maxHAxis;
          break;
        case Direction.down:
          break;
        case Direction.up:
          break;
        case Direction.none:
          targetXSpeed = 0; // Stop horizontal movement
          break;
      }

      leftDirection = lerpDouble(leftDirection, targetLeft, sensitivity * dt) ??
          leftDirection;
      rightDirection =
          lerpDouble(rightDirection, targetRight, sensitivity * dt) ??
              rightDirection;

      hAxis = rightDirection - leftDirection;

      _moveDirection.x = hAxis;
      _moveDirection.y = 1;
      _moveDirection.normalize();
      _speed = lerpDouble(_speed, _maxSpeed, _acceleration * dt)!;
      angle = _moveDirection.screenAngle() + pi;
      position.addScaled(_moveDirection, _speed * dt);
    }
    super.update(dt);
  }

  void resetTo(Vector2 resetPosition) {
    position.setFrom(resetPosition);
    _speed *= 0.5;
  }

  double jump() {
    final jumpFactor = _speed / _maxSpeed;
    final jumpScale = lerpDouble(1, 1.2, jumpFactor)!;
    final jumpDuration = lerpDouble(0, 0.8, jumpFactor)!;
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
