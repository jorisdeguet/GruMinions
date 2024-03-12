import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:gru_minions/modes/flame/components/traps/saw.dart';
import 'package:gru_minions/modes/flame/components/traps/spike_head.dart';
import 'package:gru_minions/modes/flame/components/traps/spikes.dart';
import 'package:gru_minions/modes/flame/components/traps/trampoline.dart';
import 'package:gru_minions/modes/flame/components/utils.dart';

import '../game.dart';
import 'custom_hitbox.dart';
import 'enemies/angry_pig.dart';
import 'enemies/bat.dart';
import 'enemies/mushroom.dart';
import 'enemies/rino.dart';
import 'enemies/slime.dart';
import 'enemies/turtle.dart';
import 'items/box.dart';
import 'items/checkpoint.dart';
import 'collisions_block.dart';
import 'enemies/chicken.dart';
import 'items/end.dart';
import 'items/fruit.dart';

enum PlayerState { idle, running, jumping, falling, hit, appearing, disappearing }

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<MainGame>, KeyboardHandler, CollisionCallbacks {
  Player({super.position ,this.character = 'Ninja Frog'});
  String character;

  //Animations
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  late final SpriteAnimation jumpingAnimation;
  late final SpriteAnimation fallingAnimation;
  late final SpriteAnimation hitAnimation;
  late final SpriteAnimation appearingAnimation;
  late final SpriteAnimation disappearingAnimation;

  //Constants
  final double _gravity = 9.8;
  final double _jumpForce = 300;
  final double _terminalVelocity = 300;
  final double stepTime = 0.05;
  final ValueNotifier<double> life = ValueNotifier(100.0);

  double fixedDeltaTime = 1 / 60;
  double accumulatedTime = 100;
  double directionX = 0;
  double moveSpeed = 100;

  //States
  bool isOnGround = false;
  bool isHasJumped = false;
  bool gotHit = false;
  bool reachedEnd = false;

  Vector2 velocity = Vector2.zero();
  Vector2 revivePosition = Vector2.zero();
  List<CollisionBlock> collisions = [];
  CustomHitBox hitBox = CustomHitBox(offsetX: 10, offsetY: 4, width: 14, height: 28);

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();
    //revivePosition = Vector2(position.x, position.y);
    add(RectangleHitbox(
      position: Vector2(hitBox.offsetX, hitBox.offsetY),
      size: Vector2(hitBox.width, hitBox.height),
    ));
    return super.onLoad();
  }

  @override
  void update(double dt) {
    accumulatedTime += dt;
    while (accumulatedTime >= fixedDeltaTime) {
      if(!gotHit && !reachedEnd){
        _updatePlayerState();
        _updatePlayerMovement(fixedDeltaTime);
        _checkHorizontalCollisions();
        _applyGravity(fixedDeltaTime);
        _checkVerticalCollisions();
      }
      accumulatedTime -= fixedDeltaTime;
    }
    super.update(dt);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    directionX = 0;
    final isKeyLeftPressed = keysPressed.contains(LogicalKeyboardKey.arrowLeft) || keysPressed.contains(LogicalKeyboardKey.keyA);
    final isKeyRightPressed = keysPressed.contains(LogicalKeyboardKey.arrowRight) || keysPressed.contains(LogicalKeyboardKey.keyD);

    directionX = isKeyLeftPressed ? -1 : 0;
    directionX += isKeyRightPressed ? 1 : 0;

    isHasJumped = keysPressed.contains(LogicalKeyboardKey.space);

    return super.onKeyEvent(event, keysPressed);
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    if(!reachedEnd){
      if(other is Fruit) other.collidedWithPlayer();
      if(other is Box) other.collidedWithPlayer();
      if(other is Checkpoint) _reachedCheckpoint();
      if(other is End) _reachedEnd();
      if(other is Saw) _revive();
      if(other is Spikes) _revive();
      if(other is SpikeHead) _revive();
      if(other is Trampoline) other.collideWithPlayer();
      if(other is Chicken) other.collideWithPlayer();
      if(other is Mushroom) other.collideWithPlayer();
      if(other is Rino) other.collideWithPlayer();
      if(other is Slime) other.collideWithPlayer();
      if(other is AngryPig) other.collideWithPlayer();
      if(other is Bat) other.collideWithPlayer();
      if(other is Turtle) other.collideWithPlayer();
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  void _loadAllAnimations() {
    idleAnimation = _spriteAnimation('Idle', 11);
    runningAnimation = _spriteAnimation('Run', 12);
    jumpingAnimation = _spriteAnimation('Jump', 1);
    fallingAnimation = _spriteAnimation('Fall', 1);
    hitAnimation = _spriteAnimation('Hit', 7)..loop = false;
    appearingAnimation = _specialSpriteAnimation('Appearing', 7);
    disappearingAnimation = _specialSpriteAnimation('Disappearing', 7);

    //List of all animations
    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation,
      PlayerState.jumping: jumpingAnimation,
      PlayerState.falling: fallingAnimation,
      PlayerState.hit: hitAnimation,
      PlayerState.appearing: appearingAnimation,
      PlayerState.disappearing: disappearingAnimation,
    };

    //Set default animation
    current = PlayerState.idle;
  }

  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Main Characters/$character/$state (32x32).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: Vector2.all(32),
      ),
    );
  }

  SpriteAnimation _specialSpriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Main Characters/$state (96x96).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: Vector2.all(96),
        loop: false,
      ),
    );
  }

  void _updatePlayerMovement(double dt) {
    if (isHasJumped && isOnGround) _playerJump(dt);
    //if (velocity.y > _gravity) isOnGround = false; //optional
    velocity.x = directionX * moveSpeed;
    position.x += velocity.x * dt;
  }

  void _updatePlayerState() {
    PlayerState playerState = PlayerState.idle;

    //check facing direction
    if(velocity.x > 0 && scale.x < 0){
      flipHorizontallyAroundCenter();
    }
    if(velocity.x < 0 && scale.x > 0){
      flipHorizontallyAroundCenter();
    }

    //check if running, set running
    if (velocity.x > 0 || velocity.x < 0) playerState = PlayerState.running;

    //check if falling, set falling
    if (velocity.y > 0) playerState = PlayerState.falling;

    //check if jumping, set jumping
    if (velocity.y < 0) playerState = PlayerState.jumping;

    current = playerState;
  }

  void _playerJump(double dt) {
    //if(game.playSounds) FlameAudio.play('jump.wav', volume: game.soundVolume);
    velocity.y = -_jumpForce;
    position.y += velocity.y * dt;
    isOnGround = false;
    isHasJumped = false;
  }

  void _checkHorizontalCollisions() {
    for(final block in collisions) {
      if (!block.isPlatform) {
        if (checkCollision(this, block)) {
          if (velocity.x > 0) {
            velocity.x = 0;
            position.x = block.x - hitBox.offsetX - hitBox.width;
            break;
          }
          if (velocity.x < 0) {
            velocity.x = 0;
            position.x = block.x + block.width + hitBox.offsetX + hitBox.width;
            break;
          }
        }
      }
    }
  }

  void _checkVerticalCollisions() {
    for(final block in collisions) {
      if (block.isPlatform) {
        if (checkCollision(this, block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - hitBox.offsetY - hitBox.height;
            isOnGround = true;
            break;
          }
        }
      }
      else{
        if (checkCollision(this, block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - hitBox.offsetY - hitBox.height;
            isOnGround = true;
            break;
          }
          if (velocity.y < 0) {
            velocity.y = 0;
            position.y = block.y + block.height - hitBox.offsetY;
            break;
          }
        }
      }
    }
  }

  void _applyGravity(double dt) {
    velocity.y += _gravity * dt * 100;
    velocity.y = velocity.y.clamp(- _jumpForce, _terminalVelocity);
    position.y += velocity.y * dt;
  }

  Future<void> _revive() async {
    //if(game.playSounds) FlameAudio.play('hit.wav', volume: game.soundVolume);
    gotHit = true;
    current = PlayerState.hit;
    life.value -= 10;

    if(life.value <= 0){
      current = PlayerState.disappearing;
      await animationTicker?.completed;
      removeFromParent();
    }

    await animationTicker?.completed;
    animationTicker?.reset();

    scale.x = 1;
    position = revivePosition - Vector2.all(32);
    current = PlayerState.appearing;

    await animationTicker?.completed;
    animationTicker?.reset();

    velocity = Vector2.zero();
    position = revivePosition;
    _updatePlayerState();
    Future.delayed(const Duration(milliseconds: 400), () => gotHit = false);
  }

  void _reachedCheckpoint() {
    //if(game.playSounds) FlameAudio.play('disappear.wav', volume: game.soundVolume);
    revivePosition = Vector2(position.x, position.y);
  }

  void _reachedEnd() {
    reachedEnd = true;
    //if(game.playSounds) FlameAudio.play('disappear.wav', volume: game.soundVolume);
    if(scale.x > 0) {
      position = position - Vector2.all(32);
    }
    else if(scale.x < 0) {
      position = position + Vector2(32, -32);
    }
    current = PlayerState.disappearing;

    //await animationTicker?.completed();
    //animationTicker?.reset();

    const reachedCheckpointDuration = Duration(milliseconds: 350);
    Future.delayed(reachedCheckpointDuration, () {
      reachedEnd = false;
      position = Vector2.all(-640);

      const waitToChangeDuration = Duration(seconds: 3);
      Future.delayed(waitToChangeDuration, () => game.loadNextLevel());
    });
  }

  void collideWithEnemy() {
    _revive();
  }
}