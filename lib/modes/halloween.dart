import 'dart:async';
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
    image = images[Random().nextInt(images.length)];
    return image;
  }

  void playMouaha() {
    playSound("assets/halloween/mouahaha.m4a");
  }

  @override
  void initState(){
    timeStep();
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

  void timeStep() {
    int delay = Random().nextInt(5000) + 1000;
    Timer(Duration(milliseconds: delay), () {
      image = images[Random().nextInt(images.length)];
      setState(() {});
      timeStep();
    });
  }

}
