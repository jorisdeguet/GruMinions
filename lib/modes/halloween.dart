import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gru_minions/utils.dart';

class HalloweenMode extends StatefulWidget{

  final Function onTap;

  const HalloweenMode({super.key, required this.onTap});

  @override
  State<StatefulWidget> createState()  => HalState();

}

class HalState extends State<HalloweenMode> {

  List<String> images = [
    "assets/halloween/crane.png",
    "assets/halloween/halloween.jpg",
    "assets/halloween/pumpkin.jpg"
  ];

  late String image = images[0];

  List<String> sounds = [
    "assets/halloween/cri.m4a",
    "assets/halloween/mouahaha.m4a",
    "assets/halloween/tonnerre.m4a"
  ];

  String getImageRandom() {
    Random r = Random();
    image = images[r.nextInt(images.length)];
    return image;
  }

  void playMouaha() {
    playSound("assets/halloween/mouahaha.m4a");
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
          onTap: () {
            String sound = sounds[Random().nextInt(sounds.length)];
            widget.onTap(sound);
          },
          child: Image.asset(getImageRandom())
      ),
    );
  }

}
