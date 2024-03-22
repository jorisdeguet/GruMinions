import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:gru_minions/modes/ski_master/game/actors/player.dart';

import '../game.dart';
import '../routes/gameplay.dart';

class Avalanche extends PositionComponent
    with
        HasGameReference<SkiMasterGame>,
        HasAncestor<Gameplay>,
        HasTimeScale,
        CollisionCallbacks {
  Avalanche({super.position, super.priority});

  late final SpriteComponent _body;
  final _moveDirection = Vector2(0, 1);

  static const _maxSpeed = 80;

  @override
  FutureOr<void> onLoad() async {
    final sprite = await game.loadSprite('skimaster/avalanche.png');
    _body = SpriteComponent(
      sprite: sprite,
      anchor: Anchor.center,
    );
    await add(_body);
    await add(RectangleHitbox(
      size: _body.size,
      collisionType: CollisionType.passive,
      anchor: Anchor.center,
    )..debugMode = true);
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is Player) {
      _kill();
    }
  }

  void moveAvalanche(double dt) {
    position.addScaled(_moveDirection, _maxSpeed * dt);
  }

  void resetTo(Vector2 resetPosition) {
    position.y = resetPosition.y - _body.size.y * 3;
  }

  void _kill() {
    ancestor.resetPlayer();
  }
}
