import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:gru_minions/modes/flame/game.dart';
import '../custom_hitbox.dart';

enum BoxState { idle, hit, broken }
class Box extends SpriteAnimationGroupComponent with HasGameRef<MainGame>, CollisionCallbacks {
  Box({this.boxType = 'Box1', super.position, super.size});

  final String boxType;
  bool hit = false;
  final double stepTime = 0.05;
  final hitBox = CustomHitBox(offsetX: 4, offsetY: 4, width: 24, height: 24);

  late final SpriteAnimation _idleAnimation;
  late final SpriteAnimation _hitAnimation;
  late final SpriteAnimation _brokenAnimation;

  final _textureSize = Vector2(28, 24);

  @override
  FutureOr<void> onLoad() {
    priority = -1;
    add(RectangleHitbox(
      position: Vector2(hitBox.offsetX, hitBox.offsetY),
      size: Vector2(hitBox.width, hitBox.height),
    ));

    _loadAnimation();
    return super.onLoad();
  }

  void _loadAnimation() {
    _idleAnimation = _spriteAnimation('Idle', 1);
    _hitAnimation = _specialSpriteAnimation('Hit', 3)..loop = false;
    _brokenAnimation = _spriteAnimation('Break', 4)..loop = false;

    animations = {
      BoxState.idle: _idleAnimation,
      BoxState.hit: _hitAnimation,
      BoxState.broken: _brokenAnimation,
    };

    current = BoxState.idle;
  }

  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Items/Boxes/$boxType/$state.png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: _textureSize,
      ),
    );
  }

  SpriteAnimation _specialSpriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Items/Boxes/$boxType/$state (28x24).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: _textureSize,
      ),
    );
  }

  Future<void> collidedWithPlayer() async {
    if(!hit){
      hit = true;

      //if(game.playSounds) FlameAudio.play('block.wav', volume: game.soundVolume);
      current = BoxState.hit;
      await animationTicker?.completed;
      animationTicker?.reset();

      current = BoxState.broken;
      await animationTicker?.completed;
      removeFromParent();
    }
  }
}
