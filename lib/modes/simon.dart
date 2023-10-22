// Make a mode where minion light in a succession with sound and color.

// player has to redo the sequence, then sequence gets longer.



import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:gru_minions/modes/base-mode.dart';

class Beep {
  String note = "";
  int duration = 1000;
  Color color = Colors.black;


  Beep.atRandom(){
    color = colors()[Random().nextInt(colors().length)];
    note = notes()[Random().nextInt(notes().length)];
  }

  List<String> notes(){
    return [
      "assets/piano/A3.mp3",
      "assets/piano/B3.mp3",
      "assets/piano/C3.mp3",
      "assets/piano/D3.mp3",
      "assets/piano/E3.mp3",
      "assets/piano/F3.mp3",
    ];
  }

  List<Color> colors(){
    return [
      Colors.red,
      Colors.yellow,
      Colors.blueAccent,
      Colors.lightGreenAccent,
    ];
  }
}

class SimonMode extends GruMinionMode {

  List<Beep> sequence = [];

  Color minionColor = Colors.black;

  SimonMode({required super.sendToOthers});

  @override
  void handleMessageAsGru(String s) {
    // if a touch happens at the right place in the sequence + 1

    // if a touch happens at the wrong one reset and shout error
    this.sendToOthers("no");
    // if a touch happens while I play the sequence do not do nothing
  }

  @override
  void handleMessageAsMinion(String s) {
    // TODO: implement handleMessageAsMinion
  }

  @override
  void initGru() {
    // TODO: implement initGru
  }

  @override
  void initMinion() {
    // TODO: implement initMinion
  }

  @override
  Widget minionWidget(BuildContext context) {
    return Container(color: Colors.red);
  }

  @override
  String name() => "simon";

  void addOneToSequence(){

  }

  @override
  Widget gruWidget() {
    return Text("TODO SIMON");
  }

}