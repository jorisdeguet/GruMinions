import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../../game/pixel_adventure.dart';

class Spikes extends SpriteAnimationComponent with HasGameRef<PixelAdventure>, CollisionCallbacks {
  Spikes({this.isFacingUp = false, super.position, super.size});

  //Final variables
  final bool isFacingUp;

  //Constants
  static const double stepTime = 0.1;

  @override
  FutureOr<void> onLoad() {
    priority = -1;

    add(RectangleHitbox(
      position: Vector2(4, 6),
      size: Vector2(16, 16),
    ));

    if(isFacingUp){
      flipVerticallyAroundCenter();
    }

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
