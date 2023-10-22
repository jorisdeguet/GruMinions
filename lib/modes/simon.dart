// Make a mode where minion light in a succession with sound and color.

// player has to redo the sequence, then sequence gets longer.



import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_p2p_connection/flutter_p2p_connection.dart';
import 'package:get/get.dart';
import 'package:gru_minions/modes/base-mode.dart';
import 'package:gru_minions/service/boss_service.dart';
import 'package:gru_minions/service/utils.dart';

class Beep {
  String note = "";
  int duration = 1000;
  String color = "y";
  String address = "";


  Beep.atRandom(List<Client> clients){
    address = clients[Random().nextInt(clients.length)].deviceAddress;
    color = colors()[Random().nextInt(colors().length)];
    note = notes()[Random().nextInt(notes().length)];
  }

  List<String> notes(){
    return [
      "assets/piano/A3.mp3",
      "assets/piano/B3.mp3",
      "assets/piano/C3.mp3",
      "assets/piano/D3.mp3",
    ];
  }

  List<String> colors(){
    return [
      "y",
      "g",
      "b",
      "r",
    ];
  }
}

enum SimonStatus { showing, playing }

class SimonMode extends GruMinionMode {

  SimonStatus gruStatus = SimonStatus.showing;
  List<Beep> gruSequence = [];
  int gruIndex = 0;

  Color minionColor = Colors.black;

  SimonMode({required super.sendToOthers});

  @override
  void handleMessageAsGru(String s) {
    print("======================================= " + s + "   " +gruStatus.toString());
    print(this.gruSequence.toString());
    if (gruStatus == SimonStatus.showing) {
      // ignore
      // if a touch happens while I play the sequence do not do nothing
    } else if(gruStatus == SimonStatus.playing) {
      print("Gru got touch " + s);
      if (s.contains("touch")) {
        String adresse = s.split("touch")[0];
        print("Someone touched" + adresse);
        if (estMemeAdresse(adresse, this.gruSequence[gruIndex].address)) {
          print("OK");
          gruIndex++;
          if (gruIndex == this.gruSequence.length) {
            print("Win");
            gruIndex = 0;
            // TODO play sound
            // TODO ajouter un a la seuqnece
          }
        } else {
          gruIndex = 0;
          // foirade
          // jouer un son
          // repartir la sequence
        }
      }

      // voir ou on est dans la sequence
      // if a touch happens at the right place in the sequence + 1

      // if a touch happens at the wrong one reset and shout error

    }
    //this.sendToOthers("no");

  }

  @override
  void handleMessageAsMinion(String s) {
    if (s.contains("@")) {
      String adresse = s.split("@")[0];
      String color = s.split("@")[1];
      if (estMonAdresse(adresse)){
        minionColor = color=="y"?Colors.yellow:color=="b"?Colors.blue:color=="g"?Colors.green:Colors.red;
        String note = color=="y"?"A3":color=="b"?"B3":color=="g"?"C3":"D3";
        playSound("assets/piano/"+note+".mp3");
      } else {
        minionColor = Colors.white;
      }
    }


    if (s == "off") {
      minionColor = Colors.white;
    }
  }

  @override
  void initGru() {
    addOneToSequence();
  }

  @override
  void initMinion() {
    // TODO: implement initMinion
  }

  @override
  Widget minionWidget(BuildContext context) {
    return GestureDetector(
      onTap: () {
        sendToOthers(macAddress()+"touch");
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            color: minionColor,
        ),
      ),
    );
  }

  @override
  String name() => "simon";

  void addOneToSequence(){
    GruService service = Get.find<GruService>();
    List<Client> clients = service.info!.clients;
    this.gruSequence.add(Beep.atRandom(clients));
    playSequence();
  }

  @override
  Widget gruWidget() {
    return Column(
      children: [
        Text("TODO SIMON"),
        MaterialButton(
          color: Colors.green,
          onPressed: () {
            addOneToSequence();
          },
          child: Text("test"),
        ),
        MaterialButton(
          color: Colors.red,
          onPressed: () {
            this.gruSequence.clear();
            gruIndex = 0;
          },
          child: Text("clear"),
        ),
      ],
    );
  }

  void playSequence() async {
    gruStatus = SimonStatus.showing;
    for (Beep beep in this.gruSequence) {
      sendToOthers(beep.address+"@"+beep.color.toString());
      await Future.delayed(Duration(milliseconds: 1000));
    }
    sendToOthers("off");
    gruStatus = SimonStatus.playing;
  }

}