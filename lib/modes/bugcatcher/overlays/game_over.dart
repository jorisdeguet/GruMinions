import 'package:flutter/material.dart';

import '../bugcatcher_question.dart';
import '../bugcatcher_game.dart';

class GameOver extends StatelessWidget {
  static const String iD = 'GameOver';
  final BugCatcherGame game;
  const GameOver({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
     return gameOver(context);
  }

  Widget gameOver(BuildContext context){
    const blackTextColor = Color.fromRGBO(0, 0, 0, 1);
    const whiteTextColor = Color.fromRGBO(255, 255, 255, 1);
    game.pauseEngine();
    goToQuestion(context);

    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(10),
          height: 250,
          width: 350,
          decoration: const BoxDecoration(
            color: blackTextColor,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Time is Up!',
                style: TextStyle(
                  color: whiteTextColor,
                  fontSize: 24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> goToQuestion(BuildContext context) async {
    Future.delayed(const Duration(seconds: 2), () {
      bool isCorrect;
      if(game.counter == game.numberOfBugsToFind){
        isCorrect = true;
      } else {
        isCorrect = false;
      }
      game.overlays.remove(GameOver.iD);
      Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Question(NumberOfBugsToFind: game.numberOfBugsToFind, NumberTypeBugToFind: game.numberTypeBugToFind, correct: isCorrect, count: game.counter),
          ));
    });
  }


}