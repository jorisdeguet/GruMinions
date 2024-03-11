import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../../boxsmasher_game.dart';
import 'boxsmasher_ground.dart';

class Box extends SpriteComponent with CollisionCallbacks, HasGameRef<BoxSmasherGame>{

  Box({required size, required position})
      : super(size: size, position: position) {
    debugMode = true;
  }

  bool onGround = false;

  @override
  Future<void> onLoad() async {
    add(RectangleHitbox());
    await super.onLoad();
  }

  @override
  void onCollision(intersectionPoints, other){
    super.onCollision(intersectionPoints, other);

    if (other is Ground){
      onGround = true;
    }
  }

  @override
  void onCollisionEnd(other){
    super.onCollisionEnd(other);

    if (other is Ground){
      onGround = false;
    }
  }
}