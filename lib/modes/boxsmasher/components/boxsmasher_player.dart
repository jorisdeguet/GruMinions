import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:gru_minions/modes/boxsmasher/components/world/boxsmasher_ground.dart';

import '../boxsmasher_game.dart';

class BoxSmasherPlayer extends SpriteAnimationComponent with CollisionCallbacks, HasGameRef<BoxSmasherGame>{
  final double _playerSpeed = 50.0;
  final double _animationSpeed = 0.1;

  late SpriteAnimationComponent idleAnimation = SpriteAnimationComponent();

  bool onPressed = false;
  bool onGround = false;

  BoxSmasherPlayer(Vector2 p)
      : super(
      size: Vector2(32, 32),
      position: p,
  );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(RectangleHitbox());
    await _loadAnimations().then((_) => {animation = idleAnimation.animation});
  }

  @override
  void onCollision(intersectionPoints, other){
    super.onCollision(intersectionPoints, other);

    if (other is Ground){
      onGround = true;
    }
  }

  @override
  void onCollisionEnd(other){
    super.onCollisionEnd(other);

    if (other is Ground){
      onGround = false;
    }
  }

  @override
  void update(double delta) {
    super.update(delta);
  }

  Future<void> _loadAnimations() async {
    final playerSpriteSheet = await gameRef.images.load('BoxSmasherIdlePlayer.png');
    final spriteSize = Vector2(32, 32);

    SpriteAnimationData idleData = SpriteAnimationData.sequenced(amount: 4, stepTime: _animationSpeed, textureSize: Vector2(33, 33));

    idleAnimation = SpriteAnimationComponent.fromFrameData(playerSpriteSheet, idleData)
      ..size = spriteSize;
  }
}