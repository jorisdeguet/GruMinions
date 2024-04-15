import 'package:flutter/material.dart';
import 'package:gru_minions/modes/base-mode.dart';
import 'package:gru_minions/modes/boxsmasher/components/boxsmasher_mainmenu.dart';
import 'package:gru_minions/modes/boxsmasher/controller_a_game_page.dart';
import 'package:gru_minions/modes/boxsmasher/gru_game_page.dart';

import 'boxsmasher/boxsmasher_game.dart';
import 'boxsmasher/controller_b_game_page.dart';
import 'boxsmasher/helpers/direction.dart';

class BoxSmasherMode extends GruMinionMode {
  BoxSmasherMode({required super.sendOthersTCP,required super.sendOthersUDP});

  final BoxSmasherGame _gameA = BoxSmasherGame();
  final BoxSmasherGame _gameB = BoxSmasherGame();

  @override
  Widget gruWidget() {
    return GruBoxSmasherPage(
      send: sendOthersTCP,
    );
  }

  @override
  void handleMessageAsGru(String s) {}

  @override
  void handleMessageAsMinion(String s) {
    // change the direction for Minion game

    List<String> parts = s.split(',');
    String controllerId = parts[0];

    if (parts.length >= 2) {
      bool Pressed = false;
      if (parts[1].contains('Direction')) {
        Direction direction =
            Direction.values.firstWhere((e) => parts[1].contains(e.name));
        if (controllerId == 'ControllerA') {
          // _gameA.onJoyPad1DirectionChanged(direction);
        }
      } else {
        if (parts[2] == 'true') {
          Pressed = true;
        }
        if (parts[2] == 'false') {
          Pressed = false;
        }

        if (controllerId == 'ControllerA') {
          if (parts[1] == 'ButtonA') {
            if (_gameA.overlays.activeOverlays.isEmpty) {
              _gameA.onAButtonPressed(Pressed);
              if (_gameA.score >= 100) {
                _gameA.winning();
                _gameB.losing();
              }
            }
          } else if (parts[1] == 'ButtonB') {
            if (_gameA.overlays.activeOverlays.isEmpty) {
              // _gameA.onBButtonPressed(Pressed);
            }
          }
        } else if (controllerId == 'ControllerB') {
          if (parts[1] == 'ButtonA') {
            if (_gameB.overlays.activeOverlays.isEmpty) {
              _gameB.onAButtonPressed(Pressed);
              if (_gameB.score >= 100) {
                _gameB.winning();
                _gameA.losing();
              }
            } else if (parts[1] == 'ButtonB') {
              if (_gameB.overlays.activeOverlays.isEmpty) {
                //_gameB.onBButtonPressed(Pressed);
              }
            }
          }
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
            colors: [Colors.green, Colors.blue],
          ),
        ),
        child: Row(
          children: [
            Column(
              children: [
                Image.asset(
                  'assets/boxsmasher/images/BoxSmasherMap.png',
                  scale: 0.5,
                ),
              ],
            ),
            const Spacer(),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    color: Colors.black,
                    child: const SizedBox(
                      width: 450,
                      height: 300,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'In this game you need to push 100 boxes into your new house to win.\n\n '
                              'You can push the boxes by pressing the A button.\n\n '
                              'Good luck! Select your controllers to start the game.',
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
                  padding: const EdgeInsets.only(right: 15.0, bottom: 15.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(150, 50),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              ControllerABoxSmasherPage(send: sendOthersTCP),
                        ),
                      );
                    },
                    child: const Text('Player A', style: TextStyle(color: Colors.black)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 65.0, right: 15.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(150, 50),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              ControllerBBoxSmasherPage(send: sendOthersTCP),
                        ),
                      );
                    },
                    child: const Text('Player B' , style: TextStyle(color: Colors.black)),
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
    return BoxSmasherMainMenu(send: sendOthersTCP, gameA: _gameA, gameB: _gameB);
  }

  @override
  String name() => "BoxSmasher";
}
