import 'dart:async';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';

import '../player.dart';
import '../../game/pixel_adventure.dart';

enum MushroomState { idle, run, hit }

class Mushroom extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure>, CollisionCallbacks {

  Mushroom({this.offNeg = 0, this.offPos = 0, super.position, super.size});

  //Final variables
  final double offNeg;
  final double offPos;
  final _textureSize = Vector2(32, 32);

  //Animations
  late final SpriteAnimation _idleAnimation;
  late final SpriteAnimation _runAnimation;
  late final SpriteAnimation _hitAnimation;

  //Constants
  static const stepTime = 0.05;
  static const tileSize = 16;
  static const moveSpeed = 70;
  static const bounceHeight = 260.0;

  //Late variables
  late Player player;
  late double _rangeNeg;
  late double _rangePos;
  late double _playerOffset;
  late double _mushroomOffset;

  //Defined variables
  //Default : 1 if enemy is facing right and -1 for if enemy is facing left
  double _facingDirection = -1;
  double _targetDirection = 0;
  final Vector2 _velocity = Vector2.zero();
  bool _gotHit = false;

  @override
  FutureOr<void> onLoad() {
    player = game.player1;
    add(RectangleHitbox(
      position: Vector2(4, 8),
      size: Vector2(24, 24),
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
    _idleAnimation = _spriteAnimation('Idle', 14);
    _runAnimation = _spriteAnimation('Run', 16);
    _hitAnimation = _specialSpriteAnimation('Hit', 5)..loop = false;

    //List of all animations
    animations = {
      MushroomState.idle: _idleAnimation,
      MushroomState.run: _runAnimation,
      MushroomState.hit: _hitAnimation
    };

    //Set default animation
    current = MushroomState.idle;
  }

  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Enemies/Mushroom/$state (32x32).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: _textureSize,
      ),
    );
  }

  SpriteAnimation _specialSpriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Enemies/Mushroom/$state.png'),
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
    _mushroomOffset = (scale.x > 0) ? 0 : -width;
    //
    if (playerInRange()) {
      _targetDirection =
          (player.x + _playerOffset < position.x + _mushroomOffset) ? -1 : 1;
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

  void _updateState() {
    current = (_velocity.x != 0) ? MushroomState.run : MushroomState.idle;

    if ((_facingDirection > 0 && scale.x > 0) ||
        (_facingDirection < 0 && scale.x < 0)) {
      flipHorizontallyAroundCenter();
    }
  }

  void collideWithPlayer() async {
    if (player.velocity.y > 0 && player.y + player.height > position.y) {
      if (game.playSounds) FlameAudio.play('hit.wav', volume: game.soundVolume);
      _gotHit = true;
      current = MushroomState.hit;
      player.velocity.y = -bounceHeight;
      await animationTicker?.completed;
      removeFromParent();
      game.score.value += 5;
    } else {
      player.collideWithEnemy();
    }
  }
}
