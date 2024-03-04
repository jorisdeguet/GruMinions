import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:gru_minions/modes/flame/components/player.dart';

import 'collisions_block.dart';

class Level extends World {
  Level({required this.levelName, required this.player}){debugMode = true;}
  final String levelName;
  final Player player;
  List<CollisionBlock> collisionBlocks = [];

  late TiledComponent level;
  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load(levelName, Vector2.all(16));

    add(level);

    //_scrollBackground();

    final startPointLayer = level.tileMap.getLayer<ObjectGroup>('Startpoint');

    if(startPointLayer != null){
      for(final spawnPoint in startPointLayer.objects) {
        switch (spawnPoint.class_){
          case 'Player':
            player.position = Vector2(spawnPoint.x, spawnPoint.y); //set player position
            add(player);
            break;
          default:
        }
      }
    }

    final collisionsLayer = level.tileMap.getLayer<ObjectGroup>('Collisions');
    if(collisionsLayer != null){
      for(final collision in collisionsLayer.objects){
        switch(collision.class_) {
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

    return super.onLoad();
  }
}