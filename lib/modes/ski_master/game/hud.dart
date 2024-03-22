import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart' hide Viewport;

import 'input.dart';

//to make this remain static depending on the camera we will add in the viewport of the camera
//to enforce this relation we also add the parentIsA with viewport as a mix in the class
//this make sure that any obj of this class is only overriden by a obj of class Viewport
class Hud extends PositionComponent with ParentIsA<Viewport>, HasGameReference {
  Hud({
    required Sprite playerSprite,
    required Sprite snowmanSprite,
    required this.input,
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

  late final JoystickComponent? _joystick;
  final Input input;
  final VoidCallback? onPausePressed;

  late Timer intervalCountdown;
  int elapsedSecs = 3;

  final TextPaint textPaint = TextPaint(
    style: const TextStyle(color: Colors.black, fontSize: 40),
  );

  @override
  Future<void> onLoad() async {
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
    await addAll([_player, _life, _snowman, _score]);

    _joystick = JoystickComponent(
      anchor: Anchor.center,
      position: parent.virtualSize * 0.2,
      knob: CircleComponent(
        radius: 10,
        paint: Paint()..color = Colors.green.withOpacity(0.08),
      ),
      background: CircleComponent(
        radius: 20,
        paint: Paint()
          ..color = Colors.black.withOpacity(0.05)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4,
      ),
    );

    _joystick?.position.y = parent.virtualSize.y - _joystick!.knobRadius * 1.5;
    await _joystick?.addToParent(this);

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
    if (input.active) {
      input.joystickHaxis = lerpDouble(
        input.joystickHaxis,
        _joystick!.isDragged ? _joystick!.relativeDelta.x * input.maxHAxis : 0,
        input.sensitivity * dt,
      )!;
    }
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
    if (intervalCountdown.isRunning()) {
      textPaint.render(
        canvas,
        elapsedSecs.toString(),
        Vector2(parent.virtualSize.x * 0.5, parent.virtualSize.y * 0.5),
      );
    }
  }
}
