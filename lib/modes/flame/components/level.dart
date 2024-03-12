import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:gru_minions/modes/flame/components/player.dart';
import 'package:gru_minions/modes/flame/components/traps/falling_platform.dart';
import 'package:gru_minions/modes/flame/components/traps/saw.dart';
import 'package:gru_minions/modes/flame/components/traps/spike_head.dart';
import 'package:gru_minions/modes/flame/components/traps/spikes.dart';
import 'package:gru_minions/modes/flame/components/traps/trampoline.dart';
import 'package:gru_minions/modes/flame/game.dart';

import 'background_tile.dart';
import 'enemies/angry_pig.dart';
import 'enemies/bat.dart';
import 'enemies/mushroom.dart';
import 'enemies/rino.dart';
import 'enemies/slime.dart';
import 'enemies/turtle.dart';
import 'items/box.dart';
import 'items/checkpoint.dart';
import 'collisions_block.dart';
import 'enemies/chicken.dart';
import 'items/end.dart';
import 'items/fruit.dart';
import 'items/start.dart';

class Level extends World with HasGameRef<MainGame> {
  Level({required this.levelName, required this.player});

  final String levelName;
  final Player player;
  List<CollisionBlock> collisionBlocks = [];

  late TiledComponent level;

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load(levelName, Vector2.all(16));
    add(level);

    _scrollBackground();
    _setObjectsPosition();
    _addCollisions();

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
      add(backgroundTile);
    }
  }

  void _setObjectsPosition() {
    final startPointLayer = level.tileMap.getLayer<ObjectGroup>('Startpoints');

    if (startPointLayer != null) {
      for (final spawnPoint in startPointLayer.objects) {
        switch (spawnPoint.class_) {
          case 'Player':
            player.position =
                Vector2(spawnPoint.x, spawnPoint.y); //set player starting position
            player.revivePosition =
                Vector2(spawnPoint.x, spawnPoint.y); //set player revive position
            player.scale.x = 1;
            add(player);
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
          case 'Box':
            final box = Box(
              boxType: spawnPoint.name,
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            add(box);
            break;
          case 'Saw':
            final saw = Saw(
              isVertical: spawnPoint.properties.getValue('isVertical'),
              offNeg: spawnPoint.properties.getValue('offNeg'),
              offPos: spawnPoint.properties.getValue('offPos'),
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            add(saw);
            break;
          case 'Spike Head':
            final spikeHead = SpikeHead(
              //isMoving: spawnPoint.properties.getValue('isMoving'),
              isVertical: spawnPoint.properties.getValue('isVertical'),
              offNeg: spawnPoint.properties.getValue('offNeg'),
              offPos: spawnPoint.properties.getValue('offPos'),
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            add(spikeHead);
            break;
          case 'Spikes':
            final spikes = Spikes(
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            add(spikes);
            break;
          case 'Falling Platform':
            final fallingPlatform = FallingPlatform(
              offNeg: spawnPoint.properties.getValue('offNeg'),
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            add(fallingPlatform);
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
              isWalking: spawnPoint.properties.getValue('isWalking'),
              offNeg: spawnPoint.properties.getValue('offNeg'),
              offPos: spawnPoint.properties.getValue('offPos'),
            );
            add(angryPig);
            break;
          case 'Bat':
            final bat = Bat(
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
              offNeg: spawnPoint.properties.getValue('offNeg'),
              offPos: spawnPoint.properties.getValue('offPos'),
            );
            add(bat);
            break;
          case 'Turtle':
            final turtle = Turtle(
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
              offNeg: spawnPoint.properties.getValue('offNeg'),
              offPos: spawnPoint.properties.getValue('offPos'),
            );
            add(turtle);
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
    player.collisions = collisionBlocks;

  }
}
