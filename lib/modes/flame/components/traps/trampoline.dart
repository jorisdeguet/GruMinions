import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:gru_minions/modes/flame/game.dart';

import '../player.dart';

enum TrampolineState { idle, jump }

class Trampoline extends SpriteAnimationGroupComponent with HasGameRef<MainGame>, CollisionCallbacks {
  Trampoline({super.position, super.size});

  //Final variables
  final _textureSize = Vector2(28, 28);

  //Animations
  late final SpriteAnimation _idleAnimation;
  late final SpriteAnimation _jumpAnimation;

  //Constants
  static const double _stepTime = 0.03;
  static const moveSpeed = 20;
  static const tileSize = 16;
  static const bounceHeight = 900.0;

  //Late variables
  late Player player;
  late double rangeNeg;
  late double rangePos;

  //Defined variables
  double moveDirection = 1;

  @override
  FutureOr<void> onLoad() {
    priority = -1;
    player = gameRef.player;
    add(RectangleHitbox(
      position: Vector2(4, 6),
      size: Vector2(24, 26),
    ));

    _loadAnimations();
    return super.onLoad();
  }

  void _loadAnimations() {
    _idleAnimation = _spriteAnimation('Idle', 1);
    _jumpAnimation = _specialSpriteAnimation('Jump', 8)..loop = false;

    animations = {
      TrampolineState.idle: _idleAnimation,
      TrampolineState.jump: _jumpAnimation,
    };

    current = TrampolineState.idle;
  }

  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Traps/Trampoline/$state.png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: _stepTime,
        textureSize: _textureSize,
      ),
    );
  }

  SpriteAnimation _specialSpriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Traps/Trampoline/$state (28x28).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: _stepTime,
        textureSize: _textureSize,
      ),
    );
  }

  Future<void> collideWithPlayer() async {
    //if (game.playSounds) FlameAudio.play('hit.wav', volume: game.soundVolume);
    current = TrampolineState.jump;
    player.velocity.y = -bounceHeight;
    await animationTicker?.completed;
    animationTicker?.reset();
    current = TrampolineState.idle;
  }
}
