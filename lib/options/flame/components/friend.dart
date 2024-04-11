import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../game/pixel_adventure.dart';
import '../helpers/custom_hitbox.dart';
import '../helpers/direction.dart';
import '../helpers/utils.dart';
import '../overlays/end.dart';
import 'bullets/plant_bullet.dart';
import 'enemies/chicken.dart';
import 'enemies/mushroom.dart';
import 'enemies/plant.dart';
import 'enemies/slime.dart';
import 'items/checkpoint.dart';
import '../helpers/collisions_block.dart';
import 'items/fruit.dart';
import 'player.dart';
import 'traps/fire.dart';
import 'traps/saw.dart';
import 'traps/spikes.dart';
import 'traps/trampoline.dart';

enum FriendState {
  idle,
  running,
  jumping,
  doubleJumping,
  wallJumping,
  falling,
  hit,
  appearing,
  disappearing
}

class Friend extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure>, CollisionCallbacks {
  Friend({super.position, this.character = 'Pink Man'});

  //Animations
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  late final SpriteAnimation jumpingAnimation;
  late final SpriteAnimation doubleJumpingAnimation;
  late final SpriteAnimation wallJumpingAnimation;
  late final SpriteAnimation fallingAnimation;
  late final SpriteAnimation hitAnimation;
  late final SpriteAnimation appearingAnimation;
  late final SpriteAnimation disappearingAnimation;

