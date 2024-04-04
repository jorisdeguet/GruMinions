import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';

import '../player.dart';
import '../../game/pixel_adventure.dart';

enum TrunkBulletState { bullet, bulletPieces}

class TrunkBullet extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure>, CollisionCallbacks {

  TrunkBullet({this.offNeg = 0, this.offPos = 0, this.isFacingRight = false, super.position, super.size});

  //Final variables
  final double offNeg;
  final double offPos;
  final bool isFacingRight;
  final _textureSize = Vector2.all(16);

  //Animations
  late final SpriteAnimation _bulletAnimation;
  late final SpriteAnimation _bulletPiecesAnimation;
  late final double _direction;

  //Constants
  static const stepTime = 0.05;
  static const tileSize = 16;
  static const _speed = 80.0;
  static const bounceHeight = 300.0;

  //Late variables
  late Player player;

  @override
  FutureOr<void> onLoad() {
    player = game.player1;

    _direction = isFacingRight ? 1 : -1;
    if(isFacingRight) {
      flipHorizontallyAroundCenter();
    }

    add(CircleHitbox(
      radius: 4,
      position: Vector2(12, 4),
      anchor: Anchor.topRight,
    ));

    _loadAllAnimations();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    // Moves the bullet to a new position with _speed and direction.
    position.x += _direction * _speed * dt;
    // If bullet crosses the left border of screen,
    // removed it from the game world.
    if (isFacingRight) {
      if (position.x > offPos) {
        removeFromParent();
      }
    }
    else if (position.x < offNeg) {
      removeFromParent();
    }
    super.update(dt);
  }

  void _loadAllAnimations() {
    _bulletAnimation = _spriteAnimation('Bullet', 1);
    _bulletPiecesAnimation = _spriteAnimation('Bullet Pieces', 1)..loop = false;

    //List of all animations
    animations = {
      TrunkBulletState.bullet: _bulletAnimation,
      TrunkBulletState.bulletPieces: _bulletPiecesAnimation,
    };

    //Set default animation
    current = TrunkBulletState.bullet;
  }

  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Enemies/Trunk/$state.png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: _textureSize,
      ),
    );
  }

  void collideWithPlayer() async {
    if (player.velocity.y > 0 && player.y + player.height > position.y) {
      if (game.playSounds) FlameAudio.play('hit.wav', volume: game.soundVolume);
      current = TrunkBulletState.bulletPieces;
      player.velocity.y = -bounceHeight;
      await animationTicker?.completed;
      removeFromParent();
      game.score.value += 2;
    } else {
      player.collideWithEnemy();
      removeFromParent();
    }
  }
}
