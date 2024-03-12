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
    final points = intersectionPoints;
    final otherBoxPoint = other.topLeftPosition;

    if (other is Ground){
      onGround = true;
    }
    if (other is Box){
      for (var element in points) {
        verifyCollision(element, otherBoxPoint);
      }
    }
  }

  void verifyCollision(Vector2 point, Vector2 otherBoxPoint){
    if (point.y == otherBoxPoint.y){
      onBox = true;
    }
  }

  @override
  void onCollisionEnd(other){
    super.onCollisionEnd(other);

    if (other is Ground){
      onGround = false;
    }
    if (other is Box){
      onBox = false;
    }
  }

  @override
  void update(double delta) {
    super.update(delta);
    buttonPressed(onPressed);
  }

  void buttonPressed(bool pressed){
    if(onBox == true && onGround == false && pressed){
      return;
    }

    if (onGround && pressed){
      removeFromParent();
    }
  }
}