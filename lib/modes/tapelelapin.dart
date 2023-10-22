import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_p2p_connection/flutter_p2p_connection.dart';
import 'package:get/get.dart';
import 'package:gru_minions/modes/base-mode.dart';
import 'package:gru_minions/service/boss_service.dart';
import 'package:gru_minions/service/utils.dart';

class TapeLeLapin extends GruMinionMode {

  String rabAdress = "";

  var adresseDuLapin = "";

  TapeLeLapin({required super.sendToOthers});

  @override
  void handleMessageAsGru(String m) {
    // TODO: implement handleMessageAsGru move the Gru code out of gru.dart
    if (m.contains("hit")){
      choisisUnLapin();
    }
  }

  bool suisLeLapin() {
    print(macAddress() + " " + rabAdress);
    String monAdresse = macAddress().substring(2, 17).toUpperCase();
    String rabAdresse = rabAdress.substring(2, 17).toUpperCase();
    print("mon adresse = " + monAdresse + " adresse Lapin " + rabAdresse);
    return monAdresse == rabAdresse;
  }

  @override
  void handleMessageAsMinion(String m) {
    print("Tapelelapin minion ::: " + m + " rab  :::: " + rabAdress);
    if (m.contains("rabbit")){
      rabAdress = m.split("rab")[0];
      return;
    }
    if (m.contains("miss")) {
      playSound("assets/non.mp3");
    }
  }

  @override
  Widget minionWidget(BuildContext context) {
    bool isMe = suisLeLapin();
    return Column(
      children: [
        Expanded(
          child: Container(
            width: double.infinity,
            child: MaterialButton(
              color: isMe ? Colors.white : Colors.white,
              onPressed: () {
                //
                if (isMe) {
                  this.sendToOthers(macAddress()+"hit");
                } else {
                  this.sendToOthers(macAddress()+"miss");
                }
              },
              child: isMe ? Image.asset("assets/rabbit.png") : Image.asset("assets/mole.jpg") ,
            ),
          ),
        )
      ],
    );
  }

  @override
  String name() => "tapelelapin";

  @override
  void initGru() {
    choisisUnLapin();
  }

  void choisisUnLapin() async {
    print("Appel a choisisUnLapin");
    GruService service = Get.find<GruService>();
    List<Client> clients = service.info!.clients;
    String nouvelleAdresse = clients[Random().nextInt(clients.length)].deviceAddress;
    do {
      nouvelleAdresse = clients[Random().nextInt(clients.length)].deviceAddress;
    } while(adresseDuLapin == nouvelleAdresse);
    adresseDuLapin = nouvelleAdresse;
    print("Gru Lapin sera " + adresseDuLapin);
    this.sendToOthers(adresseDuLapin + "rabbit");
  }

  @override
  void initMinion() {}

  @override
  Widget gruWidget() {
    return Container(color: Colors.blueAccent);
  }


}