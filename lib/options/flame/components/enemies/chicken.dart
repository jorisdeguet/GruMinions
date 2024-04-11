import 'dart:async';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';

import '../friend.dart';
import '../player.dart';
import '../../game/pixel_adventure.dart';

enum ChickenState { idle, run, hit }

class Chicken extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure>, CollisionCallbacks {
  Chicken({this.offNeg = 0, this.offPos = 0, super.position, super.size});

  //Final variables
  final double offNeg;
  final double offPos;
  final _textureSize = Vector2(32, 34);
  final Vector2 _velocity = Vector2.zero();

  //Animations
  late final SpriteAnimation _idleAnimation;
  late final SpriteAnimation _runAnimation;
  late final SpriteAnimation _hitAnimation;

  //Constants
  static const stepTime = 0.05;
  static const tileSize = 16;
  static const moveSpeed = 80;
  static const bounceHeight = 260.0;

  //Late variables
  late Player player;
  late Friend? friend;
  late double _rangeNeg;
  late double _rangePos;
  late double _playerOffset;
  late double _friendOffset;
  late double _chickenOffset;

  //Defined variables
  //Default : 1 if enemy is facing right and -1 for if enemy is facing left
  double _facingDirection = -1;
  double _targetDirection = 0;
  bool _gotHit = false;

  @override
  FutureOr<void> onLoad() {
    player = game.player;
    friend = game.friend;
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
    if (!_gotHit) {
      _movement(dt);
      updateState();
    }
    super.update(dt);
  }

  void _loadAllAnimations() {
    _idleAnimation = _spriteAnimation('Idle', 13);
    _runAnimation = _spriteAnimation('Run', 14);
    _hitAnimation = _spriteAnimation('Hit', 15)..loop = false;

    //List of all animations
    animations = {
      ChickenState.idle: _idleAnimation,
      ChickenState.run: _runAnimation,
      ChickenState.hit: _hitAnimation,
    };

    //Set default animation
    current = ChickenState.idle;
  }

  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Enemies/Chicken/$state (32x34).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
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
    _chickenOffset = (scale.x > 0) ? 0 : -width;

    //If the friend is not null, we do the same thing as above
    if (friend != null) {
      _friendOffset = (friend!.scale.x > 0) ? 0 : -friend!.width;
    }

    if (playerInRange()) {
      _targetDirection =
      (player.x + _playerOffset < position.x + _chickenOffset) ? -1 : 1;
      _velocity.x = _targetDirection * moveSpeed;
    } else if (friendInRange()) {
      _targetDirection =
      (friend!.x + _friendOffset < position.x + _chickenOffset) ? -1 : 1;
      _velocity.x = _targetDirection * moveSpeed;
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

  bool friendInRange() {
    if (friend == null) return false;

    _friendOffset = (friend!.scale.x > 0) ? 0 : -friend!.width;
    return
      //true if player is in the left range
      friend!.x + _friendOffset >= _rangeNeg &&
          //true if player is in the right range
          friend!.x + _friendOffset <= _rangePos &&
          //true if the top of player is above the chicken's bottom
          friend!.y + friend!.height > position.y &&
          //true if the bottom of player is below the chicken's top
          friend!.y < position.y + height;
  }

  void updateState() {
    current = (_velocity.x != 0) ? ChickenState.run : ChickenState.idle;

    if ((_facingDirection > 0 && scale.x > 0) ||
        (_facingDirection < 0 && scale.x < 0)) {
      flipHorizontallyAroundCenter();
    }
  }

  void collideWithPlayer() async {
    if (player.velocity.y > 0 && player.y + player.height > position.y) {
      if (game.playSounds) FlameAudio.play('hit.wav', volume: game.soundVolume);
      _gotHit = true;
      current = ChickenState.hit;
      player.velocity.y = -bounceHeight;
      await animationTicker?.completed;
      removeFromParent();
      game.score.value += 5;
    } else {
      player.collideWithEnemy();
    }
  }

  void collideWithFriend() async {
    if (friend == null) return;

    if (friend!.velocity.y > 0 && friend!.y + friend!.height > position.y) {
      if (game.playSounds) FlameAudio.play('hit.wav', volume: game.soundVolume);
      _gotHit = true;
      current = ChickenState.hit;
      friend!.velocity.y = -bounceHeight;
      await animationTicker?.completed;
      removeFromParent();
      game.score.value += 5;
    } else {
      friend!.collideWithEnemy();
    }
  }
}