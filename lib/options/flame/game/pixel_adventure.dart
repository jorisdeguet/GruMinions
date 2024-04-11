import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../components/friend.dart';
import '../helpers/direction.dart';
import '../helpers/jump_button.dart';
import '../components/player.dart';
import '../components/level.dart';



class PixelAdventure extends FlameGame with HasKeyboardHandlerComponents, DragCallbacks, HasCollisionDetection, TapCallbacks{
  final String playerName;
  final String? friendName;
  final String level;
  
  PixelAdventure({required this.playerName, this.friendName, required this.level});

  //Final variables
  final ValueNotifier<int> score = ValueNotifier(0);
  final ValueNotifier<int> time = ValueNotifier(0);

  //Late variables
  late JoystickComponent joystick;
  late CameraComponent cam;
  late Player player = Player(character: playerName);
  late Friend? friend = friendName != null ? Friend(character: friendName!) : null;
  late Level worldMap;
  late Timer interval;
  late int indexCurrentLevel;
  late String currentLevel;

  //Defined variables
  bool showControls = false;
  bool playSounds = false;
  double soundVolume = 1.0;
  final List<String> _levels = ['01', '02', '03'];

  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages(); //Load all images into cache
    indexCurrentLevel = int.parse(level) - 1;
    _loadLevel();

    interval = Timer(
      1,
      onTick: () => time.value += 1,
      repeat: true,
    );

    if(playSounds) FlameAudio.bgm.play('background.wav', volume: soundVolume);

    if(showControls){
      addJoyStick();
      add(JumpButton());
    }

    return super.onLoad();
  }

  @override
  void update(double dt) {
    interval.update(dt);
    if (showControls) {
      updateJoystick();
    }
    super.update(dt);
  }

  void onController1DirectionChanged(Direction direction) {
    player.direction = direction;
  }

  void onController2DirectionChanged(Direction direction) {
    friend!.direction = direction;
  }

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

  void nextLevel() {
    overlays.clear();
    removeWhere((component) => component is Level);

    if(indexCurrentLevel < 2){
      indexCurrentLevel++;
      _loadLevel();
    }
    else {
      indexCurrentLevel = 0;
      _loadLevel();
    }
  }

  void restartLevel() {
    overlays.clear();
    removeWhere((component) => component is Level);
    _loadLevel();
  }

  void previousLevel() {
    overlays.clear();
    removeWhere((component) => component is Level);

    if(indexCurrentLevel > 0){
      indexCurrentLevel--;
      _loadLevel();
    }
    else {
      indexCurrentLevel = 2;
      _loadLevel();
    }
  }

  void _loadLevel() {
    score.value = 0;
    time.value = 0;
    player.life.value = 3;
    friend?.life.value = 3;

    interval = Timer(
      1,
      onTick: () => time.value += 1,
      repeat: true,
    );
    currentLevel = _levels[indexCurrentLevel];

    Future.delayed(const Duration(seconds: 1), () {

      worldMap = Level(
          levelName: '$currentLevel.tmx',
          player: player,
          friend: friend,
      );

      cam = CameraComponent.withFixedResolution(
        world: worldMap,
        width: 640,
        height: 360,
      );
      cam.viewfinder.anchor = Anchor.center;
      addAll([cam, worldMap]);
      cam.follow(player);
    });
  }
}