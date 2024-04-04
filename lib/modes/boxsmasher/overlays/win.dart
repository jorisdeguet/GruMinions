import 'package:flutter/material.dart';

import '../boxsmasher_game.dart';

class Win extends StatelessWidget {
  static const String iD = 'Win';
  final BoxSmasherGame game;
  const Win({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return win(context);
  }

  Widget win(BuildContext context){
    game.pauseEngine();
    return Center(
      child: Container(
        padding: const EdgeInsets.all(10),
        height: 300,
        width: 350,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(1.0),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 23.0),
              child: Text('You Win!', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.only(top: 23.0),
              child: Text('You have scored 100 points!', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.only(top: 23.0),
              child: Text('Congratulations!', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
          ],
        ),
      ),
    );
  }

}