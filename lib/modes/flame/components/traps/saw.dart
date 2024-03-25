import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../../game/pixel_adventure.dart';

class Saw extends SpriteAnimationComponent with HasGameRef<PixelAdventure> {
  Saw({this.offNeg = 0, this.offPos = 0, this.isVertical = false, super.position, super.size});

  //Final variables
  final bool isVertical;
  final double offNeg;
  final double offPos;

  //Constants
  static const double _sawSpeed = 0.03;
  static const moveSpeed = 50;
  static const tileSize = 16;

  //Late variables
  late double _rangeNeg;
  late double _rangePos;

  //Defined variables
  double moveDirection = 1;

  @override
  FutureOr<void> onLoad() {
    priority = -1;
    add(CircleHitbox());

    if(isVertical) {
      _rangeNeg = position.y - offNeg * tileSize;
      _rangePos = position.y + offPos * tileSize;
    } else {
      _rangeNeg = position.x - offNeg * tileSize;
      _rangePos = position.x + offPos * tileSize;
    }

    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Traps/Saw/On (38x38).png'),
      SpriteAnimationData.sequenced(
        amount: 8,
        stepTime: _sawSpeed,
        textureSize: Vector2.all(38),
      ),
    );
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if(isVertical) {
      _moveVertically(dt);
    }
    else {
      _moveHorizontally(dt);
    }
    super.update(dt);
  }

  void _moveVertically(double dt) {
    if (position.y >= _rangePos) {
      moveDirection = -1;
    } else if (position.y <= _rangeNeg) {
      moveDirection = 1;
    }
    position.y += moveDirection * moveSpeed * dt;
  }

  void _moveHorizontally(double dt) {
    if (position.x >= _rangePos) {
      moveDirection = -1;
    } else if (position.x <= _rangeNeg) {
      moveDirection = 1;
    }
    position.x += moveDirection * moveSpeed * dt;
  }
}
