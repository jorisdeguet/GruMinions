import 'dart:ui';

import 'package:flame/cache.dart';
import 'package:flame/camera.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:gru_minions/modes/boxsmasher/components/boxsmasher_background.dart';
import 'components/boxsmasher_player.dart';
import 'helpers/direction.dart';

class BoxSmasherGame extends FlameGame {
  @override
  final images = Images(prefix: 'assets/flame/');

  final BoxSmasherPlayer _player = BoxSmasherPlayer(Vector2(-18, 352));

  BoxSmasherGame();

  @override
  Future<void> onLoad() async {

    super.onLoad();

    add(BoxSmasherBackground());

    _player.priority = 2;
    _player.debugMode = true;
    add(_player);

    final map = await TiledComponent.load('BoxSmasherMap.tmx', Vector2.all(16));
    map.center = Vector2.zero();
    map.priority = 1;
    await add(map);

    final world = World(children: [_player, map]);
    await add(world);

    final camera = CameraComponent.withFixedResolution(world: world, width: 110, height: 250);
    camera.debugMode = true;
    final halfViewportSize = camera.viewport.size / 2;
    camera.setBounds(Rectangle.fromCenter(
      center: Vector2.zero(),
      size: Vector2(80,538) - halfViewportSize,),
    );
    camera.follow(_player);
    await add(camera);

  }

  void onAButtonPressed (bool pressed) {
    _player.onPressed = pressed;
  }
}