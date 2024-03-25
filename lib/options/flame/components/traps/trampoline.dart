import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';

import '../../game/pixel_adventure.dart';
import '../player.dart';

enum TrampolineState { idle, jump }

class Trampoline extends SpriteAnimationGroupComponent with HasGameRef<PixelAdventure>, CollisionCallbacks {
  Trampoline({super.position, super.size});

  //Final variables
  final _textureSize = Vector2.all(28);

  //Animations
  late final SpriteAnimation _idleAnimation;
  late final SpriteAnimation _jumpAnimation;

  //Constants
  static const double _stepTime = 0.03;
  static const moveSpeed = 20;
  static const tileSize = 16;
  static const bounceHeight = 100.0;

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
      position: Vector2(14, 0),
      size: Vector2(28, 14),
      anchor: Anchor.topCenter,
    ));

    _loadAnimations();
    return super.onLoad();
  }

  void _loadAnimations() {
    _idleAnimation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Traps/Trampoline/Idle.png'),
      SpriteAnimationData.sequenced(
        amount: 1,
        stepTime: _stepTime,
        textureSize: _textureSize,
        loop: true,
      ),
    );
    _jumpAnimation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Traps/Trampoline/Jump (28x28).png'),
      SpriteAnimationData.sequenced(
        amount: 8,
        stepTime: _stepTime,
        textureSize: _textureSize,
        loop: false,
      ),
    );

    animations = {
      TrampolineState.idle: _idleAnimation,
      TrampolineState.jump: _jumpAnimation,
    };

    current = TrampolineState.idle;
  }

  Future<void> collideWithPlayer() async {
    if (game.playSounds) FlameAudio.play('hit.wav', volume: game.soundVolume);
    current = TrampolineState.jump;
    player.velocity.y = -900;
    player.isOnGround = false;
    player.isJumping = false;
    player.canDoubleJump = true;
    await animationTicker?.completed;
    animationTicker?.reset();
    current = TrampolineState.idle;
  }
}
