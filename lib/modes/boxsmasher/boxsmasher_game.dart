import 'package:flame/cache.dart';
import 'package:flame/camera.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:gru_minions/modes/boxsmasher/components/world/boxsmasher_background.dart';
import 'package:gru_minions/modes/boxsmasher/components/world/boxsmasher_ground.dart';
import 'components/world/boxsmasher_player.dart';
import 'components/world/boxsmasher_box.dart';

class BoxSmasherGame extends FlameGame with HasCollisionDetection {
  @override
  final images = Images(prefix: 'assets/boxsmasher/flame/');
  final BoxSmasherPlayer _player = BoxSmasherPlayer(Vector2(105, 785));

  BoxSmasherGame();

  @override
  Future<void> onLoad() async {
    super.onLoad();

    //#region PlayerSetup
    //Set priority to 4 to be on top of the map
    _player.priority = 4;
    //Add the player to the game
    add(_player);
    //#endregion

    //#region MapSetup
    //Load the map asset
    final map = await TiledComponent.load('BoxSmasherMap.tmx', Vector2.all(16));
    //Set the position of the top left corner of the map
    map.topLeftPosition = Vector2(0, 0);
    //Set priority to 1 to be behind the player
    map.priority = 1;
    await add(map);
    //#endregion

    //# region WorldSetup
    final world = World(children: [_player, map,]);
    await add(world);
    //#endregion

    //#region CameraSetup
    //Make the camera with a fixed resolution
    final camera = CameraComponent.withFixedResolution(world: world, width: 156, height: 250);

    //Get the map width and height
    double mapWidth = map.tileMap.map.width * 16.0;
    double mapHeight = map.tileMap.map.height * 16.0;

    //Set the camera bounds
    final halfViewportSize = camera.viewport.size / 2;
    camera.setBounds(
      Rectangle.fromCenter(
        center: Vector2(mapWidth, mapHeight) / 1.5,
        size: Vector2(250, 566) - halfViewportSize,
      ),
    );

    //Follow the player
    camera.follow(_player);
    //Add the camera to the game
    await add(camera);
    //#endregion

    //#region GroundSetup
    var ground = map.tileMap.getLayer<ObjectGroup>('ground')?.objects.first;
      final groundObject = Ground(
          size: Vector2(ground!.width, ground.height),
          position: Vector2(ground.x, ground.y) - halfViewportSize);
      add(groundObject);
      //Add the ground to the world
      world.add(groundObject);
    //#endregion

    var boxesGroup = map.tileMap.getLayer<ObjectGroup>('Boxes');

    for (final obj in boxesGroup!.objects) {
      final boxObject = Box(
          size: Vector2(obj.width, obj.height),
          position: Vector2(obj.x, obj.y - obj.height) - halfViewportSize)
        ..sprite = await loadSprite('boxsmasher_boxes.png');
      boxObject.debugMode = true;
      boxObject.priority = 4;
      add(boxObject);
      world.add(boxObject);
    }

    var door = map.tileMap.getLayer<ObjectGroup>('door')?.objects.first;

    final doorObject = Box(
        size: Vector2(door!.width, door.height),
        position: Vector2(door.x, door.y - door.height) - halfViewportSize)
      ..sprite = await loadSprite('boxsmasher_door.png');
    doorObject.debugMode = true;
    doorObject.priority = 4;
    add(doorObject);
    world.add(doorObject);

    add(BoxSmasherBackground());
  }

  @override
  void update(double dt) {
    super.update(dt);
  }

  void onAButtonPressed(bool pressed) {
    _player.onPressed = pressed;
    // TODO: Add box
  }
}