  //Final variables
  final String character;
  final double _gravity = 9.8;
  final double _jumpForce = 320;
  final double _terminalVelocity = 300;
  final double stepTime = 0.05;
  final ValueNotifier<double> life = ValueNotifier(3.0);
  final style = TextPaint(
    style: GoogleFonts.pixelifySans(
      textStyle: const TextStyle(
        fontSize: 5,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    ),
  );

  //Defined variables
  Direction direction = Direction.none;
  double fixedDeltaTime = 1 / 60;
  double accumulatedTime = 100;
  double directionX = 0;
  double moveSpeed = 100;
  bool isOnGround = false;
  bool isJumping = false;
  bool canDoubleJump = false;
  bool gotHit = false;
  bool isDead = false;
  bool reachedCheckpoint = false;
  bool reachedEnd = false;
  Vector2 velocity = Vector2.zero();
  List<CollisionBlock> collisions = [];
  CustomHitBox hitBox =
      CustomHitBox(offsetX: 10, offsetY: 4, width: 14, height: 28);

  //late variables
  late Player player;

  @override
  FutureOr<void> onLoad() {
    player = game.player;
    _loadAllAnimations();

    add(RectangleHitbox(
      position: Vector2(hitBox.offsetX, hitBox.offsetY),
      size: Vector2(hitBox.width, hitBox.height),
    ));
    add(
      TextComponent(
        text: 'Player 2',
        textRenderer: style,
        anchor: Anchor.topLeft,
        position: Vector2(size.x + 8, size.y - 5),
      ),
    );

    return super.onLoad();
  }

  @override
  void update(double dt) {
    accumulatedTime += dt;
    while (accumulatedTime >= fixedDeltaTime) {
      if (!gotHit && !reachedEnd && !isDead) {
        _updateFriendState();
        _updateFriendMovement(fixedDeltaTime);
        _checkHorizontalCollisions();
        _applyGravity(fixedDeltaTime);
        _checkVerticalCollisions();
      }
      accumulatedTime -= fixedDeltaTime;
    }
    super.update(dt);
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (!reachedEnd) {
      if (other is Fruit) other.collidedWithPlayer();
      if (other is Checkpoint) _reachedCheckpoint();
      if (other is End) _reachedEnd();
      if (other is Trampoline) other.collideWithFriend();
      if (other is Saw) _revive(1);
      if (other is Spikes) _revive(0.5);
      if (other is Fire) _revive(0.5);
      if (other is Mushroom) other.collideWithFriend();
      if (other is Slime) other.collideWithFriend();
      if (other is Chicken) other.collideWithFriend();
      if (other is Plant) other.collideWithFriend();
      if (other is PlantBullet) other.collideWithFriend();
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  void _loadAllAnimations() {
    idleAnimation = _spriteAnimation('Idle', 11);
    runningAnimation = _spriteAnimation('Run', 12);
    jumpingAnimation = _spriteAnimation('Jump', 1);
    doubleJumpingAnimation = _spriteAnimation('Double Jump', 6);
    wallJumpingAnimation = _spriteAnimation('Wall Jump', 5);
    fallingAnimation = _spriteAnimation('Fall', 1);
    hitAnimation = _spriteAnimation('Hit', 7)..loop = false;
    appearingAnimation = _specialSpriteAnimation('Appearing', 7);
    disappearingAnimation = _specialSpriteAnimation('Disappearing', 7);

    //List of all animations
    animations = {
      FriendState.idle: idleAnimation,
      FriendState.running: runningAnimation,
      FriendState.jumping: jumpingAnimation,
      FriendState.doubleJumping: doubleJumpingAnimation,
      FriendState.wallJumping: wallJumpingAnimation,
      FriendState.falling: fallingAnimation,
      FriendState.hit: hitAnimation,
      FriendState.appearing: appearingAnimation,
      FriendState.disappearing: disappearingAnimation,
    };
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

  void _updateFriendMovement(double dt) {
    switch (direction) {
      case Direction.up:
        isJumping = true;
        break;
      case Direction.down:
        isJumping = false;
        break;
      case Direction.left:
        directionX = -1;
        break;
      case Direction.right:
        directionX = 1;
        break;
      case Direction.none:
        directionX = 0;
        break;
    }

    if (isJumping && isOnGround) _friendJump(dt);
    if (isJumping && !isOnGround && canDoubleJump) _friendDoubleJump(dt);

    velocity.x = directionX * moveSpeed;
    position.x += velocity.x * dt;
  }

  void _updateFriendState() {
    FriendState friendState = FriendState.idle;

    //check facing direction
    if (velocity.x > 0 && scale.x < 0) {
      flipHorizontallyAroundCenter();
    } else if (velocity.x < 0 && scale.x > 0) {
      flipHorizontallyAroundCenter();
    }

    //check if running, set running
    if (velocity.x > 0 || velocity.x < 0) friendState = FriendState.running;

    //check if falling, set falling
    if (velocity.y > 0) friendState = FriendState.falling;

    //check if jumping, set jumping
    if (velocity.y < 0) friendState = FriendState.jumping;

    //check is double jumping, set double jumping
    if (velocity.y < 0 && !canDoubleJump) {
      friendState = FriendState.doubleJumping;
    }

    current = friendState;
  }

  void _friendJump(double dt) {
    if (game.playSounds) FlameAudio.play('jump.wav', volume: game.soundVolume);
    velocity.y = -_jumpForce;
    position.y += velocity.y * dt;
    isOnGround = false;
    isJumping = false;
    canDoubleJump = true;
  }

  void _friendDoubleJump(double dt) {
    if (game.playSounds) FlameAudio.play('jump.wav', volume: game.soundVolume);
    velocity.y = -_jumpForce;
    position.y += velocity.y * dt;
    isOnGround = false;
    isJumping = false;
    canDoubleJump = false;
  }

  void _friendWallJump() {
    current = FriendState.wallJumping;
    velocity.y = 20;
    canDoubleJump = true;
  }

  void _checkHorizontalCollisions() {
    for (final block in collisions) {
      if (!block.isPlatform) {
        if (checkCollision(this, block)) {
          if (velocity.x > 0) {
            if (!isOnGround) _friendWallJump();
            velocity.x = 0;
            position.x = block.x - hitBox.offsetX - hitBox.width;
            break;
          } else if (velocity.x < 0) {
            if (!isOnGround) _friendWallJump();
            velocity.x = 0;
            position.x = block.x + block.width + hitBox.offsetX + hitBox.width;
            break;
          }
        }
      }
    }
  }

  void _checkVerticalCollisions() {
    for (final block in collisions) {
      if (block.isPlatform) {
        if (checkCollision(this, block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - hitBox.offsetY - hitBox.height;
            isOnGround = true;
            break;
          }
        }
      } else {
        if (checkCollision(this, block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - hitBox.offsetY - hitBox.height;
            isOnGround = true;
            break;
          } else if (velocity.y < 0) {
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
    velocity.y = velocity.y.clamp(-_jumpForce, _terminalVelocity);
    position.y += velocity.y * dt;
  }

  Future<void> _revive(double lifePoints) async {
    if (game.playSounds) FlameAudio.play('hit.wav', volume: game.soundVolume);
    gotHit = true;
    life.value -= 1;
    current = FriendState.hit;

    await animationTicker?.completed;
    animationTicker?.reset();

    if (player.isDead && gotHit) {
      debugPrint('Friend got hit while player was dead');
      isDead = true;
      game.interval.stop();
      game.cam.stop();

      const duration = Duration(milliseconds: 350);
      Future.delayed(duration, () {
        reachedCheckpoint = false;
        gotHit = false;
        isDead = false;
        player.isDead = false;

        const waitToChangeDuration = Duration(seconds: 2);
        Future.delayed(waitToChangeDuration, () => {game.overlays.add('End')});
      });
    }

    if (life.value > 0 && !player.isDead) {
      debugPrint('Friend is reappearing...');
      debugPrint('Life: ${life.value}');
      scale.x = 1;
      position = player.position - Vector2(64, 32);
      current = FriendState.appearing;

      await animationTicker?.completed;
      animationTicker?.reset();

      velocity = Vector2.zero();
      position = player.position - Vector2(32, 0);
      _updateFriendState();
      Future.delayed(const Duration(milliseconds: 400), () => gotHit = false);
    } else {
      debugPrint('Friend is dead');
      isDead = true;
      position = Vector2.all(-640);
      if (!player.isDead) game.cam.follow(player);
    }
  }

  Future<void> reviveByPlayer() async {
    debugPrint('Revived by player');
    life.value = 1;
    isDead = false;

    scale.x = 1;
    position = player.position - Vector2(64, 32);
    current = FriendState.appearing;

    await animationTicker?.completed;
    animationTicker?.reset();

    velocity = Vector2.zero();
    position = player.position - Vector2(32, 0);
    _updateFriendState();
    Future.delayed(const Duration(milliseconds: 400), () => gotHit = false);
  }

  Future<void> _reachedCheckpoint() async {
    //Can only reach checkpoint once
    if (!reachedCheckpoint) {
      if (game.playSounds) {
        FlameAudio.play('disappear.wav', volume: game.soundVolume);
      }
      reachedCheckpoint = true;
      life.value += 1;
      if(player.isDead) player.reviveByFriend();
      game.score.value += 100;
    }
  }

  Future<void> _reachedEnd() async {
    reachedEnd = true;
    game.cam.stop();
    game.interval.stop();

    if (game.playSounds) FlameAudio.play('disappear.wav', volume: game.soundVolume);
    if (scale.x > 0) {
      position = position - Vector2.all(32);
    } else if (scale.x < 0) {
      position = position + Vector2(32, -32);
    }
    current = FriendState.disappearing;
    game.score.value += 200;

    await animationTicker?.completed;
    animationTicker?.reset();

    const reachedCheckpointDuration = Duration(milliseconds: 350);
    Future.delayed(reachedCheckpointDuration, () {
      reachedCheckpoint = false;
      reachedEnd = false;
      position = Vector2.all(-640);

      const waitToChangeDuration = Duration(seconds: 6);
      Future.delayed(waitToChangeDuration, () => game.overlays.add('End'));
    });
  }

  void collideWithEnemy() {
    _revive(1);
  }
}
