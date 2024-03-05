import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:gru_minions/modes/flame/game.dart';

import '../custom_hitbox.dart';


class Fruit extends SpriteAnimationComponent with HasGameRef<MainGame>, CollisionCallbacks{
  Fruit({this.fruitType = 'Apple', position, size})
      : super(position: position, size: size);
  final String fruitType;
  bool collected = false;
  final double stepTime = 0.05;
  final hitbox = CustomHitbox(offsetX: 10, offsetY: 10, width: 12, height: 12);

  @override
  FutureOr<void> onLoad() {
    //debugMode = true;
    priority = -1;
    add(RectangleHitbox(
      position: Vector2(hitbox.offsetX, hitbox.offsetY),
      size: Vector2(hitbox.width, hitbox.height),
    ));
    animation = SpriteAnimation.fromFrameData(
        game.images.fromCache('Items/Fruits/$fruitType.png'),
        SpriteAnimationData.sequenced(
          amount: 17,
          stepTime: stepTime,
          textureSize: Vector2.all(32),
        ),
    );
    return super.onLoad();
  }

  Future<void> collidedWithPlayer() async {
    if(!collected){
      collected = true;
      //if(game.playSounds) FlameAudio.play('collect_fruit.wav', volume: game.soundVolume);

      animation = SpriteAnimation.fromFrameData(
        game.images.fromCache('Items/Fruits/Collected.png'),
        SpriteAnimationData.sequenced(
          amount: 6,
          stepTime: stepTime,
          textureSize: Vector2.all(32),
          loop: false,
        ),
      );
      await animationTicker?.completed;
      removeFromParent();
    }
  }
}