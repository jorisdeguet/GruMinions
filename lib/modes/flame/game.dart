import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'components/jump_button.dart';
import 'components/level.dart';
import 'components/player.dart';

class MainGame extends FlameGame with HasKeyboardHandlerComponents, DragCallbacks, HasCollisionDetection, TapCallbacks{
  @override
  Color backgroundColor() => const Color(0xFF211F30);
  Player player = Player(character: 'Ninja Frog');
  late JoystickComponent joystick;
  bool showControls = false;
  bool playSounds = false;
  double soundVolume = 1.0;
  late CameraComponent cam;
  List<String> levelNames = ['Level-01.tmx', "Level-01.tmx", "Level-01.tmx"];
  int currentLevel = 0;

  @override
  FutureOr<void> onLoad() async {
    //Load all images into cache *can create some issues*
    await images.loadAllImages();

    _loadLevel();

    if(showControls){
      addJoyStick();
      add(JumpButton());
    }
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (showControls) {
      updateJoystick();
    }
    super.update(dt);
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

  void addJoyStick() {
    joystick = JoystickComponent(
      priority: 10,
      knob: SpriteComponent.fromImage(images.fromCache('HUD/Knob.png')),
      background: SpriteComponent.fromImage(images.fromCache('HUD/JoyStick.png')),
      margin: const EdgeInsets.only(bottom : 32, left: 32),
    );
    add(joystick);
  }

  void loadNextLevel() {
    removeWhere((component) => component is Level);

    if(currentLevel < levelNames.length - 1){
      currentLevel++;
      _loadLevel();
    }
    else {
      //handle game over
      currentLevel = 0;
      _loadLevel();
    }
  }

  void _loadLevel() {
    Future.delayed(const Duration(seconds: 1), () {
      Level worldLevel = Level(
          levelName: levelNames[currentLevel],
          player: player
      );

      cam = CameraComponent.withFixedResolution(world: worldLevel, width: 640, height: 360);
      cam.viewfinder.anchor = Anchor.topLeft;

      addAll([cam, worldLevel]);
    });
  }
}