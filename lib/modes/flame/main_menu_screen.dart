import 'package:flutter/material.dart';
import 'controller_a_game_page.dart';
import 'controller_b_game_page.dart';
import 'game.dart';
import 'screen_game_page.dart';

class MainMenuScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Controller'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ControllerAGamePage(send: (msg) {/* Handle message sending */})),
              ),
              child: Text('Controller A'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ControllerBGamePage(send: (msg) {/* Handle message sending */})),
              ),
              child: Text('Controller B'),
            ),
            ElevatedButton(
              onPressed: () {
                final game = MainGame();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ScreenGamePage(game: game)),
                );
              },
              child: Text('Screen'),
            ),
          ],
        ),
      ),
    );
  }
}
