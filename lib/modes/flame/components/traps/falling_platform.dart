import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:gru_minions/modes/flame/game.dart';

class FallingPlatform extends SpriteAnimationComponent with HasGameRef<MainGame>, CollisionCallbacks {
  FallingPlatform({this.offNeg = 0, super.position, super.size});
  final double offNeg;
  static const double flySpeed = 0.1;
  static const moveSpeed = 50;
  static const tileSize = 16;
  bool isActivated = false;
  double rangeNeg = 0;
  double rangePos = 0;
  double moveDirection = 1;

  @override
  FutureOr<void> onLoad() {
    priority = -1;
    add(RectangleHitbox(
      position: Vector2(4, 6),
      size: Vector2(32, 10),
    ));

    if(isActivated) {
      rangeNeg = position.y - offNeg * tileSize;
    } else {
      rangeNeg = position.x - offNeg * tileSize;
    }

    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Traps/Falling Platforms/On (32x10).png'),
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: flySpeed,
        textureSize: Vector2(32,10),
      ),
    );
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if(isActivated) {
      _fall(dt);
    }
    super.update(dt);
  }

  void _fall(double dt) {
    position.y += moveDirection * moveSpeed * dt;
  }
}
