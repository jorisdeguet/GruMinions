import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';

class MasterfulDivinerGame extends FlameGame with HasCollisionDetection, KeyboardEvents{
  @override
  final images = Images(prefix: 'assets/masterfuldiviner/flame/furnitures/');
  final animations = Images(prefix: 'assets/masterfuldiviner/animations/');

  late PositionComponent cameraEntity;
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

  MasterfulDivinerGame(){
    interval = Timer(1,
      onTick: () => elapsedSeconds--,
      repeat: true,);
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();

    //#region MapSetup
    final map = await TiledComponent.load('MasterfulDivinerScenario_1_1.tmx', Vector2.all(16));
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

    // cameraEntity = Entity(size: Vector2(16, 16), position: Vector2(mapWidth, mapHeight) / 2, map: map);
    // cameraEntity.priority = 11;
    // await add(cameraEntity);
    // world.add(cameraEntity);

    final halfViewportSize = camera.viewport.size / 2;
    camera.setBounds(
      Rectangle.fromCenter(
        center: Vector2(mapWidth, mapHeight) / 2,
        size: Vector2(mapWidth - 175, mapHeight - 160) - halfViewportSize,
      ),
    );
    _map = map;
    //camera.follow(cameraEntity);
    camera.moveTo(Vector2(mapWidth / 2, mapHeight / 2));
    await add(camera);
    //#endregion

    //#region BugSetup
    // var allBugs = map.tileMap.getLayer<ObjectGroup>('Bugs')?.objects;
    //
    // if (allBugs != null) {
    //   for (var bug in allBugs) {
    //
    //     BugTypes name =  BugTypes.values[int.parse(bug.name)];
    //     var bugPosition = Vector2(bug.x, bug.y - bug.height);
    //     var bugComponent = MasterfulDivinerBug(position: bugPosition, bugType: name.toString(), map: map);
    //
    //     bugComponent.priority = 2;
    //     await add(bugComponent);
    //     world.add(bugComponent);
    //   }
    // }
    //#endregion

    //#region FurnitureSetup
    // var allFurniture = map.tileMap.getLayer<ObjectGroup>('Furniture')?.objects;
    //
    // if (allFurniture != null) {
    //   for (var furniture in allFurniture) {
    //     var furniturePosition = Vector2(furniture.x, furniture.y - furniture.height);
    //     var furnitureSize = Vector2(furniture.width, furniture.height);
    //     var name = furniture.name;
    //
    //     var furnitureComponent = Furniture(size: furnitureSize, position: furniturePosition)
    //       ..sprite = await loadSprite('$name.png');
    //
    //     furnitureComponent.priority = 3;
    //     await add(furnitureComponent);
    //     world.add(furnitureComponent);
    //   }
    // }
    //#endregion

  }

  @override
  void update(double dt) {
    super.update(dt);
    if(elapsedSeconds == 0){
      interval.stop();
      //overlays.add(GameOver.iD);
    } else {
      interval.update(dt);
    }
  }

  //#region InputsFromUser

  void onAButtonPressed(bool pressed) {}
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
}