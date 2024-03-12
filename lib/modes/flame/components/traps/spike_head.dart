import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:gru_minions/modes/flame/game.dart';


enum SpikeHeadStates { idle, blink, bottomHit, topHit, leftHit, rightHit }

class SpikeHead extends SpriteAnimationGroupComponent with HasGameRef<MainGame>, CollisionCallbacks {
  SpikeHead({this.isVertical = false, this.isMoving = false, this.offNeg = 0, this.offPos = 0, super.position, super.size});

  //Final variables
  final bool isVertical;
  final bool isMoving;
  final double offNeg;
  final double offPos;
  final _textureSize = Vector2(54, 52);

  //Animations
  late final SpriteAnimation _idleAnimation;
  late final SpriteAnimation _blinkAnimation;
  late final SpriteAnimation _bottomHitAnimation;
  late final SpriteAnimation _topHitAnimation;
  late final SpriteAnimation _leftHitAnimation;
  late final SpriteAnimation _rightHitAnimation;

  //Constants
  static const double _spikeHeadSpeed = 0.03;
  static const moveSpeed = 20;
  static const tileSize = 16;

  //Late variables
  late double rangeNeg;
  late double rangePos;

  //Defined variables
  double moveDirection = 1;

  @override
  FutureOr<void> onLoad() {
    priority = -1;
    debugMode = true;
    add(RectangleHitbox(
      position: Vector2(4, 6),
      size: Vector2(24, 26),
    ));

    if(isVertical) {
      rangeNeg = position.y - offNeg * tileSize;
      rangePos = position.y + offPos * tileSize;
    } else {
      rangeNeg = position.x - offNeg * tileSize;
      rangePos = position.x + offPos * tileSize;
    }

    _loadAnimations();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if(isVertical && isMoving) {
      _moveVertically(dt);
    }
    else if (!isVertical && isMoving){
      _moveHorizontally(dt);
    }
    super.update(dt);
  }

  void _loadAnimations() {
    _idleAnimation = _spriteAnimation('Idle', 1);
    _blinkAnimation = _specialSpriteAnimation('Blink', 4);
    _bottomHitAnimation = _specialSpriteAnimation('Bottom Hit', 4)..loop = false;
    _topHitAnimation = _specialSpriteAnimation('Top Hit', 4)..loop = false;
    _leftHitAnimation = _specialSpriteAnimation('Left Hit', 4)..loop = false;
    _rightHitAnimation = _specialSpriteAnimation('Right Hit', 4)..loop = false;

    animations = {
      SpikeHeadStates.idle: _idleAnimation,
      SpikeHeadStates.blink: _blinkAnimation,
      SpikeHeadStates.bottomHit: _bottomHitAnimation,
      SpikeHeadStates.topHit: _topHitAnimation,
      SpikeHeadStates.leftHit: _leftHitAnimation,
      SpikeHeadStates.rightHit: _rightHitAnimation,
    };

    current = SpikeHeadStates.idle;
  }

  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Traps/Spike Head/$state.png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: _spikeHeadSpeed,
        textureSize: _textureSize,
      ),
    );
  }

  SpriteAnimation _specialSpriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Traps/Spike Head/$state (54x52).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: _spikeHeadSpeed,
        textureSize: _textureSize,
      ),
    );
  }

  void _moveVertically(double dt) {
    if (position.y >= rangePos) {
      moveDirection = -1;

    } else if (position.y <= rangeNeg) {
      moveDirection = 1;
    }
    position.y += moveDirection * moveSpeed * dt;
  }

  void _moveHorizontally(double dt) {
    if (position.x >= rangePos) {
      moveDirection = -1;
    } else if (position.x <= rangeNeg) {
      moveDirection = 1;
    }
    position.x += moveDirection * moveSpeed * dt;
  }
}
