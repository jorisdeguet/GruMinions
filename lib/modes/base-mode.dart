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
    initMac();
    init();
  }



  void initMac() async {
    _macAddress = await GetMac.macAddress ?? 'Unknown mac address';
  }

  void init();

  String macAddress() => _macAddress;

  // will provide the appropriate widget
  Widget minionWidget(BuildContext context);

  // gives the unique name of this mode
  String name();

  // provides the method to call when receiving the message for minions
  void handleMessageAsMinion(String s);

  // same for Gru
  void handleMessageAsGru(String s);

}