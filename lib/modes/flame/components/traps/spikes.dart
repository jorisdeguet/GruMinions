import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:gru_minions/modes/flame/game.dart';


class Spikes extends SpriteAnimationComponent with HasGameRef<MainGame>, CollisionCallbacks {
  Spikes({ super.position, super.size});
  static const double stepTime = 0.1;

  @override
  FutureOr<void> onLoad() {
    priority = -1;
    add(RectangleHitbox(
      position: Vector2(4, 6),
      size: Vector2(16, 16),
    ));

    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Traps/Spikes/Idle.png'),
      SpriteAnimationData.sequenced(
        amount: 1,
        stepTime: stepTime,
        textureSize: Vector2(16,16),
      ),
    );
    return super.onLoad();
  }
}
