import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';

import '../bullets/plant_bullet.dart';
import '../player.dart';
import '../../game/pixel_adventure.dart';

enum PlantState { idle, attack, hit }

class Plant extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure>, CollisionCallbacks {
  Plant(
      {this.offNeg = 0,
      this.offPos = 0,
      this.isFacingRight = false,
      super.position,
      super.size});

  //Final variables
  final double offNeg;
  final double offPos;
  final bool isFacingRight;
  final _textureSize = Vector2(44, 42);

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
    player = game.player;

    if (isFacingRight) {
      flipHorizontallyAroundCenter();
    }

    add(RectangleHitbox(
      position: Vector2(4, 6),
      size: Vector2(36, 36),
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
    _attackAnimation = _spriteAnimation('Attack', 8)..stepTime = 0.2..loop = false;
    _hitAnimation = _spriteAnimation('Hit', 5)..loop = false;

    //List of all animations
    animations = {
      PlantState.idle: _idleAnimation,
      PlantState.attack: _attackAnimation,
      PlantState.hit: _hitAnimation,
    };

    //Set default animation
    current = PlantState.idle;
  }

  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Enemies/Plant/$state (44x42).png'),
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
      current = PlantState.attack;
      await animationTicker?.completed.then((value) => interval.update(dt));
      animationTicker?.reset();
    } else if (!playerInRange()) {
      current = PlantState.idle;
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
    final bullet = PlantBullet(
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
      current = PlantState.hit;
      player.velocity.y = -bounceHeight;
      await animationTicker?.completed;
      removeFromParent();
      game.score.value += 14;
    } else {
      player.collideWithEnemy();
    }
  }
}
