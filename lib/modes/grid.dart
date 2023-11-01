

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:gru_minions/modes/base-mode.dart';

class GridMode extends GruMinionMode {
  GridMode({required super.sendToOthers});



  @override
  void handleMessageAsGru(String s) {

  }

  @override
  void handleMessageAsMinion(String s) {
    // TODO: implement handleMessageAsMinion
  }

  @override
  void initGru() {
    // TODO count client and determine square dims

  }

  @override
  void initMinion() {}

  @override
  Widget minionWidget(BuildContext context) {
    return Text("TODO");
  }

  @override
  Widget gruWidget() {
    return Column(
      children : [
        MaterialButton(
          onPressed: () {
            this.sendToOthers("row" );
          },
          child: Text("start sequence"),
        ),
        MaterialButton(
          onPressed: () {
            this.sendToOthers("reset" );
          },
          child: Text("reset positions"),
        ),
        MaterialButton(
          onPressed: () {
            print("ploucs");
          },
          child: Text("Prout"),
        ),
      ]
    );
  }

  @override
  String name() => "grid";

}