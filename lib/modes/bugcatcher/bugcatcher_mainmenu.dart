import 'package:flutter/material.dart';
import 'package:gru_minions/modes/bugcatcher/bugcatcher_game.dart';
import 'package:gru_minions/modes/bugcatcher/bugcatcher_screen_page.dart';

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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Bug Catcher',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 50,
                  ),
                ),
                MaterialButton(
                    onPressed: (){
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              ScreenBugCatcherPage(gameA: widget.gameA),
                        ),
                      );
                    },
                    child: const Text('Start Game', style: TextStyle(color: Colors.white, fontSize: 20),),
                ),
              ],
            ),
          ),
          ],
        ),
      );
  }
}