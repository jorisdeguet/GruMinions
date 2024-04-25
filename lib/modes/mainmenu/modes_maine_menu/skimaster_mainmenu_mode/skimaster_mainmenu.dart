import 'package:flutter/material.dart';
import 'package:gru_minions/modes/base-mode.dart';
import 'package:gru_minions/modes/boxsmasher/helpers/joypad.dart';

import 'gru_skimaster_mainmenu_page.dart';

class SkiMasterMainMenuMode extends GruMinionMode{
  SkiMasterMainMenuMode({required super.sendOthersTCP,required super.sendOthersUDP});

  @override
  Widget gruWidget() {
    return GruSkiMasterMainMenuPage(
      sendOthersTCP: sendOthersTCP,
      sendOthersUDP: sendOthersUDP,
    );
  }

  @override
  void handleMessageAsGru(String s) {}

  @override
  void handleMessageAsMinion(String s) {}

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
        title: const Text('Ski Master Main Menu'),
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
                      image: AssetImage(
                          'assets/images/skimaster/SkiMasterMainMenu.png'),
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      sendOthersTCP('Main Menu');
                    },
                    child: const Text('Go Back to Main Menu'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  String name() => "SkiMasterMainMenu";

  @override
  Widget screenWidget(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(0, 0, 0, 1),
      body: Center(
        child: Column(
          children: [
            Row(
              children: [
                Column(
                  children: [
                    zoneImageVideoJeu(),
                  ],
                ),
                Column(
                  children: [
                    zoneControls(),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                zoneHistoreInstructions(),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget zoneImageVideoJeu() {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, top: 10, bottom: 10),
      child: Container(
        width: 600,
        height: 400,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          image: DecorationImage(
            image: AssetImage('assets/images/skimaster/SkiMasterMainMenu.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget zoneControls() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: 330,
        height: 400,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red, width: 2),
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue, Colors.white, Colors.red],
          ),
        ),
        child: const Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Dans ce jeu il faut utiliser le JoyPad pour changer la direction du Skieur. "
                    "\n\n On gagne est arrivant à la ligne d'arrivée. Bonne Chance.",
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget zoneHistoreInstructions() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: 935,
        height: 155,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red, width: 2),
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue, Colors.white, Colors.red],
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
              "Vous voulez descendre la route de neige. L'objectif est d'arrivé en bas le plus vite possible et en touchant le moins de bonhomme de neige."
                  " \n\n Ceci est un jeu fait à part par un collègue de travail.",
              style: TextStyle(color: Colors.black, fontSize: 20)),
        ),
      ),
    );
  }
}