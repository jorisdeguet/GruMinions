import 'package:flame/components.dart';

class BoxSmasherPlayer extends SpriteAnimationComponent with HasGameRef{
  final double _playerSpeed = 50.0;
  final double _animationSpeed = 0.1;

  late SpriteAnimationComponent idleAnimation = SpriteAnimationComponent();

  bool onPressed = false;

  BoxSmasherPlayer(Vector2 p)
      : super(
      size: Vector2(32, 32),
      position: p,
  );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    await _loadAnimations().then((_) => {animation = idleAnimation.animation});
  }

  @override
  void update(double delta) {
    super.update(delta);
    _movePlayer(delta);
  }

  Future<void> _loadAnimations() async {
    final playerSpriteSheet = await gameRef.images.load('BoxSmasherIdlePlayer.png');
    final spriteSize = Vector2(32, 32);

    SpriteAnimationData idleData = SpriteAnimationData.sequenced(amount: 4, stepTime: _animationSpeed, textureSize: Vector2(33, 33));

    idleAnimation = SpriteAnimationComponent.fromFrameData(playerSpriteSheet, idleData)
      ..size = spriteSize;
  }

  void _movePlayer(double delta){
    if (onPressed){
      _moveUp(delta);
    }
  }

  void _moveUp(double delta) {
    position.add(Vector2(0, delta * -_playerSpeed));
  }
}