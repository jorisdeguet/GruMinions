import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gru_minions/modes/base-mode.dart';

import 'mainmenu/gru_main_menu_page.dart';

class MainMenuMode extends GruMinionMode{
  MainMenuMode({required super.sendOthersTCP,required super.sendOthersUDP});

  @override
  Widget gruWidget() {
    return GruMainMenuPage(
      sendOthersTCP: sendOthersTCP,
      sendOthersUDP: sendOthersUDP,
    );
  }

  @override
  void handleMessageAsGru(String s) {}

  @override
  void handleMessageAsMinion(String s) {
    List<String> parts = s.split(',');

    String gameName = parts[0];

    if (gameName == 'BugCatcherMainMenu') {
      sendOthersTCP('BugCatcherMainMenu');
    } else if (gameName == 'BoxSmasherMainMenu') {
      sendOthersTCP('BoxSmasherMainMenu');
    } else if (gameName == 'SkiMasterMainMenu') {
      sendOthersTCP('SkiMasterMainMenu');
    }
  }

  @override
  void handleMessageAsScreen(String s) {}

  @override
  void initGru() {}

  @override
  void initMinion() {}

  @override
  Widget minionWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Menu'),
      ),
      body: Center(
        child: Row(
          children: [
            Column(
              children: [
                Container(
                  width: 200,
                  height: 200,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/bugcatcher/images/BugCatcherMap.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: TextButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0.0),
                        ),
                      ),
                    ),
                    onPressed: () {
                      sendOthersTCP('BugCatcherMainMenu');
                    },
                    child: const Text('BugCatcher', style: TextStyle(color: Colors.black, backgroundColor: Color.fromRGBO(255,255,255,0.5), fontSize: 24, fontWeight: FontWeight.bold)),
                  ),
                ),
                Container(
                  width: 200,
                  height: 200,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/boxsmasher/images/BoxSmasherMap.png'),
                        fit: BoxFit.cover,
                      ),
                  ),
                  child: TextButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0.0),
                        ),
                      ),
                    ),
                    onPressed: () {
                      sendOthersTCP('BoxSmasherMainMenu');
                    },
                    child: const Text('BoxSmasher', style: TextStyle(color: Colors.black, backgroundColor: Color.fromRGBO(255,255,255,0.5), fontSize: 24, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Container(
                  width: 200,
                  height: 200,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/skimaster/SkiMasterMainMenu.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: TextButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0.0),
                        ),
                      ),
                    ),
                    onPressed: () {
                      sendOthersTCP('SkiMasterMainMenu');
                    },
                    child: const Text('SkiMaster', style: TextStyle(color: Colors.black, backgroundColor: Color.fromRGBO(255,255,255,0.5), fontSize: 24, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                MaterialButton(onPressed: () {
                  sendOthersTCP('Main Menu');
                }, child: const Text('Go Back to Main Menu')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  String name() => 'Main Menu';

  @override
  Widget screenWidget(BuildContext context) {
    return Stack(
      children: [
        Row(
          children: [
            Container(
              width: 320,
              height: 650,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/skimaster/SkiMasterMainMenu.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              width: 320,
              height: 650,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/boxsmasher/images/BoxSmasherMap.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              width: 320,
              height: 650,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/bugcatcher/images/BugCatcherMap.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
        Container(
          alignment: Alignment.center,
          child: Text("Flame Mini-Games", style: const TextStyle(fontSize: 52, fontWeight: FontWeight.bold, fontFamily: 'CUBE')),
        ),
      ],
    );
  }
}