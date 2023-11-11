

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:gru_minions/modes/base-mode.dart';

class GridMode extends GruMinionMode {
  GridMode({required super.sendToOthers});

  int gruRow = 0;
  int gruColumn = 0;
  int minionRow = 0;
  int minionColumn = 0;


  @override
  void handleMessageAsGru(String s) {
    if (s.contains("|")) {
      String adresse = s.split("|")[0];
      print("Gru got answer for " + adresse + " " + gruRow.toString() + " " + gruColumn.toString());
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
  void initMinion() {}

  @override
  Widget minionWidget(BuildContext context) {
    return Column(
      children: [
        Text("Row " + minionRow.toString()),
        Text("Col " + minionColumn.toString()),
        MaterialButton(
          onPressed: (){
            this.sendToOthers(macAddress()+"|"+minionRow.toString() + "|" + minionColumn.toString());
          },
          child: Text("Appuie si c'est celle là"),
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
            this.sendToOthers("reset" );
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
          child: Text("Prout"),
        ),
      ]
    );
  }

  @override
  String name() => "grid";

}