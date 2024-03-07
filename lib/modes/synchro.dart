import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  void initGru() {
    // TODO: implement initGru
  }

  @override
  void initMinion() {
    // TODO: implement initMinion
  }

  @override
  Widget minionWidget(BuildContext context) {
    return Stack(
      children: <Widget>[
        Image(
          image: const AssetImage('assets/images/waiting.gif'),
          fit: BoxFit.fill,
          width: MediaQuery.of(context).size.width ,
          height: MediaQuery.of(context).size.height,
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 100),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Image.asset(
                        'assets/images/Menu/Buttons/Play.png',
                        width: 100,
                        height: 100,
                        fit: BoxFit.fill,
                    ),
                    onPressed: () => showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => Dialog(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const Text('This is a typical dialog.'),
                                const SizedBox(height: 15),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Close'),
                                ),
                              ],
                            ),
                          ),
                          ),
                    ),
                  )
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget gruWidget() {
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
