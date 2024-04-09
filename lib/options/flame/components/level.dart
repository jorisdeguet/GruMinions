import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/services.dart';
import '../components/enemies/plant.dart';
import '../components/traps/fire.dart';
import '../helpers/background_tile.dart';
import '../components/enemies/mushroom.dart';
import '../components/enemies/slime.dart';
import '../components/items/end.dart';
import '../components/player.dart';
import '../components/traps/saw.dart';
import '../components/traps/spikes.dart';
import '../components/traps/trampoline.dart';
import '../game/pixel_adventure.dart';

import 'friend.dart';
import 'items/checkpoint.dart';
import '../helpers/collisions_block.dart';
import 'enemies/chicken.dart';
import 'items/fruit.dart';

class Level extends World with KeyboardHandler, HasGameRef<PixelAdventure> {
  final String levelName;
  final Player player;
  final Friend? friend;

  Level({
    required this.levelName,
    required this.player,
    this.friend,
  });

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

    //player 2 can be null, so we need to check
    //if player 2 is not null we set the friend position
    if (friend != null) _setFriendPosition();

    return super.onLoad();
  }

  @override
  void update(double dt) {
    //update camera position
    //depending on the number of players
    if (friend != null) {
      if (player.position.x > friend!.position.x) {
        game.cam.follow(player);
      } else if (player.position.x < friend!.position.x) {
        game.cam.follow(friend!);
      }
    }
    super.update(dt);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    //Player 1 is never null, so no need to check
    player.directionX = 0;

    final isKeyLeftPressed = keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isKeyRightPressed =
    keysPressed.contains(LogicalKeyboardKey.arrowRight);

    player.directionX = isKeyLeftPressed ? -1 : 0;
    player.directionX += isKeyRightPressed ? 1 : 0;
    player.isJumping = keysPressed.contains(LogicalKeyboardKey.arrowUp);

    //Player 2 can be null, so we need to check
    //if it is not null, we set the direction
    if (friend != null) {
      friend!.directionX = 0;

      final isKeyLeftPressed2 = keysPressed.contains(LogicalKeyboardKey.keyA);
      final isKeyRightPressed2 = keysPressed.contains(LogicalKeyboardKey.keyD);

      friend!.directionX = isKeyLeftPressed2 ? -1 : 0;
      friend!.directionX += isKeyRightPressed2 ? 1 : 0;
      friend!.isJumping = keysPressed.contains(LogicalKeyboardKey.keyW);
    }

    return super.onKeyEvent(event, keysPressed);
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
    final startingPoints =
    level.tileMap.getLayer<ObjectGroup>('StartingPoints');

    if (startingPoints != null) {
      for (final spawnPoint in startingPoints.objects) {
        switch (spawnPoint.class_) {
          case 'Player1':
            player.position = Vector2(
                spawnPoint.x, spawnPoint.y); //set player starting position
            player.revivePosition = Vector2(
                spawnPoint.x, spawnPoint.y); //set player revive position
            player.scale.x = 1;
            add(player);
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
          case 'Slime':
            final slime = Slime(
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
              offNeg: spawnPoint.properties.getValue('offNeg'),
              offPos: spawnPoint.properties.getValue('offPos'),
            );
            add(slime);
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
          default:
        }
      }
    }
  }

  void _setFriendPosition() {
    final startingPoints =
    level.tileMap.getLayer<ObjectGroup>('StartingPoints');

    if (startingPoints != null) {
      for (final spawnPoint in startingPoints.objects) {
        switch (spawnPoint.class_) {
          case 'Player2':
            friend!.position = Vector2(
                spawnPoint.x, spawnPoint.y); //set player starting position
            friend!.scale.x = 1;
            add(friend!);
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

    //Player 2 can be null, so we need to check
    if (friend != null) friend!.collisions = collisionBlocks;
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
