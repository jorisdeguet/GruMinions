

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:gru_minions/modes/base-mode.dart';
import 'package:intl/intl.dart';

class SyncMode extends GruMinionMode {

  List<int> minionDeltaMillis = [];

  DateFormat dtf = DateFormat('hh:mm:ssS');

  SyncMode({required super.sendToOthers});

  @override
  void handleMessageAsGru(String s) {
    // nothing
  }

  @override
  void handleMessageAsMinion(String s) {
    if (s.contains("start")) {
      minionDeltaMillis.clear();
    }
    if (s.contains("bip")){
      DateTime local = DateTime.now();
      String time = s.split("bip")[1];
      DateTime gruTime = DateTime.parse(time);
      print("MINION GOT    " + gruTime.toString() + "  @  " + local.toString());

      Duration diff = local.difference(gruTime);
      minionDeltaMillis.add(diff.inMilliseconds);
    }
  }

  DateTime minionCorrectedTime(){
    DateTime local = DateTime.now();
    DateTime corrected = local.subtract(Duration(milliseconds: minionAverageDelta().toInt()));
    return corrected;
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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(minionAverageDelta().toString(), style: TextStyle(fontSize: 20), ),
          Text(minionLastDelta().toString(), style: TextStyle(fontSize: 25), ),
          Text(dtf.format(minionCorrectedTime()), style: TextStyle(fontSize: 35), ),
          Text(dtf.format(DateTime.now()), style: TextStyle(fontSize: 45),),
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
    sendToOthers("start");
    for (int i in List.generate(30, (i) => i)) {
      sendToOthers("bip"+DateTime.now().toIso8601String());
      await Future.delayed(const Duration(seconds: 1));
    }
    sendToOthers("stop");
  }

  int minionLastDelta() {
    if (minionDeltaMillis.length == 0 ) return -666;
    return minionDeltaMillis.last;
  }

  double minionAverageDelta() {
    if (minionDeltaMillis.length == 0 ) return -666;
    return minionDeltaMillis.reduce((a, b) => a + b) * 1.0 / minionDeltaMillis.length;
  }

}