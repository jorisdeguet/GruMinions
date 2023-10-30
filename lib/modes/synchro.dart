

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:gru_minions/modes/base-mode.dart';

class SyncMode extends GruMinionMode {

  List<double> minionDeltaMillis = [];

  SyncMode({required super.sendToOthers});

  @override
  void handleMessageAsGru(String s) {
    // nothing
  }

  @override
  void handleMessageAsMinion(String s) {
    if (s.contains("bip")){
      DateTime local = DateTime.now();
      String time = s.split("bip")[1];
      DateTime gruTime = DateTime.parse(time);
      print("MINION GOT    " + gruTime.toString() + "  @  " + local.toString());
    }
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
    return Center(
      child: Column(
        children: [
          Text(minionAverageDelta().toString()),
          Text(DateTime.now().toIso8601String()),
        ],
      ),
    );
  }

  @override
  Widget gruWidget() {
    return Column(
        children : [
          MaterialButton(
            onPressed: () {
              send30Bips();
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
          Text(minionAverageDelta().toString()),
          Text(minionLastDelta().toString()),
        ]
    );
  }

  @override
  String name() => "sync";

  void send30Bips() async {
    for (int i in List.generate(30, (i) => i)) {
      sendToOthers("bip"+DateTime.now().toIso8601String());
      await Future.delayed(const Duration(seconds: 1));
    }
    print("done");
  }

  double minionLastDelta() {
    if (minionDeltaMillis.length == 0 ) return -666;
    return minionDeltaMillis.last;
  }

  double minionAverageDelta() {
    if (minionDeltaMillis.length == 0 ) return -666;
    return minionDeltaMillis.reduce((a, b) => a + b) / minionDeltaMillis.length;
  }

}