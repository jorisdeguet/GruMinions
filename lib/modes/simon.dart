// Make a mode where minion light in a succession with sound and color.

// player has to redo the sequence, then sequence gets longer.



import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_p2p_connection/flutter_p2p_connection.dart';
import 'package:get/get.dart';
import 'package:gru_minions/comm/message.dart';
import 'package:gru_minions/modes/base-mode.dart';
import 'package:gru_minions/service/boss_service.dart';
import 'package:gru_minions/service/utils.dart';



enum SimonStatus { showing, playing, waiting }

class SimonMode extends GruMinionMode {

  Random rand = Random();

  SimonStatus gruStatus = SimonStatus.waiting;
  List<String> gruSequence = [];
  int gruIndex = 0;

  late int minionType = rand.nextInt(4);
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
      if (s == "doneShowing") {
        gruStatus = SimonStatus.playing;
        print("Gru status is playing");
      }
    } else if (gruStatus == SimonStatus.waiting) {
      // any touch and we show
      // if a touch happens while I play the sequence do not do nothing
      gruStatus = SimonStatus.showing;
      addOneToSequence();

    } else if(gruStatus == SimonStatus.playing) {
      print("Gru got touch playing  " + s);
      if (s.contains("touch")) {
        String adresse = s.split("touch")[0];
        print("Gru Someone touched" + adresse + " gruIndex " + gruIndex.toString());
        if (gruIndex < this.gruSequence.length && estMemeAdresse(adresse, this.gruSequence[gruIndex])) {
          print("Gru OK for note" + gruIndex.toString());
          gruIndex++;
          if (gruIndex == this.gruSequence.length) {
            print("Win");
            playSound("assets/halloween/mouahaha.m4a");
            Timer(Duration(milliseconds: 3000),  () {
              print("AAAAAAAAAAAAAAADDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD ONE");
              this.gruIndex = 0;
              addOneToSequence();
            });
            // gruIndex = 0;
            // TODO play sound
            //playSound("assets/halloween/tonnerre.m4a");
            // TODO ajouter un a la sequence
            //addOneToSequence();
          }
        } else {
          playSound("assets/non.mp3");
          gruStatus = SimonStatus.waiting;
          gruIndex = 0;
          this.gruSequence.clear();
          //addOneToSequence();
          // foirade
          // jouer un son
          // repartir la sequence
        }
      }
    }
  }

  String atRandom(List<Client> clients){
    return clients[rand.nextInt(clients.length)].deviceAddress;
  }

  @override
  void handleMessageAsMinion(String s) {
    minionPadding = 0;
    if (s.startsWith("{")) {
      traiterSequence(s);
    }
    if (s.contains(":::")){
      String adresse = s.split(":::")[0];
      if (estMonAdresse(adresse)) {
        minionType = int.parse(s.split(":::")[1]);
        minionColor = colors()[minionType];
        minionNote = notes()[minionType];
      }
    }
    if (s == "off") {
      //minionColor = Colors.white;
      minionPadding = 0;
    }
  }

  void traiterSequence(String s) async {
    SimonSequence sequence = SimonSequence.fromJson(jsonDecode(s));
    print("Minion pieces " + sequence.toString());
    String adresse = sequence.sequence[0];
    if (estMonAdresse(adresse)){
      minionPadding = 80;
      // je dois jouer ma note n fois
      while(sequence.sequence.length > 0 && estMonAdresse(sequence.sequence[0])){
        print("Je joue ma note " + sequence.sequence.toString());
        playSound(minionNote);
        await Future.delayed(Duration(milliseconds: 400));
        sequence.sequence = sequence.sequence.sublist(1);
      }
      if (sequence.sequence.length > 0){
        sendToOthers(jsonEncode(sequence.toJson()));
      } else{
        sendToOthers("doneShowing");
      }
    } else {
      minionPadding = 0;
    }
  }

  @override
  void initGru() {
    GruService service = Get.find<GruService>();
    List<Client> clients = service.info!.clients;
    print("--------------------------------------------------");

    int type = 0;
    for (Client s in clients) {
      print(" client " + s.deviceAddress);
      sendToOthers(s.deviceAddress+":::"+type.toString());
      type++;
    }
    gruStatus = SimonStatus.waiting;

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
            print("Minion tap note ");
            playSound(minionNote);
            sendToOthers(macAddress()+"touch");
            print("Minion tap note has sent to others ");
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
    print("--------------------------------------------------");
    for (Client s in clients) {
      print(" client " + s.deviceAddress);
    }
    print("--------------------------------------------------");
    this.gruSequence.add(atRandom(clients));
    playSequence();
  }

  @override
  Widget gruWidget() {
    return Column(
      children: [
        Text("SIMON " + gruSequence.toString()),
        Spacer(),
        MaterialButton(
          color: Colors.green,
          onPressed: () {
            gruIndex = 0;
            addOneToSequence();
          },
          child: Text("test"),
        ),
        Spacer(),
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
    SimonSequence message = SimonSequence();
    message.sequence = this.gruSequence;

    String messageString = jsonEncode(message.toJson());
    print(messageString);
    sendToOthers(messageString);
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

  void playNoteAndPassToTheNext(String reste) async{
    // TODO TANT QUE C'EST MOI NE PAS ENVOYER DE MESSAGE, ATTENDRE ET REJOUER LA NOTE

    playSound(minionNote);
    minionPadding = 80;
    Timer(Duration(milliseconds: 400), () {
      print("Minion sends the rest of the sequence " + reste);
      sendToOthers(reste);
    });

  }

}
