
import 'dart:math';

import 'package:flame/cache.dart';
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame/timer.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'components/bugcatcher_bugs.dart';
import 'components/bugcatcher_cameraentity.dart';
import 'components/bugytpes.dart';
import 'helpers/bugcatcher_direction.dart';
import 'overlays/game_over.dart';
import 'overlays/instructions.dart';

class BugCatcherGame extends FlameGame with HasCollisionDetection, HasGameRef<FlameGame<World>>{
  @override
  set images(Images images) {

    images = Images(prefix: 'assets/bugcatcher/flame/furnitures/');
  }
  final animations = Images(prefix: 'assets/bugcatcher/animations/');
  late Entity _cameraEntity;
  late CameraComponent _camera;
  late TiledComponent<FlameGame<World>> _map;
  late Timer interval;
  late AudioPool pool;
  @override
  late World world = World();
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
  int count = 0;

  BugCatcherGame(){
    interval = Timer(1,
      onTick: () => elapsedSeconds--,
      repeat: true,);
    resumeEngine();
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    pauseEngine();
    overlays.add(Instructions.iD);
    final map = await TiledComponent.load('BugCatcherScenario_1_1.tmx', Vector2.all(16));
    await loadObjects(map);

    startBgmMusic();
  }

  void startBgmMusic(){
    FlameAudio.bgm.initialize();
    FlameAudio.bgm.play('bugcatcher/bugcatcher_bgm.mp3');
  }

  @override
  void update(double dt) {
    super.update(dt);
    if(elapsedSeconds <= 0){
      interval.stop();
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
      count++;
    }
  }

  void onBButtonPressed(bool pressed) {
    if(pressed) {
      count--;
    }
  }
  //#endregion

  Future<void> resetGame() async {
    count = 0;
    elapsedSeconds = 15;
    overlays.add(Instructions.iD);
    await resetObjects(_map);
    await randomBugAdd(_map);
    pauseEngine();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    textPaint.render(
      canvas,
      '$elapsedSeconds',
      Vector2(_camera.viewport.size.x / 1.3, _camera.viewport.size.y / 2.2),
    );
    textPaint.render(
      canvas,
      'Count: $count',
      Vector2(_camera.viewport.size.x / 1.5, 10),
    );
  }

  Future<void> resetObjects(TiledComponent<FlameGame<World>> map) async {
    //#region MapSetup

    // Get the custom properties from the map
    numberOfBugsToFind = 0;
    numberTypeBugToFind = Random().nextInt(15);
    map.topLeftPosition = Vector2(0, 0);
    map.priority = 1;

    world.children.toList().forEach((element) {
      if(element is BugCatcherBug){
        element.removeFromParent();
      }
    });
  }

  Future<void> loadObjects(TiledComponent<FlameGame<World>> map) async {
    resumeEngine();
    //#region MapSetup

    // Get the custom properties from the map
    numberOfBugsToFind = 0;
    numberTypeBugToFind = Random().nextInt(15);
    map.topLeftPosition = Vector2(0, 0);
    map.priority = 1;
    //await add(map);

    //#endregion

    //#region WorldSetup
    world = World(children: [map,]);
    await add(world);
    //#endregion

    //#region CameraSetup
    final camera = CameraComponent.withFixedResolution(world: world, width: 150, height: 150);
    double mapWidth = map.tileMap.map.width * 16.0;
    double mapHeight = map.tileMap.map.height * 16.0;

    _cameraEntity = Entity(size: Vector2(16, 16), position: Vector2(mapWidth, mapHeight) / 2, map: map);
    _cameraEntity.priority = 11;
    _camera = camera;
    //await add(_cameraEntity);
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
    await randomBugAdd(map);

  }

  Future<void> randomBugAdd(TiledComponent<FlameGame<World>> map) async {
    //#region RandomBugSetup
    for (int i = 0; i <= 20; i++) {
      var randomX = Random().nextInt(map.tileMap.map.width - 5);
      var randomY = Random().nextInt(map.tileMap.map.height - 5);
      if(randomX < 3){
        randomX = 3;
      }
      if(randomY < 3){
        randomY = 3;
      }
      var bugPosition = Vector2(randomX * 16.0, randomY * 16.0);
      var randomTypeNumber = Random().nextInt(15);
      String name = BugTypes.values[randomTypeNumber].toString();
      if(randomTypeNumber == numberTypeBugToFind){
        numberOfBugsToFind++;
      }
      var bugComponent = BugCatcherBug(position: bugPosition, bugType: name, map: map);
      bugComponent.priority = 2;
      world.add(bugComponent);
    }
    //#endregion
  }
}