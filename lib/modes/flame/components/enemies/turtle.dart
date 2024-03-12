import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:gru_minions/modes/flame/game.dart';

import '../player.dart';

enum TurtleState { idle1, idle2, hit, spikesIn, spikesOut}

//special features: spikes out and in
class Turtle extends SpriteAnimationGroupComponent
    with HasGameRef<MainGame>, CollisionCallbacks {

  Turtle({this.offNeg = 0, this.offPos = 0, super.position, super.size});

  //Final variables
  final double offNeg;
  final double offPos;
  final _textureSize = Vector2(44, 26);

  //Animations
  late final SpriteAnimation _idle1Animation;
  late final SpriteAnimation _idle2Animation;
  late final SpriteAnimation _hitAnimation;
  late final SpriteAnimation _spikesInAnimation;
  late final SpriteAnimation _spikesOutAnimation;

  //Constants
  static const stepTime = 0.05;
  static const tileSize = 16;
  static const moveSpeed = 80;
  static const bounceHeight = 260.0;

  //Late variables
  late Player player;
  late double _rangeNeg;
  late double _rangePos;
  late double _playerOffset;

  //Defined variables
  bool _gotHit = false;
  bool _spikesOut = false;

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
    if (!_gotHit) {
      _updateState();
    }
    super.update(dt);
  }

  void _loadAllAnimations() {
    _idle1Animation = _spriteAnimation('Idle 1', 14);
    _idle2Animation = _spriteAnimation('Idle 2', 14);
    _hitAnimation = _spriteAnimation('Hit', 5)..loop = false;
    _spikesInAnimation = _spriteAnimation('Spikes in', 8)..loop = false;
    _spikesOutAnimation = _spriteAnimation('Spikes out', 8)..loop = false;

    //List of all animations
    animations = {
      TurtleState.idle1: _idle1Animation,
      TurtleState.idle2: _idle2Animation,
      TurtleState.hit: _hitAnimation,
      TurtleState.spikesIn: _spikesInAnimation,
      TurtleState.spikesOut: _spikesOutAnimation
    };

    //Set default animation
    current = TurtleState.idle2;
  }

  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Enemies/Turtle/$state (44x26).png'),
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

  void _updateState() async {
    if (playerInRange() && !_spikesOut) {
      _spikesOut = true;
      current = TurtleState.spikesOut;
      await animationTicker?.completed;
      animationTicker?.reset();
    }
    else if(playerInRange() && _spikesOut) {
      current = TurtleState.idle1;
      await animationTicker?.completed;
      animationTicker?.reset();
    }
    else if (!playerInRange() && _spikesOut){
      _spikesOut = false;
      current = TurtleState.spikesIn;
      await animationTicker?.completed;
      animationTicker?.reset();
    }
    else {
      current = TurtleState.idle2;
    }
  }

  void collideWithPlayer() async {
    if (player.velocity.y > 0 && player.y + player.height > position.y) {
      //if (game.playSounds) FlameAudio.play('hit.wav', volume: game.soundVolume);
      _gotHit = true;
      current = TurtleState.hit;
      player.velocity.y = -bounceHeight;
      await animationTicker?.completed;
      removeFromParent();
    } else {
      player.collideWithEnemy();
    }
  }
}
