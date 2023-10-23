import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:gru_minions/modes/base-mode.dart';
import 'package:gru_minions/modes/flame/main_game_page.dart';


// taken from https://github.com/flame-games/player_move
class FlameMode extends GruMinionMode {
  FlameMode({required super.sendToOthers});

  @override
  Widget gruWidget() {
    return Text("TODO");
  }

  @override
  void handleMessageAsGru(String s) {

  }

  @override
  void handleMessageAsMinion(String s) {

  }

  @override
  void initGru() {

  }

  @override
  void initMinion() {

  }

  @override
  Widget minionWidget(BuildContext context) {
    return MainGamePage();
  }

  @override
  String name() => "flame";

}