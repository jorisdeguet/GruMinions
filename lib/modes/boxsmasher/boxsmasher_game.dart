import 'dart:ui';

import 'package:flame/cache.dart';
import 'package:flame/camera.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:gru_minions/modes/boxsmasher/components/boxsmasher_background.dart';
import 'package:gru_minions/modes/boxsmasher/components/world/boxsmasher_ground.dart';
import 'components/boxsmasher_player.dart';
import 'components/world/boxsmasher_box.dart';
import 'helpers/direction.dart';

class BoxSmasherGame extends FlameGame with HasCollisionDetection{
  @override
  final images = Images(prefix: 'assets/flame/');

  final BoxSmasherPlayer _player = BoxSmasherPlayer(Vector2(24, 753));

  final double _gravity = 1.5;
  final Vector2 _velocity = Vector2(0, 0);

  BoxSmasherGame();

  @override
  Future<void> onLoad() async {

    super.onLoad();

    add(BoxSmasherBackground());

    _player.priority = 3;
    _player.debugMode = true;
    add(_player);

    final map = await TiledComponent.load('BoxSmasherMap.tmx', Vector2.all(16));
    map.topLeftPosition = Vector2(0, 0);
    map.priority = 1;
    await add(map);

    double mapWidth = map.tileMap.map.width * 16.0;
    double mapHeight = map.tileMap.map.height * 16.0;

    final world = World(children: [_player, map,]);
    await add(world);

    final camera = CameraComponent.withFixedResolution(world: world, width: 110, height: 200);
    camera.debugMode = true;
    final halfViewportSize = camera.viewport.size / 2;
    camera.setBounds(Rectangle.fromCenter(
      center: Vector2(mapWidth, mapHeight) / 2,
      size: Vector2(100,600) - halfViewportSize,),
    );
    camera.follow(_player);
    await add(camera);

    var obstacleGroup = map.tileMap.getLayer<ObjectGroup>('ground');

    for (final obj in obstacleGroup!.objects) {
      final groundObject = Ground(size: Vector2(obj.width, obj.height),
          position: Vector2(obj.x , obj.y) - halfViewportSize);
      groundObject.debugMode = true;
      groundObject.priority = 2;
      add(groundObject);
      world.add(groundObject);
    }

    var boxesGroup = map.tileMap.getLayer<ObjectGroup>('Boxes');

    for ( final obj in boxesGroup!.objects){
      final boxObject = Box(size: Vector2(obj.width, obj.height),
          position: Vector2(obj.x, obj.y) - halfViewportSize)
      ..sprite = await loadSprite('crate.png');
      boxObject.debugMode = true;
      boxObject.priority = 2;
      add(boxObject);
      world.add(boxObject);
    }

  }

  @override
  void update(double dt) {
    super.update(dt);

    if(!_player.onGround) {
      _velocity.y += _gravity;
      _player.position.y += _velocity.y * dt;
    }

    if(_player.y < 784 - _player.height) {
      _velocity.y += _gravity;
      _player.position.y += _velocity.y * dt;
    } else {
      _player.position.y = 784 - _player.height;
      _velocity.y = 0;
    }
  }

  void onAButtonPressed (bool pressed) {
    _player.onPressed = pressed;
  }
}