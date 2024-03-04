import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';

import 'components/level.dart';
import 'components/player.dart';

class MainGame extends FlameGame with HasKeyboardHandlerComponents, DragCallbacks{
  @override
  Color backgroundColor() => const Color(0xFF211F30);
  Player player = Player(character: 'Ninja Frog');
  late JoystickComponent joystick;
  bool showJoyStick = false;
  late final CameraComponent cam;

  @override
  FutureOr<void> onLoad() async {
    //Load all images into cache *can create some issues*
    await images.loadAllImages();

    final worldLevel = Level(
        levelName: 'Level-01.tmx',
        player: player
    );

    cam = CameraComponent.withFixedResolution(world: worldLevel, width: 640, height: 360);
    cam.viewfinder.anchor = Anchor.topLeft;

    addAll([cam, worldLevel]);

    if(showJoyStick){
      addJoyStick();
    }
    return super.onLoad();
  }

  void addJoyStick() {
    joystick = JoystickComponent(
      knob: SpriteComponent.fromImage(images.fromCache('HUD/Knob.png')),
      background: SpriteComponent.fromImage(images.fromCache('HUD/JoyStick.png')),
      margin: const EdgeInsets.only(bottom : 32, left: 32),
    );
    add(joystick);
  }
}