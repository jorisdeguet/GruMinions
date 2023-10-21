import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gru_minions/modes/base-mode.dart';
import 'package:gru_minions/service/utils.dart';
import 'package:invert_colors/invert_colors.dart';

class HalMode extends GruMinionMode {


  GlobalKey<BaseState> _key = GlobalKey();
  HalMode({required super.sendToOthers});

  @override
  void handleMessageAsGru(String s) {
    // TODO: implement handleMessageAsGru
  }

  @override
  void handleMessageAsMinion(String s) {
    // TODO: implement handleMessageAsMinion
    _key.currentState?.handleMessageAsMinion(s);
  }

  @override
  Widget minionWidget(BuildContext context) {
    return HalloweenMode(
      key: _key,
        sendToOthers: sendToOthers
    );
  }

  @override
  String name() {
    return "halloween";
  }

  @override
  void init() {}

}


class HalloweenMode extends BaseMode{

  const HalloweenMode({super.key, required super.sendToOthers});

  @override
  State<StatefulWidget> createState()  => HalState();

}

class HalState extends BaseState<HalloweenMode> {

  List<String> images = [
    "assets/halloween/crane.png",
    "assets/halloween/halloween.jpg",
    "assets/halloween/pumpkin.jpg",
    "assets/halloween/cat.jpeg",
    "assets/halloween/ghost.webp",
    "assets/halloween/bat.png",
  ];

  late String image = images[0];

  List<String> sounds = [
    "assets/halloween/cri.m4a",
    "assets/halloween/mouahaha.m4a",
    "assets/halloween/tonnerre.m4a"
  ];

  String getImageRandom() {
    image = images[Random().nextInt(images.length)];
    return image;
  }

  void playMouaha() {
    playSound("assets/halloween/mouahaha.m4a");
  }

  @override
  void initState(){
    playMouaha();
    timeStep();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    return Center(
      child: GestureDetector(
          onTap: () {
            String sound = sounds[Random().nextInt(sounds.length)];
            widget.sendToOthers(sound);
            playSound(sound);
          },
          child: Random().nextBool()
            ? Image.asset(getImageRandom())
            : InvertColors(child: Image.asset(getImageRandom()),)
      ),
    );
  }

  void timeStep() {
    int delay = Random().nextInt(5000) + 1000;
    Timer(Duration(milliseconds: delay), () {
      image = images[Random().nextInt(images.length)];
      setState(() {});
      timeStep();
    });
  }

  @override
  void handleMessageAsGru(String s) {
    print("Coucou as Gru");
  }

  @override
  void handleMessageAsMinion(String s) {
    if (s.contains("m4a")) {
      playSound(s);
    }
    print("Coucou as Minion");
  }

}
