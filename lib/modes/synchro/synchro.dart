import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gru_minions/modes/base-mode.dart';
import 'package:intl/intl.dart';

class SyncMode extends GruMinionMode {
  final List<int> _minionDeltaMillis = [];

  final DateFormat _dtf = DateFormat('hh:mm:ssS');

  SyncMode({required super.sendToOthers});

  @override
  void handleMessageAsGru(String s) {
    // nothing
  }

  @override
  void handleMessageAsMinion(String s) {
    if (s.contains("start")) {
      _minionDeltaMillis.clear();
    }
    if (s.contains("bip")) {
      DateTime local = DateTime.now();
      String time = s.split("bip")[1];
      DateTime gruTime = DateTime.parse(time);
      print("MINION GOT    $gruTime  @  $local");

      Duration diff = local.difference(gruTime);
      _minionDeltaMillis.add(diff.inMilliseconds);
    }
  }

  DateTime _minionCorrectedTime() {
    DateTime local = DateTime.now();
    DateTime corrected =
        local.subtract(Duration(milliseconds: minionAverageDelta().toInt()));
    return corrected;
  }

  @override
  void initController() {
    // TODO: implement initGru
  }

  @override
  void initScreen() {
    // TODO: implement initMinion
  }

  @override
  Widget screenWidget(BuildContext context) {
    return Stack(
      children: <Widget>[
        Image(
          image: const AssetImage('assets/images/Background/Wallpaper2.gif'),
          fit: BoxFit.fill,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
        ),
        BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 100),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                    ],
                  ),
                ],
              ),
            )),
      ],
    );
  }

  @override
  Widget controllerWidget() {
    return Column(children: [
      MaterialButton(
        onPressed: () {
          send30Bips();
        },
        child: const Text("send 30 synchros beeps"),
      ),
      MaterialButton(
        onPressed: () {
          sendToOthers("playAt");
        },
        child: const Text("play sound compensated"),
      ),
      MaterialButton(
        onPressed: () {
          print("ploucs");
        },
        child: const Text("play sound directly"),
      ),
      Text(minionAverageDelta().toString()),
      Text(minionLastDelta().toString()),
    ]);
  }

  @override
  String name() => "sync";

  void send30Bips() async {
    sendToOthers("start");
    for (int i in List.generate(30, (i) => i)) {
      sendToOthers("bip${DateTime.now().toIso8601String()}");
      await Future.delayed(const Duration(seconds: 1));
    }
    sendToOthers("stop");
  }

  int minionLastDelta() {
    if (_minionDeltaMillis.isEmpty) return -666;
    return _minionDeltaMillis.last;
  }

  double minionAverageDelta() {
    if (_minionDeltaMillis.isEmpty) return -666;
    return _minionDeltaMillis.reduce((a, b) => a + b) *
        1.0 /
        _minionDeltaMillis.length;
  }
}
