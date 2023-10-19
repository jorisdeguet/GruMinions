import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:gru_minions/modes/base-mode.dart';
import 'package:gru_minions/utils.dart';
import 'package:mac_address/mac_address.dart';

class TapeLeLapin extends GruMinionMode {

  String rabAdress = "";

  TapeLeLapin({required super.sendToOthers});

  @override
  void handleMessageAsGru(String m) {
    // TODO: implement handleMessageAsGru move the Gru code out of gru.dart
  }

  @override
  void handleMessageAsMinion(String m) {
    if (m.contains("rabbit")){
      // on passe en mode tape le lapin
      // mode = MinionMode.tapelelapin;
      rabAdress = m.split("rab")[0];
      if (m.contains(macAddress())) {
        print("Je suis le lapin");
      } else {
        print("Je suis une taupe");
      }
      return;
    }
    if (m.contains("miss")) {
      playSound("assets/non.mp3");
    }
  }

  @override
  Widget minionWidget(BuildContext context) {
    // TODO: implement minionWidget
    String monAdresse = macAddress().substring(2, 17).toUpperCase();
    String rabAdresse = rabAdress.substring(2, 17).toUpperCase();
    print("mon adresse = " + monAdresse + " adresse Lapin " + rabAdresse);
    bool isMe = (monAdresse == rabAdresse);
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



}