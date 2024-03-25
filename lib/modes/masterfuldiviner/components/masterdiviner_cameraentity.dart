import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';

import '../helpers/masterfuldiviner_direction.dart';
import '../masterfuldiviner_game.dart';

class Entity extends PositionComponent with HasGameRef<MasterfulDivinerGame> {
  late final TiledComponent<FlameGame<World>> _map;
  final speed = 30;
  Direction direction = Direction.none;

  Entity({required size, required position,
    required TiledComponent<FlameGame<World>> map})
      : super(size: size, position: position){
    _map = map;
    direction = Direction.none;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    verifyPosition(position);
    moveEntity(dt);
  }

  void verifyPosition(Vector2 position){
    if(position.x > (_map.tileMap.map.width * 16) - 88){
      while(position.x > (_map.tileMap.map.width * 16) - 88){
        position.x--;
      }
    }

    //Set the bounds at the start of map on Y Axis
    if(position.y > (_map.tileMap.map.height * 16 - 85)){
      while(position.y > (_map.tileMap.map.height * 16 - 85)){
        position.y--;
      }
    }

    //Set the bounds at the start of map on X Axis
    if(position.x < 0 + 88){
      while(position.x < 0 + 88){
        position.x++;
      }
    }

    //Set the bounds at the end of map on Y Axis
    if(position.y < 0 + 85){
      while(position.y < 0 + 85){
        position.y++;
      }
    }
  }


  void moveEntity(double dt){
    switch (direction) {
      case Direction.up:
        position.add(Vector2(0, dt * -speed));
        break;
      case Direction.down:
        position.add(Vector2(0, dt * speed));
        break;
      case Direction.left:
        position.add(Vector2(dt * -speed, 0));
        break;
      case Direction.right:
        position.add(Vector2(dt * speed, 0));
        break;
      case Direction.none:
        break;
    }
  }
}