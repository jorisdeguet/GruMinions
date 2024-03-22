import 'package:flame/cache.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'components/player.dart';
import 'helpers/direction.dart';

class MainGame extends FlameGame with KeyboardEvents {
  @override
  final images = Images(prefix: 'assets/flame/');

  final Player _player = Player(Vector2(100, 100));

  final Player _player2 = Player(Vector2(100, 200));

  MainGame();

  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(_player);
    add(_player2);
  }

  @override
  KeyEventResult onKeyEvent(
      KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final isKeyDown = event is KeyDownEvent;
    Direction? keyDirection;

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

  //Minion
  void onJoyPad1DirectionChanged(Direction direction) {
    _player.direction = direction;
  }

  //Gru
  void onJoyPad2DirectionChanged(Direction direction) {
    _player2.direction = direction;
  }

  void onAButtonPressed(bool isPressed) {
    if (isPressed) {
      _player.direction = Direction.right;
    } else {
      _player.direction = Direction.none;
    }
  }

  void onBButtonPressed(bool isPressed) {
    if (isPressed) {
      _player.direction = Direction.left;
    } else {
      _player.direction = Direction.none;
    }
  }
}
