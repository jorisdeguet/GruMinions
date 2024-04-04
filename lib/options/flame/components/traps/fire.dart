import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../../game/pixel_adventure.dart';
import '../player.dart';

enum FireState { off, on }
class Fire extends SpriteAnimationGroupComponent with HasGameRef<PixelAdventure>, CollisionCallbacks {
  Fire({this.offNeg = 0, this.offPos = 0,  this.isFacingUp = false, super.position, super.size});

  //Final variables
  final double offNeg;
  final double offPos;
  final bool isFacingUp;

  //Animations
  late final SpriteAnimation _offAnimation;
  late final SpriteAnimation _onAnimation;

  //Constants
  static const double stepTime = 0.1;
  static const tileSize = 16;

  //Late variables
  late Player player;
  late double _playerOffset;
  late double _rangeNeg;
  late double _rangePos;

  @override
  FutureOr<void> onLoad() {
    player = game.player1;
    priority = -1;
    add(RectangleHitbox(
      position: Vector2(8, 0),
      size: Vector2(16, 32),
      anchor: Anchor.topCenter,
    ));

    if(isFacingUp){
      flipVerticallyAroundCenter();
    }

    _loadAllAnimations();
    _calculateRange();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updateState(dt);
    super.update(dt);
  }

  void _loadAllAnimations() {
    _offAnimation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Traps/Fire/Off.png'),
      SpriteAnimationData.sequenced(
        amount: 1,
        stepTime: stepTime,
        textureSize: Vector2(16,32),
      ),
    );
    _onAnimation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Traps/Fire/On (16x32).png'),
      SpriteAnimationData.sequenced(
        amount: 3,
        stepTime: stepTime,
        textureSize: Vector2(16,32),
      ),
    );

    animations = {
      FireState.off: _offAnimation,
      FireState.on: _onAnimation,
    };

    current = FireState.off;
  }

  void _calculateRange() {
    //Calculate the range vision of the enemy
    _rangeNeg = position.x - offNeg * tileSize; //left range
    _rangePos = position.x + offPos * tileSize; //right range
  }

  bool playerInRange() {
    _playerOffset = (player.scale.x > 0) ? 0 : -player.width;

    return
      //true if player is in the left range
      player.x + _playerOffset >= _rangeNeg &&
          //true if player is in the right range
          player.x + _playerOffset <= _rangePos &&
          //true if the bottom of player is below the fire's top
           player.y < position.y + height;
  }

  void _updateState(double dt) {
    if (playerInRange()) {
      current = FireState.on;
    }
    else {
      current = FireState.off;
    }
  }
}
