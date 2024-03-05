import 'dart:async';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:gru_minions/modes/flame/game.dart';

import '../player.dart';

enum ChickenState { idle, run, hit }
class Chicken extends SpriteAnimationGroupComponent with HasGameRef<MainGame>, CollisionCallbacks{
  Chicken({this.offNeg = 0, this.offPos = 0, super.position, super.size});
  final double offNeg;
  final double offPos;

  //Animations
  late final SpriteAnimation _idleAnimation;
  late final SpriteAnimation _runAnimation;
  late final SpriteAnimation _hitAnimation;

  //Player
  late Player player;

  //Constants
  static const stepTime = 0.05;
  static const tileSize = 16;
  static const moveSpeed = 80;
  static const _bounceHeight = 260.0;

  //Other variables
  double rangeNeg = 0;
  double rangePos = 0;
  double moveDirection = 1;
  double targetDirection = -1;
  Vector2 velocity = Vector2.zero();
  bool gotHit = false;


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
    if(!gotHit) {
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
        textureSize: Vector2(32, 34),
      ),
    );
  }

  void _calculateRange() {
    rangeNeg = position.x - offNeg * tileSize;
    rangePos = position.x + offPos * tileSize;
  }

  void _movement(double dt) {
    velocity.x = 0;

    double playerOffset = (player.scale.x > 0) ? 0 : -player.width;
    double chickenOffset = (scale.x > 0) ? 0 : -width;

    if(playerInRange()){
      targetDirection = (player.x + playerOffset < position.x + chickenOffset) ? -1 : 1;
      velocity.x = targetDirection * moveSpeed;
    }
    moveDirection = lerpDouble(moveDirection, targetDirection, 0.1) ?? 1;
    position.x += velocity.x * dt;

  }

  bool playerInRange() {
    double playerOffset = (player.scale.x > 0) ? 0 : -player.width;
    return player.x + playerOffset <= rangePos &&
        player.x + playerOffset <= rangePos &&
        player.y + player.height > position.y &&
        player.y < position.y + height;
  }

  void updateState() {
    current = (velocity.x != 0) ? ChickenState.run : ChickenState.idle;

    if((moveDirection > 0 && scale.x > 0) || (moveDirection < 0 && scale.x < 0)) {
      flipHorizontallyAroundCenter();
    }
  }

  void collidedWithPlayer() async {
    if(player.velocity.y > 0 && player.y + player.height > position.y){
      //if(game.playSounds) FlameAudio.play('hit.wav', volume: game.soundVolume);
      gotHit = true;
      current = ChickenState.hit;
      player.velocity.y = -_bounceHeight;
      await animationTicker?.completed;
      removeFromParent();
    }
    else{
      player.collidedWithEnemy();
    }
  }
}