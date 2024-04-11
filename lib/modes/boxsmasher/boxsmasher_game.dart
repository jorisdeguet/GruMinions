import 'package:flame/cache.dart';
import 'package:flame/camera.dart';
import 'package:flame/experimental.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'package:gru_minions/modes/boxsmasher/components/world/boxsmasher_background.dart';
import 'package:gru_minions/modes/boxsmasher/components/world/boxsmasher_door.dart';
import 'package:gru_minions/modes/boxsmasher/components/world/boxsmasher_ground.dart';
import 'components/world/boxsmasher_movingbox.dart';
import 'components/world/boxsmasher_player.dart';
import 'components/world/boxsmasher_box.dart';
import 'overlays/lose.dart';
import 'overlays/win.dart';

class BoxSmasherGame extends FlameGame with HasCollisionDetection {
  @override
  final images = Images(prefix: 'assets/boxsmasher/flame/');
  final BoxSmasherPlayer _player = BoxSmasherPlayer(Vector2(0, 0));
  late MovingBox _boxMoving;
  late CameraComponent _camera;
  int score = 0;
  final TextPaint textPaint = TextPaint(
    style: const TextStyle(color: Colors.white, fontSize: 42, shadows: [
      Shadow(
        blurRadius: 15,
        color: Color(0xff000000),
        offset: Offset(0, 0),
      ),
    ]),
  );

  BoxSmasherGame();

  @override
  Future<void> onLoad() async {
    super.onLoad();

    //#region PlayerSetup
    //Replace player to be on top of the ground
    _player.y -= _player.height;
    //Set priority to 4 to be on top of the map
    _player.priority = 5;
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

    //Get the map width and height
    double mapWidth = map.tileMap.map.width * 16.0;
    double mapHeight = map.tileMap.map.height * 16.0;

    //#region CameraSetup
    //Make the camera with a fixed resolution
    final camera = CameraComponent.withFixedResolution(world: world, width: 265, height: 200);

    _player.position = Vector2(mapWidth / 2  - 35, mapHeight / 2);

    //Set the camera bounds
    final halfViewportSize = camera.viewport.size / 2;
    camera.setBounds(
      Rectangle.fromCenter(
        center: Vector2(mapWidth, mapHeight) / 2,
        size: Vector2(mapWidth - 250, mapHeight - 150) - halfViewportSize,
      ),
    );

    //Follow the player
    camera.moveTo(Vector2(3000, 3000));
    //Add the camera to the game
    _camera = camera;
    await add(camera);
    //#endregion

    //#region GroundSetup
    //Get the ground object from the map
    var ground = map.tileMap.getLayer<ObjectGroup>('ground')?.objects.first;
    //Create the ground object
      final groundObject = Ground(
          size: Vector2(ground!.width, ground.height),
          position: Vector2(ground.x, ground.y) - halfViewportSize);
      add(groundObject);
      //Add the ground to the world
      world.add(groundObject);
    //#endregion

    //#region BoxSetup
    //Get the boxes object from the map
    var boxesGroup = map.tileMap.getLayer<ObjectGroup>('Boxes');

    //Create the boxes objects
    for (final obj in boxesGroup!.objects) {
      final boxObject = Box(
          size: Vector2(obj.width, obj.height),
          position: Vector2(obj.x, obj.y - obj.height) - halfViewportSize)
        ..sprite = await loadSprite('boxsmasher_boxes.png');
      //Set priority to 4 to be visible
      boxObject.priority = 4;
      //Add the box to the game
      add(boxObject);
      //Add the box to the world (This makes it visible in game)
      world.add(boxObject);
    }
    //#endregion

    //#region MovingBoxSetup
    //Get the moving box object from the map
    var movingBox = map.tileMap.getLayer<ObjectGroup>('trueBox')?.objects.first;

    //Create the moving box object
    final movingBoxObject = MovingBox(
        size: Vector2(movingBox!.width, movingBox.height),
        position: Vector2(movingBox.x, movingBox.y - movingBox.height) - halfViewportSize)
      ..sprite = await loadSprite('boxsmasher_boxes.png');
    //Priority 3 to be behind the other boxes
    movingBoxObject.priority = 3;
    //Add the moving box to the game
    add(movingBoxObject);
    //Add the moving box to the world (This makes it visible in game)
    world.add(movingBoxObject);
    _boxMoving = movingBoxObject;
    //#endregion

    //#region DoorSetup
    //Get the door object from the map
    var door = map.tileMap.getLayer<ObjectGroup>('door')?.objects.first;

    //Create the door object
    final doorObject = Door(
        size: Vector2(door!.width, door.height),
        position: Vector2(door.x, door.y - door.height) - halfViewportSize)
      ..sprite = await loadSprite('boxsmasher_door.png');
    //Same priority as the boxes
    doorObject.priority = 4;
    //Add the door to the game
    add(doorObject);
    //Add the door to the world (This makes it visible in game)
    world.add(doorObject);
    //#endregion

    //Add the background to the game

    BoxSmasherBackground background = BoxSmasherBackground(this);
    world.add(background);
    add(background);
  }

  @override
  void update(double dt) {
    super.update(dt);
  }

  void onAButtonPressed(bool pressed) {
    if(pressed){
      score++;
    }
    _player.onPressed = pressed;
    _boxMoving.onPressed = pressed;
  }

  void winning(){
    overlays.add(Win.iD);
  }

  void losing(){
    overlays.add(Lose.iD);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    textPaint.render(
      canvas,
      'Score: $score',
      Vector2(_camera.viewport.size.x / 3, 10),
    );
  }
}
