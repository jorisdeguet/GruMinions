import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import '../../game/pixel_adventure.dart';
import '../friend.dart';
import '../player.dart';

class End extends SpriteAnimationComponent with HasGameRef<PixelAdventure>, CollisionCallbacks {
  End({super.position, super.size});

  //Constant variables
  static const double stepTime = 0.05;
  static const double specialStepTime = 0.1;

  //Defined variables
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
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player && !reachedEnd) _reachedEnd();
    if (other is Friend && !reachedEnd) _reachedEnd();
    super.onCollisionStart(intersectionPoints, other);
  }

  Future<void> _reachedEnd() async {
    reachedEnd = true;
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Items/Checkpoints/End/End (Pressed) (64x64).png'),
      SpriteAnimationData.sequenced(
        amount: 8,
        stepTime: specialStepTime,
        textureSize: Vector2.all(64),
      ),
    );
    await animationTicker?.completed;
  }
}
