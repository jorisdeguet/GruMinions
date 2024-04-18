import 'package:flutter/material.dart';
import 'package:gru_minions/modes/base-mode.dart';
import 'package:gru_minions/modes/boxsmasher/helpers/a_button.dart';

import 'gru_boxsmasher_mainmenu_page.dart';

class BoxSmasherMainMenuMode extends GruMinionMode {
  BoxSmasherMainMenuMode({required super.sendOthersTCP,required super.sendOthersUDP});

  @override
  Widget gruWidget() {
    return GruBoxSmasherMainMenuPage(
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
        title: const Text('Box Smasher Main Menu'),
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
                      image: AssetImage('assets/boxsmasher/images/BoxSmasherMap.png'),
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
  String name() => 'BoxSmasherMainMenu';

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
                       Padding(
                         padding: const EdgeInsets.only(left: 10.0, top: 10, bottom: 10),
                         child: Container(width: 600, height: 400,
                           decoration: const BoxDecoration(
                             borderRadius: BorderRadius.all(Radius.circular(20)),
                             image: DecorationImage(
                               image: AssetImage('assets/boxsmasher/images/BoxSmasherMap.png'),
                               fit: BoxFit.cover,
                             ),
                           ),
                         ),
                       ),
                      ],
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            width: 330,
                            height: 400,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.red, width: 2),
                              borderRadius: BorderRadius.circular(20),
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Colors.black, Colors.blue, Colors.green],
                              ),
                            ),
                            child: Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Text("In this game you will need the A Button to push the boxes into your new house. \n\n You will need to press faster than your opponent to win. Good Luck!",
                                  style: TextStyle(color: Colors.white, fontSize: 20),
                                  ),
                                ),
                                Padding(padding: EdgeInsets.only(right: 10, left: 10),
                                  child: AButton(onAButtonChanged: (isPressed) {
                                    if(isPressed == null){
                                      sendOthersTCP('BoxSmasherMainMenu,ButtonA,${isPressed ? true : false}');
                                    }
                                  }),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
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
                            colors: [Colors.blue, Colors.green, Colors.brown],
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                              "Vous devez aider Foxer pour déménager les boîtes. L'objectif est de pousser 100 boîtes dans la maison. Donc le premier à réussir à entrer 100 boîtes gagne."
                                  " \n\n Ceci est le premier mini-jeu développer dans ce jeu",
                              style: TextStyle(color: Colors.white, fontSize: 20)),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
        ),
    );
  }
}