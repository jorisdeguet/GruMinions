import 'package:flame/cache.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:gru_minions/modes/flame.dart';

import 'helpers/direction.dart';
import 'components/player.dart';

class MainGame extends FlameGame with KeyboardEvents {

  @override
  final images = Images(prefix: 'assets/flame/');

  final Player _player = Player(Vector2(100,100));

  final Player _player2 = Player(Vector2(100,200));

  MainGame();

  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(_player);
    add(_player2);
  }

  @override
  KeyEventResult onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final isKeyDown = event is RawKeyDownEvent;
    Direction? keyDirection = null;

    if (event.logicalKey == LogicalKeyboardKey.keyA) {
      keyDirection = Direction.left;
    } else if (event.logicalKey == LogicalKeyboardKey.keyD) {
      keyDirection = Direction.right;
    } else if (event.logicalKey == LogicalKeyboardKey.keyW) {
      keyDirection = Direction.up;
    } else if (event.logicalKey == LogicalKeyboardKey.keyS) {
      keyDirection = Direction.down;
    }

    if (isKeyDown && keyDirection != null) {
      _player.direction = keyDirection;
    } else if (_player.direction == keyDirection) {
      _player.direction = Direction.none;
    }

    return super.onKeyEvent(event, keysPressed);
  }

  void onJoyPad1DirectionChanged(Direction direction) {
    _player.direction = direction;
  }
  void onJoyPad2DirectionChanged(Direction direction) {
    _player2.direction = direction;
  }
}
