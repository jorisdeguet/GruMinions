import 'package:flutter/cupertino.dart';
import 'package:mac_address/mac_address.dart';

/**
 * Provide the widget for the minion mode
 * Handles the message
 */

// Maybe use https://pub.dev/packages/event_bus to easily send and receive message

abstract class BaseMode extends StatefulWidget {

  final Function sendToOthers;
  const BaseMode({super.key, required this.sendToOthers});

}

abstract class BaseState<T extends StatefulWidget> extends State<T> {
  void handleMessageAsMinion(String s);
  void handleMessageAsGru(String s);

}



// This is the base interface to interact with a mode
abstract class GruMinionMode {

  final Function sendToOthers;

  String _macAddress = "no mac";

  GruMinionMode({required this.sendToOthers}){
    _initMac();
  }

  void _initMac() async {
    _macAddress = await GetMac.macAddress ?? 'Unknown mac address';
  }

  String macAddress() => _macAddress;

  bool estMemeAdresse(String a, String b){
    // du au fait que les adresses MAC en Wifi direct ne sont pas exactement celle de Wifi
    String aa = a.substring(2, 17).toUpperCase();
    String bb = b.substring(2, 17).toUpperCase();
    return aa == bb;
  }

  bool estMonAdresse(String autre) {
    return estMemeAdresse(autre, macAddress());
  }

  // ABSTRACT METHODES POUR DEFINIR LE MODE

  // gives the unique name of this mode
  String name();
  void initGru();
  void initMinion();
  // will provide the appropriate widget
  Widget minionWidget(BuildContext context);
  Widget gruWidget();
  // provides the method to call when receiving the message for minions
  void handleMessageAsMinion(String s);
  // same for Gru
  void handleMessageAsGru(String s);
}