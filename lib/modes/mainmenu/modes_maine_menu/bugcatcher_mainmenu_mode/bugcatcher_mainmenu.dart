import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:gru_minions/modes/base-mode.dart';

import '../../../bugcatcher/helpers/bugcatcher_a_button.dart';
import '../../../bugcatcher/helpers/bugcatcher_b_button.dart';
import 'gru_bugcatcher_mainmenu_page.dart';

class BugCatcherMainMenuMode extends GruMinionMode {
  BugCatcherMainMenuMode(
      {required super.sendOthersTCP, required super.sendOthersUDP});

  @override
  Widget gruWidget() {
    return GruBugCatcherMainMenuPage(
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
        title: const Text('Bug Catcher Main Menu'),
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
                          'assets/bugcatcher/images/BugCatcherMap.png'),
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
  String name() => 'BugCatcherMainMenu';

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
        width: 525,
        height: 425,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          image: DecorationImage(
            image: AssetImage('assets/bugcatcher/images/BugCatcherMap.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget zoneControls(){
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: 400,
        height: 400,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red, width: 2),
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.black, Colors.brown, Colors.yellow],
          ),
        ),
        child: const Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text("Dans ce jeu il faut compter les insectes qui font partie d'un certain type. "
                  "\n On bouge le JoyPad pour bouger la caméra et on appuie sur le bouton A et pour compter les insectes le bouton B sert à enlever 1 au compteur."
                  "\n\n On gagne en donnant le bon nombre d'insecte. Bonne Chance.",
                style: TextStyle(color: Colors.white, fontSize: 20),
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
        height: 135,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red, width: 2),
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.black, Colors.brown, Colors.yellow],
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.only(bottom: 5.0),
          child: Text(
              "Vous êtes un exterminateur cahrgé de compte le nombre d'insecte à exterminer. Donc pour réussir votre travail voous devez obtenir le nombre exact."
                  " \n\n Ceci est le deuxième mini-jeu développer dans ce jeu",
              style: TextStyle(color: Colors.white, fontSize: 20)),
        ),
      ),
    );
  }

}
