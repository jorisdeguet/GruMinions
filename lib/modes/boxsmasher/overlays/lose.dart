import 'package:flutter/material.dart';

import '../boxsmasher_game.dart';

class Lose extends StatelessWidget{
  static const String iD = 'Lose';
  final BoxSmasherGame game;
  const Lose({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return lose(context);
  }

  Widget lose(BuildContext context){
    game.pauseEngine();
    Future.delayed(const Duration(seconds: 3), () {
      game.score = 0;
      game.overlays.remove(Lose.iD);
      game.resumeEngine();
    });
    return Center(
      child: Container(
        padding: const EdgeInsets.all(10),
        height: 300,
        width: 350,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(1.0),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 23.0),
              child: Text('Vous avez perdu.', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(top: 23.0),
              child: Text('Vous avez fait ${game.score} points!', style: const TextStyle(color: Colors.white, fontSize: 24)),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.only(top: 23.0),
              child: Text('Meilleur chance la prochaine fois!', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
          ],
        ),
      ),
    );
  }
}