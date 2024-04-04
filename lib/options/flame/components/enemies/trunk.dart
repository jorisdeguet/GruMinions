import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';

import '../player.dart';
import '../../game/pixel_adventure.dart';
import '../bullets/trunk_bullet.dart';

enum TrunkState { idle, attack, hit }

class Trunk extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure>, CollisionCallbacks {
  Trunk(
      {this.offNeg = 0,
      this.offPos = 0,
      this.isFacingRight = false,
      super.position,
      super.size});

  //Final variables
  final double offNeg;
  final double offPos;
  final bool isFacingRight;
  final _textureSize = Vector2(64, 32);

  //Animations
  late final SpriteAnimation _idleAnimation;
  late final SpriteAnimation _attackAnimation;
  late final SpriteAnimation _hitAnimation;

  //Constants
  static const stepTime = 0.05;
  static const tileSize = 16;
  static const moveSpeed = 80;
  static const bounceHeight = 300.0;

  //Late variables
  late Player player;
  late double _rangeNeg;
  late double _rangePos;
  late double _playerOffset;
  late Timer interval;

  //Defined variables
  bool _gotHit = false;

  @override
  FutureOr<void> onLoad() {
    player = game.player1;

    if (isFacingRight) {
      flipHorizontallyAroundCenter();
    }

    add(RectangleHitbox(
      position: Vector2(15, 2),
      size: Vector2(36, 32),
    ));

    _loadAllAnimations();
    _calculateRange();

    interval = Timer(
      2,
      onTick: () => _shoot(),
      repeat: true,
    );

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (!_gotHit) {
      _updateState(dt);
    }
    super.update(dt);
  }

  void _loadAllAnimations() {
    _idleAnimation = _spriteAnimation('Idle', 11);
    _attackAnimation = _spriteAnimation('Attack', 8)
      ..stepTime = 0.2
      ..loop = false;
    _hitAnimation = _spriteAnimation('Hit', 5)..loop = false;

    //List of all animations
    animations = {
      TrunkState.idle: _idleAnimation,
      TrunkState.attack: _attackAnimation,
      TrunkState.hit: _hitAnimation,
    };

    //Set default animation
    current = TrunkState.idle;
  }

  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Enemies/Trunk/$state (64x32).png'),
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

  Future<void> _updateState(dt) async {
    if (playerInRange()) {
      current = TrunkState.attack;
      await animationTicker?.completed.then((value) => interval.update(dt));
      animationTicker?.reset();
    } else if (!playerInRange()) {
      current = TrunkState.idle;
    }
  }

  bool playerInRange() {
    _playerOffset = (player.scale.x > 0) ? 0 : -player.width;

    return
        //true if player is in the left range
        player.x + _playerOffset >= _rangeNeg &&
            //true if player is in the right range
            player.x + _playerOffset <= _rangePos &&
            //true if the bottom of player is below the plant's top
            player.y < position.y + height;
  }

  void _shoot() {
    final bullet = TrunkBullet(
      position: Vector2(position.x, position.y + 8),
      size: Vector2(16, 16),
      offNeg: _rangeNeg,
      offPos: _rangePos,
      isFacingRight: isFacingRight,
    );
    game.worldMap.add(bullet);
  }

  void collideWithPlayer() async {
    if (player.velocity.y > 0 && player.y + player.height > position.y) {
      if (game.playSounds) FlameAudio.play('hit.wav', volume: game.soundVolume);
      _gotHit = true;
      current = TrunkState.hit;
      player.velocity.y = -bounceHeight;
      await animationTicker?.completed;
      removeFromParent();
      game.score.value += 14;
    } else {
      player.collideWithEnemy();
    }
  }
}
