import 'dart:async';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';

import '../friend.dart';
import '../player.dart';
import '../../game/pixel_adventure.dart';

enum SlimeState { idleRun, hit, particles }

class Slime extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure>, CollisionCallbacks {
  Slime({this.offNeg = 0, this.offPos = 0, super.position, super.size});

  //Final variables
  final double offNeg;
  final double offPos;
  final _textureSize = Vector2(44, 30);
  final _specialTextureSize = Vector2(62, 16);

  //Animations
  late final SpriteAnimation _idleRunAnimation;
  late final SpriteAnimation _hitAnimation;
  late final SpriteAnimation _particlesAnimation;

  //Constants
  static const stepTime = 0.12;
  static const tileSize = 16;
  static const moveSpeed = 20;
  static const bounceHeight = 320.0;

  //Late variables
  late Player player;
  late Friend? friend;
  late double _rangeNeg;
  late double _rangePos;
  late double _playerOffset;
  late double _friendOffset;
  late double _slimeOffset;

  //Defined variables
  //Default : 1 if enemy is facing right and -1 for if enemy is facing left
  double _facingDirection = -1;
  double _targetDirection = 0;
  Vector2 _velocity = Vector2.zero();
  bool _gotHit = false;

  @override
  FutureOr<void> onLoad() {
    player = game.player;
    friend = game.friend != null ? game.friend : null;
    add(RectangleHitbox(
      position: Vector2(4, 6),
      size: Vector2(31, 26),
    ));
    _loadAllAnimations();
    _calculateRange();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (!_gotHit) {
      _movement(dt);
      _updateState();
    }
    super.update(dt);
  }

  void _loadAllAnimations() {
    _idleRunAnimation = _spriteAnimation('Idle-Run', 10);
    _hitAnimation = _spriteAnimation('Hit', 5)..loop = false;
    _particlesAnimation = _specialSpriteAnimation('Particles', 4)..loop = false;

    //List of all animations
    animations = {
      SlimeState.idleRun: _idleRunAnimation,
      SlimeState.hit: _hitAnimation,
      SlimeState.particles: _particlesAnimation
    };

    //Set default animation
    current = SlimeState.idleRun;
  }

  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Enemies/Slime/$state (44x30).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: _textureSize,
      ),
    );
  }

  SpriteAnimation _specialSpriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Enemies/Slime/$state (62x16).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: _specialTextureSize,
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
    _slimeOffset = (scale.x > 0) ? 0 : -width;

    //If the friend is not null, we do the same thing as above
    if (friend != null) {
      _friendOffset = (friend!.scale.x > 0) ? 0 : -friend!.width;
    }

    if (playerInRange()) {
      _targetDirection =
      (player.x + _playerOffset < position.x + _slimeOffset) ? -1 : 1;
      _velocity.x = _targetDirection * moveSpeed;
    } else if (friendInRange()) {
      _targetDirection =
      (friend!.x + _friendOffset < position.x + _slimeOffset) ? -1 : 1;
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

  void _updateState() {
    current = SlimeState.idleRun;

    if ((_facingDirection > 0 && scale.x > 0) ||
        (_facingDirection < 0 && scale.x < 0)) {
      flipHorizontallyAroundCenter();
    }
  }

  void collideWithPlayer() async {
    if (player.velocity.y > 0 && player.y + player.height > position.y) {
      if (game.playSounds) FlameAudio.play('hit.wav', volume: game.soundVolume);
      _gotHit = true;
      current = SlimeState.hit;
      player.velocity.y = -bounceHeight;
      await animationTicker?.completed;

      removeFromParent();
      game.score.value += 10;
    } else {
      player.collideWithEnemy();
    }
  }

  void collideWithFriend() async {
    if (friend == null) return;

    if (friend!.velocity.y > 0 && friend!.y + friend!.height > position.y) {
      if (game.playSounds) FlameAudio.play('hit.wav', volume: game.soundVolume);
      _gotHit = true;
      current = SlimeState.hit;
      friend!.velocity.y = -bounceHeight;
      await animationTicker?.completed;
      removeFromParent();
      game.score.value += 5;
    } else {
      friend!.collideWithEnemy();
    }
  }
}
