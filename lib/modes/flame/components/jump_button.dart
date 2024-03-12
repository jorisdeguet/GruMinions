import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:gru_minions/modes/flame/game.dart';

class JumpButton extends SpriteComponent
    with HasGameRef<MainGame>, TapCallbacks {
  JumpButton();

  final margin = 32;
  final buttonSize = 64;

  @override
  FutureOr<void> onLoad() {
    priority = 10;
    sprite = Sprite(game.images.fromCache('HUD/JumpButton.png'));
    position = Vector2(
      game.size.x - margin - buttonSize,
      game.size.y - margin - buttonSize,
    );
    return super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    game.player.isHasJumped = true;
    super.onTapDown(event);
  }

  @override
  void onTapUp(TapUpEvent event) {
    game.player.isHasJumped = false;
    super.onTapUp(event);
  }
}