

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:gru_minions/modes/base-mode.dart';

class SyncMode extends GruMinionMode {
  SyncMode({required super.sendToOthers});

  @override
  void handleMessageAsGru(String s) {

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
    // TODO: implement minionWidget
    throw UnimplementedError();
  }

  @override
  Widget gruWidget() {
    return Column(
        children : [
          MaterialButton(
            onPressed: () {
              this.sendToOthers("playAt" );
            },
            child: Text("send 30 synchros beeps"),
          ),
          MaterialButton(
            onPressed: () {
              this.sendToOthers("playAt" );
            },
            child: Text("play sound compensated"),
          ),
          MaterialButton(
            onPressed: () {
              print("ploucs");
            },
            child: Text("play sound directly"),
          ),
        ]
    );
  }

  @override
  String name() => "sync";

}