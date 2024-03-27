

import 'package:flame/cache.dart';
import 'package:flame/camera.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame/timer.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';

import 'components/bugcatcher_bugs.dart';
import 'components/bugcatcher_cameraentity.dart';
import 'components/bugytpes.dart';
import 'helpers/bugcatcher_direction.dart';
import 'overlays/game_over.dart';

class BugCatcherGame extends FlameGame with HasCollisionDetection{
  @override
  set images(Images images) {

    images = Images(prefix: 'assets/bugcatcher/flame/furnitures/');
  }
  final animations = Images(prefix: 'assets/bugcatcher/animations/');

  late Entity _cameraEntity;
  late TiledComponent<FlameGame<World>> _map;
  late Timer interval;
  final TextPaint textPaint = TextPaint(
    style: const TextStyle(color: Colors.white, fontSize: 42, shadows: [
      Shadow(
        blurRadius: 15,
        color: Color(0xff000000),
        offset: Offset(0, 0),
      ),
    ]),
  );
  int elapsedSeconds = 15;
  int numberOfBugsToFind = 0;
  int numberTypeBugToFind = 0;
  int counter = 0;

  BugCatcherGame(){
    interval = Timer(1,
      onTick: () => elapsedSeconds--,
      repeat: true,);
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();

    //#region MapSetup
    final map = await TiledComponent.load('BugCatcherScenario_1_1.tmx', Vector2.all(16));
    // Get the custom properties from the map
    numberOfBugsToFind = map.tileMap.map.properties.byName['NumberOfBugsToFind']!.value as int;
    numberTypeBugToFind = map.tileMap.map.properties.byName['NumberTypeBugToFind']!.value as int;
    map.topLeftPosition = Vector2(0, 0);
    map.priority = 1;
    await add(map);

    //#endregion

    //#region WorldSetup
    final world = World(children: [map,]);
    await add(world);
    //#endregion

    //#region CameraSetup
    final camera = CameraComponent.withFixedResolution(world: world, width: 150, height: 150);
    double mapWidth = map.tileMap.map.width * 16.0;
    double mapHeight = map.tileMap.map.height * 16.0;

    _cameraEntity = Entity(size: Vector2(16, 16), position: Vector2(mapWidth, mapHeight) / 2, map: map);
    _cameraEntity.priority = 11;
    await add(_cameraEntity);
    world.add(_cameraEntity);

    final halfViewportSize = camera.viewport.size / 2;
    camera.setBounds(
      Rectangle.fromCenter(
        center: Vector2(mapWidth, mapHeight) / 2,
        size: Vector2(mapWidth - 175, mapHeight - 160) - halfViewportSize,
      ),
    );
    _map = map;
    camera.follow(_cameraEntity);
    await add(camera);
    //#endregion

    //#region BugSetup
    var allBugs = map.tileMap.getLayer<ObjectGroup>('Bugs')?.objects;

    if (allBugs != null) {
      for (var bug in allBugs) {

        BugTypes name =  BugTypes.values[int.parse(bug.name)];
        var bugPosition = Vector2(bug.x, bug.y - bug.height);
        var bugComponent = BugCatcherBug(position: bugPosition, bugType: name.toString(), map: map);

        bugComponent.priority = 2;
        await add(bugComponent);
        world.add(bugComponent);
      }
    }
    //#endregion

  }

  @override
  void update(double dt) {
    super.update(dt);
    if(elapsedSeconds == 0){
      interval.stop();
      pauseEngine();
      overlays.add(GameOver.iD);
    } else {
      interval.update(dt);
    }
  }

  //#region InputsFromUser
  void onJoyPad1DirectionChanged(Direction direction) {
    _cameraEntity.direction = direction;
  }

  void onAButtonPressed(bool pressed) {
    if(pressed) {
      counter++;
    }
  }

  void onBButtonPressed(bool pressed) {
    if(pressed) {
      counter--;
    }
  }
  //#endregion

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    textPaint.render(
      canvas,
      '$elapsedSeconds',
      Vector2((_map.tileMap.map.width * 25), (_map.tileMap.map.height * 18)),
    );
  }

  void onAButtonPressedDuringGameOver(pressed) {
    overlays.remove(GameOver.iD);
  }
}