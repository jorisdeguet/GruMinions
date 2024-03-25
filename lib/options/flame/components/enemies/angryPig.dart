import 'dart:async';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';

import '../../game/pixel_adventure.dart';
import '../player.dart';

enum AngryPigState { idle, walk, run, hit1, hit2 }

//Special feature can walk and needs two hits to die
class AngryPig extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure>, CollisionCallbacks {
  AngryPig(
      {this.isWalking = false,
      this.offNeg = 0,
      this.offPos = 0,
      super.position,
      super.size});

  //Final variables
  final bool isWalking;
  final double offNeg;
  final double offPos;
  final _textureSize = Vector2(36, 30);

  //Animations
  late final SpriteAnimation _idleAnimation;
  late final SpriteAnimation _walkAnimation;
  late final SpriteAnimation _runAnimation;
  late final SpriteAnimation _hit1Animation;
  late final SpriteAnimation _hit2Animation;

  //Constants
  static const stepTime = 0.05;
  static const specialStepTime = 0.1;
  static const tileSize = 16;
  static const walkSpeed = 10;
  static const runSpeed = 80;
  static const bounceHeight = 260.0;

  //Late variables
  late Player player;
  late double _rangeNeg;
  late double _rangePos;
  late double _playerOffset;
  late double _angryPigOffset;

  //Defined variables
  //Default : 1 if enemy is facing right and -1 for if enemy is facing left
  double _facingDirection = -1;
  double _targetDirection = 0;
  final Vector2 _velocity = Vector2.zero();
  bool _gotFirstHit = false;
  bool _gotSecondHit = false;

  @override
  FutureOr<void> onLoad() {
    player = game.player;
    add(RectangleHitbox(
      position: Vector2(4, 6),
      size: Vector2(24, 26),
    ));
    _loadAllAnimations();
    _calculateRange();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (!_gotSecondHit) {
      _movement(dt);
      _updateState();
    }
    super.update(dt);
  }

  void _loadAllAnimations() {
    _idleAnimation = _spriteAnimation('Idle', 9);
    _walkAnimation = _specialSpriteAnimation('Walk', 16);
    _runAnimation = _spriteAnimation('Run', 12);
    _hit1Animation = _spriteAnimation('Hit 1', 5)..loop = false;
    _hit2Animation = _spriteAnimation('Hit 2', 5)..loop = false;

    //List of all animations
    animations = {
      AngryPigState.idle: _idleAnimation,
      AngryPigState.walk: _walkAnimation,
      AngryPigState.run: _runAnimation,
      AngryPigState.hit1: _hit1Animation,
      AngryPigState.hit2: _hit2Animation,
    };

    //Set default animation
    current = AngryPigState.idle;
  }

  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Enemies/AngryPig/$state (36x30).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: _textureSize,
      ),
    );
  }

  SpriteAnimation _specialSpriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Enemies/AngryPig/$state (36x30).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: specialStepTime,
        textureSize: _textureSize,
      ),
    );
  }

  void _calculateRange() {
    //Calculate the range vision of the enemy
    _rangeNeg = position.x - offNeg * tileSize; //left range
    _rangePos = position.x + offPos * tileSize; //right range
  }

  void _movement(double dt) {
    _velocity.x = 0;

    //Depending on the direction the player or the chicken is facing the value
    //of the scaleX is gonna be different, to prevent that we do this :
    _playerOffset = (player.scale.x > 0) ? 0 : -player.width;
    _angryPigOffset = (scale.x > 0) ? 0 : -width;

    if (playerInRange()) {
      _targetDirection =
          (player.x + _playerOffset < position.x + _angryPigOffset) ? -1 : 1;
      _velocity.x = _targetDirection * runSpeed;
    }

    _facingDirection = lerpDouble(_facingDirection, _targetDirection, 0.1) ?? 1;
    position.x += _velocity.x * dt;
  }

  bool playerInRange() {
    _playerOffset = (player.scale.x > 0) ? 0 : -player.width;

    return
        //true if player is in the left range
        player.x + _playerOffset >= _rangeNeg &&
            //true if player is in the right range
            player.x + _playerOffset <= _rangePos &&
            //true if the top of player is above the chicken's bottom
            player.y + player.height > position.y &&
            //true if the bottom of player is below the chicken's top
            player.y < position.y + height;
  }

  void _updateState() {
    current = (_velocity.x != 0) ? AngryPigState.run : AngryPigState.idle;

    if ((_facingDirection > 0 && scale.x > 0) ||
        (_facingDirection < 0 && scale.x < 0)) {
      flipHorizontallyAroundCenter();
    }
  }

  void collideWithPlayer() async {
    if (player.velocity.y > 0 && player.y + player.height > position.y) {
      if (game.playSounds) FlameAudio.play('hit.wav', volume: game.soundVolume);
      if (!_gotFirstHit) {
        _gotFirstHit = true;
        current = AngryPigState.hit1;
        player.velocity.y = -bounceHeight;
        await animationTicker?.completed;
        current = AngryPigState.idle;
      } else {
        _gotSecondHit = true;
        current = AngryPigState.hit2;
        player.velocity.y = -bounceHeight;
        await animationTicker?.completed;
        removeFromParent();
        game.score.value += 50;
      }
    } else {
      player.collideWithEnemy();
    }
  }
}