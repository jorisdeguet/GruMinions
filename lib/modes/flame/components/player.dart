import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

import '../helpers/direction.dart';

class Player extends SpriteAnimationComponent with HasGameRef {
  final double _playerSpeed = 300.0;
  final double _animationSpeed = 0.15;

  late final SpriteAnimation _runDownAnimation;
  late final SpriteAnimation _runLeftAnimation;
  late final SpriteAnimation _runUpAnimation;
  late final SpriteAnimation _runRightAnimation;
  late final SpriteAnimation _standingAnimation;

  Direction direction = Direction.none;

  Player(Vector2 p)
      : super(
          size: Vector2(42.0, 55.0),
          position: p,
        );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    await _loadAnimations().then((_) => {animation = _standingAnimation});
  }

  @override
  void update(double delta) {
    super.update(delta);
    _movePlayer(delta);
  }

  void _movePlayer(double delta) {
    switch (direction) {
      case Direction.up:
        animation = _runUpAnimation;
        _moveUp(delta);
        break;
      case Direction.down:
        animation = _runDownAnimation;
        _moveDown(delta);
        break;
      case Direction.left:
        animation = _runLeftAnimation;
        _moveLeft(delta);
        break;
      case Direction.right:
        animation = _runRightAnimation;
        _moveRight(delta);
        break;
      case Direction.none:
        animation = _standingAnimation;
        break;
    }
  }

  Future<void> _loadAnimations() async {
    final spriteSheet = SpriteSheet(
      image: await gameRef.images.load('sp_player.png'),
      srcSize: Vector2(84.0, 110.0),
    );

    _runDownAnimation =
        spriteSheet.createAnimation(row: 0, stepTime: _animationSpeed, to: 4);

    _runLeftAnimation =
        spriteSheet.createAnimation(row: 2, stepTime: _animationSpeed, to: 4);

    _runUpAnimation =
        spriteSheet.createAnimation(row: 1, stepTime: _animationSpeed, to: 4);

    _runRightAnimation =
        spriteSheet.createAnimation(row: 3, stepTime: _animationSpeed, to: 4);

    _standingAnimation =
        spriteSheet.createAnimation(row: 0, stepTime: _animationSpeed, to: 1);
  }

  void _moveUp(double delta) {
    position.add(Vector2(0, delta * -_playerSpeed));
  }

  void _moveDown(double delta) {
    position.add(Vector2(0, delta * _playerSpeed));
  }

  void _moveLeft(double delta) {
    position.add(Vector2(delta * -_playerSpeed, 0));
  }

  void _moveRight(double delta) {
    position.add(Vector2(delta * _playerSpeed, 0));
  }
}
