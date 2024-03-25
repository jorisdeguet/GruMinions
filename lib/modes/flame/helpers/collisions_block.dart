import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';


class CollisionBlock extends PositionComponent with CollisionCallbacks {
  CollisionBlock({super.position, super.size, this.isPlatform = false});
  bool isPlatform;

  @override
  FutureOr<void> onLoad() {
    // TODO: implement onLoad
    return super.onLoad();
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    // TODO: implement onCollisionStart
    super.onCollisionStart(intersectionPoints, other);
  }
}