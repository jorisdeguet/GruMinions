import 'package:flutter/material.dart';
import 'package:gru_minions/modes/bugcatcher/bugcatcher_game.dart';

class Instructions extends StatelessWidget{
  static const String iD = 'Instructions';
  final BugCatcherGame game;

  const Instructions({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return theInstructions(game);
  }
}

Widget theInstructions(BugCatcherGame game){
  const blackTextColor = Color.fromRGBO(0, 0, 0, 1);
  const whiteTextColor = Color.fromRGBO(255, 255, 255, 1);
  game.pauseEngine();

  return Material(
    color: Colors.transparent,
    child: Center(
      child: Container(
        padding: const EdgeInsets.all(10),
        height: 350,
        width: 350,
        decoration: const BoxDecoration(
          color: blackTextColor,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Instructions',
              style: TextStyle(
                color: whiteTextColor,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'Count this bug!',
              style: TextStyle(
                color: whiteTextColor,
                fontSize: 16,
              ),
            ),
            Image.asset('assets/bugcatcher/flame/${game.numberTypeBugToFind}.png', width: 50, scale: 0.1,),
            const SizedBox(height: 40),
            const Text(
              'Press A to start!',
              style: TextStyle(
                color: whiteTextColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
