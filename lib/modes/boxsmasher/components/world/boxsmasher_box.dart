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
}