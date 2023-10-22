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
  String address = "";

  Beep.atRandom(List<Client> clients){
    address = clients[Random().nextInt(clients.length)].deviceAddress;
  }

}

enum SimonStatus { showing, playing }

class SimonMode extends GruMinionMode {

  SimonStatus gruStatus = SimonStatus.showing;
  List<Beep> gruSequence = [];
  int gruIndex = 0;

  int minionType = Random().nextInt(4);
  late Color minionColor = colors()[minionType];
  late String minionNote = notes()[minionType];
  double minionPadding = 0;

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
            // gruIndex = 0;
            // TODO play sound
            //playSound("assets/halloween/tonnerre.m4a");
            // TODO ajouter un a la seuqnece
            addOneToSequence();
          }
        } else {
          playSound("assets/non.mp3");
          gruIndex = 0;
          this.gruSequence.clear();
          addOneToSequence();
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
        minionPadding = 80;

        playSound(minionNote);
      } else {
        //minionColor = Colors.white;
        minionPadding = 0;
      }
    }


    if (s == "off") {
      //minionColor = Colors.white;
      minionPadding = 0;
    }
  }

  @override
  void initGru() {
    addOneToSequence();
  }

  @override
  void initMinion() {
    minionColor = colors()[minionType];
    minionNote = notes()[minionType];
  }

  @override
  Widget minionWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(this.minionPadding),
      child: GestureDetector(
          onTap: () {
            playSound(minionNote);
            sendToOthers(macAddress()+"touch");
          },
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
      sendToOthers(beep.address+"@gna");
      await Future.delayed(Duration(milliseconds: 1000));
    }
    sendToOthers("off");
    gruStatus = SimonStatus.playing;
  }


  List<String> notes(){
    return [
      "assets/piano/A3.mp3",
      "assets/piano/B3.mp3",
      "assets/piano/C3.mp3",
      "assets/piano/D3.mp3",
    ];
  }

  List<Color> colors(){
    return [
      Colors.yellow,
      Colors.blueAccent,
      Colors.greenAccent,
      Colors.red,
    ];
  }

}
