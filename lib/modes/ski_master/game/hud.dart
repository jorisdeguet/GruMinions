import 'dart:async';
import 'dart:math';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart' hide Viewport;

import 'actors/player.dart';


class Hud extends PositionComponent with ParentIsA<Viewport>, HasGameReference {
  Hud({
    required Sprite playerSprite,
    required Sprite snowmanSprite,
    required this.player,
    this.onPausePressed,
  })  : _player = SpriteComponent(
    sprite: playerSprite,
    anchor: Anchor.center,
  ),
        _snowman = SpriteComponent(
          sprite: snowmanSprite,
          anchor: Anchor.center,
        );

  final _life = TextComponent(
    text: 'x3',
    anchor: Anchor.centerLeft,
    textRenderer: TextPaint(
      style: const TextStyle(
        color: Colors.black,
        fontSize: 10,
      ),
    ),
  );

  final _score = TextComponent(
    text: 'x0',
    anchor: Anchor.centerLeft,
    textRenderer: TextPaint(
      style: const TextStyle(
        color: Colors.black,
        fontSize: 10,
      ),
    ),
  );

  final SpriteComponent _player;
  final SpriteComponent _snowman;

  //late final JoystickComponent? _joystick;
  final Player player;
  final VoidCallback? onPausePressed;

  late Timer intervalCountdown;
  int elapsedSecs = 3;
  late Timer goDisplayTimer;


  //TextPaint for the border (stroke)
  final TextPaint strokeTextPaint = TextPaint(
    style: TextStyle(
      fontSize: 48.0,
      foreground: Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..color = Colors.black,
    ),
  );

//TextPaint for the main text
  final TextPaint textPaint = TextPaint(
    style: const TextStyle(
      fontSize: 48.0,
      color: Colors.white,
    ),
  );

  @override
  Future<void> onLoad() async {
    goDisplayTimer = Timer(0.5, repeat: false);
    intervalCountdown = Timer(
      1,
      onTick: () => elapsedSecs--,
      repeat: true,
    );

    _player.position.setValues(
      16,
      15,
    );

    _life.position.setValues(
      _player.position.x + 8,
      _player.position.y,
    );

    _snowman.position.setValues(
      parent.virtualSize.x - 35,
      _player.y,
    );

    _score.position.setValues(
      _snowman.position.x + 8,
      _snowman.position.y,
    );

    //adding them as child of hud
    await addAll([_player, _life,]);

    final pauseButton = HudButtonComponent(
      button: SpriteComponent.fromImage(
        await game.images.load('skimaster/pause.png'),
        size: Vector2.all(12),
      ),
      anchor: Anchor.bottomRight,
      position: parent.virtualSize,
      onPressed: onPausePressed,
    );
    await add(pauseButton);
  }

  @override
  void update(double dt) {
    intervalCountdown.update(dt);
  }

  void updateSnowmanCount(int count) {
    _score.text = 'x$count';

    _snowman.add(
      RotateEffect.by(
        pi / 8,
        RepeatedEffectController(ZigzagEffectController(period: 0.2), 2),
      ),
    );

    _score.add(
      ScaleEffect.by(
        Vector2.all(1.5),
        EffectController(
          duration: 0.1,
          alternate: true,
        ),
      ),
    );
  }

  void updateLifeCount(int count) {
    _life.text = 'x$count';

    _player.add(
      RotateEffect.by(
        pi / 8,
        RepeatedEffectController(ZigzagEffectController(period: 0.2), 2),
      ),
    );

    _life.add(
      ScaleEffect.by(
        Vector2.all(1.5),
        EffectController(
          duration: 0.1,
          alternate: true,
        ),
      ),
    );
  }

  @override
  void render(Canvas canvas) {
    if (intervalCountdown.isRunning() || goDisplayTimer.isRunning()) {
      final String displayText =
      elapsedSecs <= 0 ? 'GO!' : elapsedSecs.toString();

      // Center Text
      final textSpan = TextSpan(text: displayText, style: textPaint.style);
      final textPainter =
      TextPainter(text: textSpan, textDirection: TextDirection.ltr);
      textPainter.layout();

      final xPosition = (parent.virtualSize.x - textPainter.width) * 0.5;
      final yPosition = (parent.virtualSize.y * 0.5 - textPainter.height * 0.5);

      // Stroke
      strokeTextPaint.render(
        canvas,
        displayText,
        Vector2(xPosition, yPosition),
      );

      // Render
      textPaint.render(
        canvas,
        displayText,
        Vector2(xPosition, yPosition),
      );
    }
  }
}
