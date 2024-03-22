import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';

import 'package:flutter/widgets.dart';

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

  static const _maxSpeed = 80;
  static const _acceleration = 0.5;
  var _speed = 0.0;

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
      _moveDirection.x = ancestor.input.hAxis;
      _moveDirection.y = 1;
      _moveDirection.normalize();

      _speed = lerpDouble(_speed, _maxSpeed, _acceleration * dt)!;

      angle = _moveDirection.screenAngle() + pi;
      position.addScaled(_moveDirection, _speed * dt);
    }
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
