import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../../game/pixel_adventure.dart';

class Start extends SpriteAnimationComponent with HasGameRef<PixelAdventure>, CollisionCallbacks {
  Start({super.position, super.size});
  static const double stepTime = 0.05;

  @override
  FutureOr<void> onLoad() {
    priority = -1;
    add(RectangleHitbox(
      position: Vector2(18, 25),
      size: Vector2(12, 8),
      collisionType: CollisionType.passive, //if the object is not moving, use passive
    ));

    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Items/Checkpoints/Start/Start (Idle).png'),
      SpriteAnimationData.sequenced(
        amount: 1,
        stepTime: 1,
        textureSize: Vector2.all(64),
      ),
    );
    return super.onLoad();
  }
}
