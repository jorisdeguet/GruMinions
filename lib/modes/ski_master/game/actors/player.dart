import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/widgets.dart';
import '../../helpers/skimaster_direction.dart';
import '../game.dart';
import '../routes/gameplay.dart';

class Player extends PositionComponent
    with HasGameReference<SkiMasterGame>, HasAncestor<Gameplay>, HasTimeScale {
  Player({super.position, super.priority, required Sprite sprite})
      : _body = SpriteComponent(sprite: sprite, anchor: Anchor.center);

  final SpriteComponent _body;
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

  bool hasShield = false;
  SpriteComponent? skillSprite;

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

  void useSkill(String itemName) {
    switch (itemName) {
      case 'Shield':
        activateShield();
        break;
      case 'Speed':
        consumeSpeedBoost();
        break;
      case 'Bullet':
        startShooting();
        break;
    }
    ancestor.hud.consumeItem();
  }

  void resetTo(Vector2 resetPosition) {
    position.setFrom(resetPosition);
    speed = 0;
  }

  double jump() {
    if (game.sfxValueNotifier.value) {
      FlameAudio.play(SkiMasterGame.boostSfx);
    }
    final jumpFactor = speed / _maxSpeed;
    if (speed < _maxSpeed + 40) {
      speed = lerpDouble(speed, _maxSpeed * 1.3, 2)!;
    }
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

  void activateShield() {
    if (!hasShield) {
      hasShield = true;
      if (skillSprite == null) {
        skillSprite = SpriteComponent(
            sprite: ancestor.hud.itemSpriteCache['Shield'],
            size: _body.size,
            anchor: Anchor.center,
            position: Vector2.zero());
        add(skillSprite!);
        if (game.sfxValueNotifier.value) {
          FlameAudio.play(SkiMasterGame.shieldSfx);
        }
      }
    }
  }

  void deactivateShield() {
    hasShield = false;
    if (skillSprite != null) {
      skillSprite?.removeFromParent();
      skillSprite = null;
    }
  }

  void consumeSpeedBoost() {
    if (game.sfxValueNotifier.value) {
      FlameAudio.play(SkiMasterGame.speedSfx);
    }
    speed *= 1.5;
  }

  void startShooting() {
    if (!ancestor.bulletSpawner.timer.isRunning()) {
      ancestor.bulletSpawner.timer.start();
      Future.delayed(const Duration(seconds: 5), () {
        ancestor.bulletSpawner.timer.stop();
      });
    }
  }
}
