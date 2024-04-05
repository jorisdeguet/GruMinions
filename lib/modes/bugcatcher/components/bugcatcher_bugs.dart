
import 'dart:math';

import 'package:flame/camera.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';

import '../bugcatcher_game.dart';

class BugCatcherBug extends SpriteAnimationComponent with CollisionCallbacks, HasGameRef<BugCatcherGame> {
  // Animation speed
  final double _animationSpeed = 0.1;
  // Bug speed
  final double _bugSpeed = 0.5;
  // Map
  late final TiledComponent<FlameGame<World>> _map;
  // Bug type
  late String bugType;
  // Bug animation
  late SpriteAnimationComponent idleAnimation = SpriteAnimationComponent();
  // Bug direction
  late int direction = Random().nextInt(4);

  //#region BugBounds
  late int maxX;
  late int maxY;
  late int minX;
  late int minY;
  //#endregion

  BugCatcherBug(
      {required position,
        required this.bugType,
        required TiledComponent<FlameGame<World>> map})
      : super(size: Vector2(16, 16), position: position) {
    // Set the map
    _map = map;
    // Set th Anchor to the center
    anchor = Anchor.center;
    /// IMPORTANT : If in need of debugging
    //#region EnablingDebugMode
    //debugMode = true;
    //#endregion
    // Set the bounds of the bug
    //#region BugBoundsSetting

    // Set the bounds at the end of map on X Axis
    maxX = position.x.toInt() + 150;
    if(maxX > (_map.tileMap.map.width * 16) - 10){
      while(maxX > (_map.tileMap.map.width * 16) - 10){
        maxX--;
      }
    }

    //Set the bounds at the start of map on Y Axis
    minY = position.y.toInt() + 150;
    if(minY > (_map.tileMap.map.height * 16 - 20)){
      while(minY > (_map.tileMap.map.height * 16 - 20)){
        minY--;
      }
    }

    //Set the bounds at the start of map on X Axis
    minX = position.x.toInt() - 150;
    if(minX < 0 + 10){
      while(minX < 0 + 10){
        minX++;
      }
    }

    //Set the bounds at the end of map on Y Axis
    maxY = position.y.toInt() - 150;
    if(maxY < 0 + 15){
      while(maxY < 0 + 15){
        maxY++;
      }
    }
    //#endregion
  }

  @override
  Future<void> onLoad() async {
    RectangleHitbox shape = RectangleHitbox();
    shape.collisionType = CollisionType.active;
    add(shape);
    await super.onLoad();
    await _loadAnimations().then((_) => {animation = idleAnimation.animation});
  }

  // The idle animation
  Future<void> _loadAnimations() async {
    final bugSpriteSheet = await gameRef.animations.load('$bugType.png');
    final spriteSize = Vector2(16, 16);

    SpriteAnimationData idleData = SpriteAnimationData.sequenced(
        amount: 4, stepTime: _animationSpeed, textureSize: Vector2(16, 16));

    idleAnimation =
    SpriteAnimationComponent.fromFrameData(bugSpriteSheet, idleData)
      ..size = spriteSize;
  }

  @override
  void onCollision(intersectionPoints, other) {
    super.onCollision(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(other) {
    super.onCollisionEnd(other);
  }

  @override
  void update(double delta) {
    super.update(delta);
    moveInDirection(direction);
  }

  /// Move the bug in the direction
  void moveInDirection(int direction) {
    switch (direction) {
      case 0:
        verifyDirection();
        position.x += _bugSpeed;
        break;
      case 1:
        verifyDirection();
        position.x -= _bugSpeed;
        break;
      case 2:
        verifyDirection();
        position.y -= _bugSpeed;
        break;
      case 3:
        verifyDirection();
        position.y += _bugSpeed;
        break;
    }
  }

  /// Verify if the bug is out of bounds
  void verifyDirection() {
    if (position.x >= maxX) {
      flipHorizontally();
      randomDirection();
      while (direction == 0) {
        randomDirection();
      }
      randomTimer();
      return;
    }
    if (position.x <= minX) {
      flipHorizontally();
      randomDirection();
      while (direction == 1) {
        randomDirection();
      }
      randomTimer();
      return;
    }
    if (position.y <= maxY) {
      flipVertically();
      randomDirection();
      while (direction == 2) {
        randomDirection();
      }
      randomTimer();
      return;
    }
    if (position.y >= minY) {
      flipVertically();
      randomDirection();
      while (direction == 3) {
        randomDirection();
      }
      randomTimer();
      return;
    }
  }

  void randomDirection() {
    direction = Random().nextInt(4);
  }

  void randomTimer(){
    int randomTime = Random().nextInt(5);
    if(randomTime == 0){
      randomTime = 1;
    }
    Future.delayed(Duration(seconds: randomTime), () {
      randomDirection();
    });
  }
}
