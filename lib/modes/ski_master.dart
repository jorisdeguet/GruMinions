import 'package:flutter/material.dart';
import 'package:gru_minions/modes/base-mode.dart';
import 'package:gru_minions/modes/ski_master/helpers/skimaster_direction.dart';

import 'ski_master/controller_a_game_page.dart';
import 'ski_master/game/game.dart';
import 'ski_master/gru_game_page.dart';
import 'ski_master/screen_skimaster_page.dart';

class SkiMaster extends GruMinionMode {
  SkiMaster({required super.sendOthersTCP,required super.sendOthersUDP});

  final SkiMasterGame _game = SkiMasterGame();

  @override
  Widget gruWidget() {
    return GruSkiMasterPage(
      sendTCP: sendOthersTCP,
      sendUDP: sendOthersUDP,
    );
  }

  @override
  void handleMessageAsGru(String s) {}

  @override
  void handleMessageAsMinion(String s) {
    // change the direction for Minion game

    List<String> parts = s.split(',');
    String controllerId = parts[0];

    if(parts.length >= 2){
      if(parts[1].contains('Direction')){
        Direction direction = Direction.values.firstWhere((e) => parts[1].contains(e.name));
        print("Handle message as Minion: $controllerId, $direction");
        if (controllerId == 'ControllerA') {
          print("Minion received controllerA $direction");
          _game.onJoyPad1DirectionChanged(direction);
        }
      }
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
        title: const Text('Select Option'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue, Colors.white, Colors.red],
          ),
        ),
        child: Row(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset(
                    'assets/images/skimaster/SkiMasterMainMenu.png',
                    width: 525,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    color: Colors.black,
                    child: const SizedBox(
                      width: 390,
                      height: 300,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Dans ce jeu vous devez faire du ski pour arrivé à la fin des niveaux.\n\n '
                              'Le Joy pad est utilisé pour déplacer le personnage. Le bouton A contrôle les pouvoirs du joueur.\n\n '
                              'Bonne chance! Sélectionnez votre contrôleur pour démarrer le jeu.',
                          maxLines: 15,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 15.0, bottom: 75.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(150, 50),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              ControllerAGamePage(sendTCP: sendOthersTCP,),
                        ),
                      );
                    },
                    child: const Text('Player A', style: TextStyle(color: Colors.black)),
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
  Widget screenWidget(BuildContext context) {
    return ScreenSkiMasterPage(game: _game);
  }

  @override
  String name() => "SkiMaster";
}
