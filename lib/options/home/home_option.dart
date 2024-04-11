import 'package:flutter/material.dart';
import 'package:gru_minions/comm/message.dart';
import 'package:gru_minions/options/home/controller_home.dart';

import '../base/base_mode.dart';
import 'screen_home.dart';

class HomeOption extends ScreenControllerOption {
  HomeOption({required super.sendToOthers});

  @override
  void initController() {}

  @override
  void initScreen() {}

  @override
  Widget controllerWidget() {
    return ControllerHome(send: sendToOthers);
  }

  @override
  Widget screenWidget(BuildContext context) {
    return const ScreenHome();
  }

  @override
  void handleMessageAsGru(String s) {
  }

  @override
  void handleMessageAsMinion(String s) {
    //now the screen know that player 2 is playing
    //stock default character in the currentConfig
    currentConfig.friendName = s;
  }

  @override
  String name() => "home_option";
}
