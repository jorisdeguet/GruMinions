import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../../game/pixel_adventure.dart';
import '../friend.dart';
import '../player.dart';

class Checkpoint extends SpriteAnimationComponent with HasGameRef<PixelAdventure>, CollisionCallbacks {
  Checkpoint({super.position, super.size});
  static const double stepTime = 0.05;
  bool reachedCheckpoint = false;

  @override
  FutureOr<void> onLoad() {
    priority = -1;
    add(RectangleHitbox(
      position: Vector2(18, 25),
      size: Vector2(12, 8),
      collisionType: CollisionType.passive, //if the object is not moving, use passive
    ));

    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Items/Checkpoints/Checkpoint/Checkpoint (No Flag).png'),
      SpriteAnimationData.sequenced(
        amount: 1,
        stepTime: 1,
        textureSize: Vector2.all(64),
      ),
    );
    return super.onLoad();
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player && !reachedCheckpoint) _reachedCheckpoint();
    if (other is Friend && !reachedCheckpoint) _reachedCheckpoint();
    super.onCollisionStart(intersectionPoints, other);
  }

  Future<void> _reachedCheckpoint() async {

    reachedCheckpoint = true;
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Items/Checkpoints/Checkpoint/Checkpoint (Flag Out) (64x64).png'),
      SpriteAnimationData.sequenced(
        amount: 26,
        stepTime: stepTime,
        textureSize: Vector2.all(64),
        loop: false,
      ),
    );

    await animationTicker?.completed;
    animationTicker?.reset();

    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Items/Checkpoints/Checkpoint/Checkpoint (Flag Idle) (64x64).png'),
      SpriteAnimationData.sequenced(
        amount: 10,
        stepTime: stepTime,
        textureSize: Vector2.all(64),
      ),
    );
  }
}
