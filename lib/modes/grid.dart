

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_p2p_connection/flutter_p2p_connection.dart';
import 'package:get/get.dart';
import 'package:gru_minions/modes/base-mode.dart';
import 'package:gru_minions/service/gru_service.dart';

class GridMode extends GruMinionMode {
  GridMode({required super.sendToOthers});

  int gruRow = 0;
  int gruColumn = 0;
  int minionRow = 0;
  int minionColumn = 0;
  bool minionIsCalibrating = true;

  Map<Client, (int row, int col)> griddy = Map();


  @override
  void handleMessageAsGru(String s) {
    if (s.contains("|")) {
      String adresse = s.split("|")[0];
      print("Gru got answer for " + adresse + " " + gruRow.toString() + " " + gruColumn.toString());
      // Add client to coordinates
      //Client sender = Get.find<GruService>().info.clients.firstWhereOrNull((element) => element.deviceAddress);

      // ask the new one
      gruColumn++;
      this.sendToOthers("select:"+gruRow.toString()+":"+gruColumn.toString() );
    }
  }

  @override
  void handleMessageAsMinion(String s) {
    if (s.startsWith("select")){
      minionRow = int.parse(s.split(":")[1]);
      minionColumn = int.parse(s.split(":")[2]);
    }
  }

  @override
  void initGru() {
    // TODO count client and determine square dims
  }

  @override
  void initMinion() {
    minionIsCalibrating = true;
  }

  @override
  Widget minionWidget(BuildContext context) {
    if (!minionIsCalibrating) {
      return Text("TODO cmpute showing grid");
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text("Row " + minionRow.toString(), style: TextStyle(fontSize: 30),),
        Text("Col " + minionColumn.toString(), style: TextStyle(fontSize: 30),),
        MaterialButton(
          color: Colors.greenAccent,
          onPressed: (){
            this.sendToOthers(macAddress()+"|"+minionRow.toString() + "|" + minionColumn.toString());
          },
          child: Text("Appuie si c'est celle là", style: TextStyle(fontSize: 30), ),
        ),
      ],
    );
  }

  @override
  Widget gruWidget() {
    return Column(
      children : [
        MaterialButton(
          onPressed: () {
            gruRow = 0;
            gruColumn = 0;
            this.sendToOthers("select:"+gruRow.toString()+":"+gruColumn.toString() );
          },
          child: Text("start sequence"),
        ),
        MaterialButton(
          onPressed: () {
            this.sendToOthers("finished" );
          },
          child: Text("reset positions"),
        ),
        MaterialButton(
          onPressed: () {
            print("next row");
            gruRow++;
            gruColumn = 0;
            this.sendToOthers("select:"+gruRow.toString()+":"+gruColumn.toString() );
          },
          child: Text("Next row"),
        ),
      ]
    );
  }

  @override
  String name() => "grid";

}