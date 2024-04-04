import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame_tiled/flame_tiled.dart';
import '../components/enemies/plant.dart';
import '../components/traps/fire.dart';
import '../helpers/background_tile.dart';
import '../components/enemies/mushroom.dart';
import '../components/enemies/rino.dart';
import '../components/enemies/slime.dart';
import '../components/items/end.dart';
import '../components/items/start.dart';
import '../components/player.dart';
import '../components/traps/saw.dart';
import '../components/traps/spikes.dart';
import '../components/traps/trampoline.dart';
import '../game/pixel_adventure.dart';

import 'enemies/angryPig.dart';
import 'enemies/radish.dart';
import 'enemies/trunk.dart';
import 'items/checkpoint.dart';
import '../helpers/collisions_block.dart';
import 'enemies/chicken.dart';
import 'items/coin.dart';
import 'items/fruit.dart';

class Level extends World with HasGameRef<PixelAdventure> {
  Level({required this.levelName, required this.player1, required this.player2});

  final String levelName;
  final Player player1;
  final Player player2;
  List<CollisionBlock> collisionBlocks = [];

  late TiledComponent level;

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load(levelName, Vector2.all(16));
    add(level);

    _scrollBackground();
    _setObjectsPosition();
    _addCollisions();
    _setupCamera();

    return super.onLoad();
  }

  void _scrollBackground() {
    final backgroundLayer = level.tileMap.getLayer('Background');

    if (backgroundLayer != null) {
      final backgroundColor =
          backgroundLayer.properties.getValue('BackgroundColor');
      final backgroundTile = BackgroundTile(
        color: backgroundColor ?? 'Gray',
        position: Vector2(0, 0),
      );
      game.cam.backdrop = backgroundTile;
    }
  }

  void _setObjectsPosition() {
    final startPointLayer =
        level.tileMap.getLayer<ObjectGroup>('StartingPoints');

    if (startPointLayer != null) {
      for (final spawnPoint in startPointLayer.objects) {
        switch (spawnPoint.class_) {
          case 'Player1':
            player1.position = Vector2(
                spawnPoint.x, spawnPoint.y); //set player starting position
            player1.revivePosition = Vector2(
                spawnPoint.x, spawnPoint.y); //set player revive position
            player1.scale.x = 1;
            add(player1);
            break;
          case 'Player2':
            player2!.position = Vector2(
                spawnPoint.x, spawnPoint.y); //set player starting position
            player2!.revivePosition = Vector2(
                spawnPoint.x, spawnPoint.y); //set player revive position
            player2!.scale.x = 1;
            add(player2!);
            break;
          case 'Start':
            final start = Start(
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            add(start);
            break;
          case 'Checkpoint':
            final checkpoint = Checkpoint(
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            add(checkpoint);
            break;
          case 'End':
            final end = End(
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            add(end);
          case 'Fruit':
            final fruit = Fruit(
              fruitType: spawnPoint.name,
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            add(fruit);
            break;
          case 'Coin':
            final coin = Coin(
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            add(coin);
            break;
          case 'Saw':
            final saw = Saw(
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
              isVertical: spawnPoint.properties.getValue('isVertical'),
              offNeg: spawnPoint.properties.getValue('offNeg'),
              offPos: spawnPoint.properties.getValue('offPos'),
            );
            add(saw);
            break;
          case 'Spikes':
            final spikes = Spikes(
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
              isFacingUp: spawnPoint.properties.getValue('isFacingUp'),
            );
            add(spikes);
            break;
          case 'Fire':
            final fire = Fire(
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
              offNeg: spawnPoint.properties.getValue('offNeg'),
              offPos: spawnPoint.properties.getValue('offPos'),
              isFacingUp: spawnPoint.properties.getValue('isFacingUp'),
            );
            add(fire);
            break;
          case 'Trampoline':
            final trampoline = Trampoline(
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            add(trampoline);
            break;
          case 'Chicken':
            final chicken = Chicken(
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
              offNeg: spawnPoint.properties.getValue('offNeg'),
              offPos: spawnPoint.properties.getValue('offPos'),
            );
            add(chicken);
            break;
          case 'Mushroom':
            final mushroom = Mushroom(
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
              offNeg: spawnPoint.properties.getValue('offNeg'),
              offPos: spawnPoint.properties.getValue('offPos'),
            );
            add(mushroom);
            break;
          case 'Radish':
            final radish = Radish(
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
              offNeg: spawnPoint.properties.getValue('offNeg'),
              offPos: spawnPoint.properties.getValue('offPos'),
            );
            add(radish);
            break;
          case 'Rino':
            final rino = Rino(
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
              offNeg: spawnPoint.properties.getValue('offNeg'),
              offPos: spawnPoint.properties.getValue('offPos'),
            );
            add(rino);
            break;
          case 'Slime':
            final slime = Slime(
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
              offNeg: spawnPoint.properties.getValue('offNeg'),
              offPos: spawnPoint.properties.getValue('offPos'),
            );
            add(slime);
            break;
          case 'AngryPig':
            final angryPig = AngryPig(
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
              offNeg: spawnPoint.properties.getValue('offNeg'),
              offPos: spawnPoint.properties.getValue('offPos'),
            );
            add(angryPig);
            break;
          case 'Plant':
            final plant = Plant(
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
              offNeg: spawnPoint.properties.getValue('offNeg'),
              offPos: spawnPoint.properties.getValue('offPos'),
              isFacingRight: spawnPoint.properties.getValue('isFacingRight'),
            );
            add(plant);
            break;
          case 'Trunk':
            final trunk = Trunk(
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
              offNeg: spawnPoint.properties.getValue('offNeg'),
              offPos: spawnPoint.properties.getValue('offPos'),
              isFacingRight: spawnPoint.properties.getValue('isFacingRight'),
            );
            add(trunk);
            break;
          default:
        }
      }
    }
  }

  void _addCollisions() {
    final collisionsLayer = level.tileMap.getLayer<ObjectGroup>('Collisions');
    if (collisionsLayer != null) {
      for (final collision in collisionsLayer.objects) {
        switch (collision.class_) {
          case 'Platform':
            final platform = CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
              isPlatform: true,
            );
            collisionBlocks.add(platform);
            add(platform);
            break;
          default:
            final block = CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
            );
            collisionBlocks.add(block);
            add(block);
        }
      }
    }
    player1.collisions = collisionBlocks;
  }

  void _setupCamera() {
    double left = level.width - (640 / 2);
    double top = size.y * 9 / 2;
    double right = size.x * 4 / 2;
    double bottom = level.height - (360 / 2);

    game.cam.setBounds(Rectangle.fromLTRB(
      left,
      top,
      right,
      bottom,
    ));
  }

  Vector2 get size => Vector2(
      level.tileMap.map.width.toDouble(), level.tileMap.map.height.toDouble());
}
