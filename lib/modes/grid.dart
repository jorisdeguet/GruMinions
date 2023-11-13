

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_p2p_connection/flutter_p2p_connection.dart';
import 'package:get/get.dart';
import 'package:gru_minions/modes/base-mode.dart';
import 'package:gru_minions/service/gru_service.dart';
import 'package:gru_minions/service/utils.dart';

class GridState {

  Map<(int,int), Client> griddy = Map();

  void set(Client sender, int gruRow, int gruColumn) {
    var key = (gruRow, gruColumn);
    griddy[key] = sender;
    printGrid();
  }

  int maxRow() {
    int result = 0;
    for ((int, int) key in this.griddy.keys){
      var ( row,  col) = key;
      if (row > result) result = row;
    }
    return result+1;
  }

  int maxCol() {
    int result = 0;
    for ((int, int) key in this.griddy.keys){
      var ( row,  col) = key;
      if (col > result) result = col;
    }
    return result+1;
  }

  String printGrid() {
    for ((int, int) key in this.griddy.keys) {
      print(key.toString() + " " + this.griddy[key]!.deviceAddress!.toString());
    }
    String res = "Grid is ==========================================================================";
    for (var r = 0; r < this.maxRow() ; r++) {
      res += "\n";
      for (var c = 0 ; c < this.maxCol() ; c++){
        res += "  ";
        res += this.griddy.containsKey((r,c)) ? this.griddy[(r,c)]!.deviceAddress! : "Empty          ";
      }
    }
    return res;
  }

  void reset() {
    this.griddy.clear();
  }

}

class GridMode extends GruMinionMode {
  GridMode({required super.sendToOthers});

  int gruRow = 0;
  int gruColumn = 0;
  int minionRow = 0;
  int minionColumn = 0;
  bool minionIsCalibrating = true;

  List<DeviceOrientation> orientations = [
    DeviceOrientation.landscapeRight,
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.portraitDown,
  ];

  DeviceOrientation minionOrientation = DeviceOrientation.landscapeRight;

  GridState gruGrid = GridState();


  @override
  void handleMessageAsGru(String s) {
    if (s.contains("|")) {
      String adresse = s.split("|")[0];
      //print("Gru got answer for " + adresse + " " + gruRow.toString() + " " + gruColumn.toString());
      // Add client to coordinates
      Client? sender = Get.find<GruService>().info!.clients.firstWhereOrNull(
              (element) => estMemeAdresse(element.deviceAddress, adresse));
      if (sender != null) {
        int r = int.parse(s.split("|")[1]);
        int c = int.parse(s.split("|")[2]);

        //debugPrint("Gru got client for position " + sender!.deviceAddress.toString());
        gruGrid.set(sender, r, c);
        print("Size is "+gruGrid.maxRow().toString() + " * "+gruGrid.maxCol().toString());
        print(gruGrid.printGrid());
      }

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
    orientations = [
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitDown,
    ];
  }

  @override
  Widget minionWidget(BuildContext context) {
    SystemChrome.setPreferredOrientations([this.minionOrientation]);
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
        MaterialButton(
          color: Colors.greenAccent,
          onPressed: (){
            debugPrint("-----------------------------------------------------------");
            print(this.orientations.toString() + " for  " + this.minionOrientation.toString());
            int index = this.orientations.indexOf(this.minionOrientation);
            int next = (index+1) % this.orientations.length;
            print("index is " + index.toString() + " > "+next.toString());
            this.minionOrientation = this.orientations[next];
            this.sendToOthers(macAddress() + "^^" + this.minionOrientation.toString());
          },
          child: Text("Change orientation", style: TextStyle(fontSize: 30), ),
        ),
      ],
    );
  }

  @override
  Widget gruWidget() {
    return Column(
      children: [
        Row(
          children : [
            MaterialButton(
              onPressed: () {
                gruGrid.reset();
                gruRow = 0;
                gruColumn = 0;
                this.sendToOthers("select:"+gruRow.toString()+":"+gruColumn.toString() );
              },
              child: Text("start sequence", style: TextStyle(fontSize: 30),),
            ),
            Spacer(),
            MaterialButton(
              onPressed: () {
                print("next row");
                gruRow++;
                gruColumn = 0;
                this.sendToOthers("select:"+gruRow.toString()+":"+gruColumn.toString() );
              },
              child: Text("Next row", style: TextStyle(fontSize: 30),),
            ),
            Spacer(),
            MaterialButton(
              onPressed: () {
                this.sendToOthers("finished " );
                // TODO save it in GruService ?
              },
              child: Text("Finished", style: TextStyle(fontSize: 30),),
            ),
          ]
        ),
        Expanded(
          child: Container(
            color: Colors.yellow,
          ),
        ),
      ],
    );
  }

  @override
  String name() => "grid";

}