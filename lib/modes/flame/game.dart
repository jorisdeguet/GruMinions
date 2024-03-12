import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'components/jump_button.dart';
import 'components/level.dart';
import 'components/player.dart';
import 'helpers/direction.dart';

class MainGame extends FlameGame
    with
        HasKeyboardHandlerComponents,
        DragCallbacks,
        HasCollisionDetection,
        TapCallbacks {
  @override
  Color backgroundColor() => const Color(0xFF211F30);

  //Final variables
  final ValueNotifier<int> score = ValueNotifier(0);

  //Late variables
  late JoystickComponent joystick;
  late CameraComponent cam;
  late Shape bounds;

  //Defined variables
  bool showControls = false;
  bool playSounds = false;
  double soundVolume = 1.0;
  int currentLevel = 0;

  //Other variables
  Player player = Player(character: 'Mask Dude');
  List<String> levelNames = [
    'WorldMap.tmx',
    'WorldMap.tmx',
    'Level-03.tmx',
    'Level-04.tmx',
    'Level-05.tmx',
    "Level-06.tmx",
    "Level-07.tmx"
  ];

  @override
  FutureOr<void> onLoad() async {
    //Load all images into cache
    await images.loadAllImages();

    _loadLevel();

    if (showControls) {
      addJoyStick();
      add(JumpButton());
    }
    //if (playSounds) FlameAudio.play('background.wav', volume: soundVolume);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (showControls) {
      updateJoystick();
    }

    // if(player.life.value <= 0){
    //   overlays.add('GameOver');
    // }
    super.update(dt);
  }

  void reset() {
    score.value = 0;
    player.life.value = 100;
    overlays.remove('GameOver');
    print('close');
  }

  // @override
  // void onTapDown(TapDownEvent event) {
  //   player.isHasJumped = true;
  //   super.onTapDown(event);
  // }

  // @override
  // void onTapUp(TapUpEvent event) {
  //   player.isHasJumped = false;
  //   super.onTapUp(event);
  // }

  void addJoyStick() {
    joystick = JoystickComponent(
      priority: 10,
      knob: SpriteComponent(
        sprite: Sprite(
          images.fromCache('HUD/Knob.png'),
        ),
      ),
      background: SpriteComponent(
        sprite: Sprite(
          images.fromCache('HUD/JoyStick.png'),
        ),
      ),
      margin: const EdgeInsets.only(left: 32, bottom: 32),
    );
    add(joystick);
  }

  void updateJoystick() {
    switch (joystick.direction) {
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        player.directionX = -1;
        break;
      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
        player.directionX = 1;
        break;
      default:
        player.directionX = 0;
        break;
    }
  }

  void loadNextLevel() {
    removeWhere((component) => component is Level);

    if (currentLevel < levelNames.length - 1) {
      currentLevel++;
      _loadLevel();
    } else {
      //handle game over
      currentLevel = 0;
      _loadLevel();
    }
  }

  void _loadLevel() {
    score.value = 0;
    Future.delayed(const Duration(seconds: 1), () {
      Level world = Level(levelName: levelNames[currentLevel], player: player);

      cam = CameraComponent.withFixedResolution(
        world: world,
        width: 640,
        height: 360,
      );

      cam.viewfinder.anchor = Anchor.topCenter;
      cam.priority = 1;
      addAll([cam, world]);
      cam.follow(player, horizontalOnly: true);
    });
  }

  void onJoyPad1DirectionChanged(Direction direction) {
    switch (direction) {
      case Direction.left:
        player.directionX = -1;
        break;
      case Direction.right:
        player.directionX = 1;
        break;
      case Direction.none:
        player.directionX = 0;
        break;
      case Direction.up:
        player.isHasJumped = true;
        break;
      case Direction.down:
        player.isHasJumped = false;
        break;
    }
  }
}
