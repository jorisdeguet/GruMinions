import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/animation.dart';
import 'package:gru_minions/modes/boxsmasher/components/world/boxsmasher_door.dart';

import '../../boxsmasher_game.dart';

class Box extends SpriteComponent with CollisionCallbacks, HasGameRef<BoxSmasherGame>{

  Box({required size, required position})
      : super(size: size, position: position) {
  }

  bool onGround = false;
  bool onBox = false;
  bool onPressed = false;

  @override
  Future<void> onLoad() async {
    RectangleHitbox shape = RectangleHitbox();
    shape.collisionType = CollisionType.active;
    add(shape);
    await super.onLoad();
  }

  @override
  void onCollision(intersectionPoints, other){
    super.onCollision(intersectionPoints, other);
    if(other is Door){
      position = Vector2(106, 742);
    }
  }

  @override
  void onCollisionEnd(other){
    super.onCollisionEnd(other);

    if (other is Door){}
  }

  @override
  void update(double delta) {
    super.update(delta);
    buttonPressed(onPressed);
  }

  void buttonPressed(bool pressed){
    if (position.x > 768) {
      position.x = 106;
    }
    if (pressed){
      add(
        MoveEffect.by(Vector2(16, 0), EffectController(
          alternate: false,
          infinite: false,
          curve: Curves.ease,
          speed: 2.5,
        )),
      );
    }
  }
}