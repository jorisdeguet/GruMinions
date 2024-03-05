import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_p2p_connection/flutter_p2p_connection.dart';
import 'package:get/get.dart';
import 'package:gru_minions/modes/base-mode.dart';
import 'package:gru_minions/service/gru_service.dart';
import 'package:gru_minions/service/utils.dart';

class TapeLeLapin extends GruMinionMode {
  String rabAdress = "";

  String adresseDuLapin = "";

  TapeLeLapin({required super.sendToOthers});

  @override
  void handleMessageAsGru(String m) {
    if (m.contains("hit")) {
      choisisUnLapin();
    }
  }

  bool suisLeLapin() {
    return estMonAdresse(rabAdress);
  }

  @override
  void handleMessageAsMinion(String s) {
    print("Tapelelapin minion ::: $s rab  :::: $rabAdress");
    if (s.contains("rabbit")) {
      rabAdress = s.split("rab")[0];
      return;
    }
    if (s.contains("miss")) {
      playSound("assets/non.mp3");
    }
  }

  void handleMessageAsScreen(String s){}

  @override
  Widget screenWidget(BuildContext context) {
    return _minionWidget();
  }

  @override
  Widget minionWidget(BuildContext context) {
    return _minionWidget();
  }

  Column _minionWidget() {
    bool isMe = suisLeLapin();
    return Column(
      children: [
        Expanded(
          child: SizedBox(
            width: double.infinity,
            child: MaterialButton(
              color: isMe ? Colors.white : Colors.white,
              onPressed: () {
                //
                if (isMe) {
                  sendToOthers("${macAddress()}hit");
                } else {
                  sendToOthers("${macAddress()}miss");
                }
              },
              child: isMe
                  ? Image.asset("assets/rabbit.png")
                  : Image.asset("assets/mole.jpg"),
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
    String nouvelleAdresse =
        clients[Random().nextInt(clients.length)].deviceAddress;
    do {
      nouvelleAdresse = clients[Random().nextInt(clients.length)].deviceAddress;
    } while (adresseDuLapin == nouvelleAdresse);
    adresseDuLapin = nouvelleAdresse;
    print("Gru Lapin sera $adresseDuLapin");
    sendToOthers("${adresseDuLapin}rabbit");
  }

  @override
  void initMinion() {}

  @override
  Widget gruWidget() {
    return Container(color: Colors.blueAccent);
  }
}
