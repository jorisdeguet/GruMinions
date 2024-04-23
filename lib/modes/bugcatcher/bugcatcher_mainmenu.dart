import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:gru_minions/modes/bugcatcher/bugcatcher_game.dart';
import 'package:gru_minions/modes/bugcatcher/bugcatcher_screen_page.dart';

import 'overlays/instructions.dart';

class BugCatcherMainMenuPage extends StatefulWidget {
  final Function send;
  late BugCatcherGame gameA;
  BugCatcherMainMenuPage({super.key, required this.send, required this.gameA});

  @override
  BugCatcherMainMenuState createState() => BugCatcherMainMenuState();
}

class BugCatcherMainMenuState extends State<BugCatcherMainMenuPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: const Color.fromRGBO(0, 0, 0, 1),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Bug Catcher',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                      ),
                    ),

                  ],
                ),
                const SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FilledButton(
                      onPressed: (){
                        widget.gameA.resumeEngine();
                        widget.gameA.count = 0;
                        FlameAudio.bgm.isPlaying ? null : FlameAudio.bgm.play('bugcatcher/bugcatcher_bgm.mp3');
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                ScreenBugCatcherPage(gameA: widget.gameA),
                          ),
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                      ),
                      child: const Text('Commencer Jeu', style: TextStyle(color: Colors.black, fontSize: 20),),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ],
        ),
      );
  }
}