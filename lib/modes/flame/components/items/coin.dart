import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';

import '../../game/pixel_adventure.dart';

class Coin extends SpriteAnimationComponent with HasGameRef<PixelAdventure>, CollisionCallbacks{
  Coin({super.position, super.size});

  //Final variables
  final double _stepTime = 0.08;

  //Defined variables
  bool collected = false;

  @override
  FutureOr<void> onLoad() {
    priority = -1;

    add(RectangleHitbox(
      position: Vector2(1, 1),
      size: Vector2(16, 16),
    ));

    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Items/Coins/Coin (16x16).png'),
      SpriteAnimationData.sequenced(
        amount: 9,
        stepTime: _stepTime,
        textureSize: Vector2.all(16),
      ),
    );
    return super.onLoad();
  }

  Future<void> collidedWithPlayer() async {
    if(!collected){
      collected = true;
      game.score.value++;
      if(game.playSounds) FlameAudio.play('collect_fruit.wav', volume: game.soundVolume);

      animation = SpriteAnimation.fromFrameData(
        game.images.fromCache('Items/Fruits/Collected.png'),
        SpriteAnimationData.sequenced(
          amount: 6,
          stepTime: _stepTime,
          textureSize: Vector2.all(32),
          loop: false,
        ),
      );
      await animationTicker?.completed;
      removeFromParent();
    }
  }
}