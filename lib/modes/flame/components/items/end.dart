import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:gru_minions/modes/flame/game.dart';

import '../player.dart';

class End extends SpriteAnimationComponent with HasGameRef<MainGame>, CollisionCallbacks {
  End({super.position, super.size});
  static const double stepTime = 0.05;
  bool reachedEnd = false;

  @override
  FutureOr<void> onLoad() {
    priority = -1;
    add(RectangleHitbox(
      position: Vector2(18, 25),
      size: Vector2(12, 8),
      collisionType: CollisionType.passive, //if the object is not moving, use passive
    ));

    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Items/Checkpoints/End/End (Idle).png'),
      SpriteAnimationData.sequenced(
        amount: 1,
        stepTime: 1,
        textureSize: Vector2.all(64),
      ),
    );
    return super.onLoad();
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    if(other is Player && !reachedEnd) _reachedEnd();
    super.onCollisionStart(intersectionPoints, other);
  }

  Future<void> _reachedEnd() async {
    reachedEnd = true;
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Items/Checkpoints/End/End (Pressed).png (64x64).png'),
      SpriteAnimationData.sequenced(
        amount: 8,
        stepTime: stepTime,
        textureSize: Vector2.all(64),
        loop: false,
      ),
    );
  }
}
