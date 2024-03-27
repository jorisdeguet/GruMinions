import 'package:flutter/material.dart';

import '../bugcatcher_question.dart';
import '../bugcatcher_game.dart';

class GameOver extends StatelessWidget {
  static const String iD = 'GameOver';
  final BugCatcherGame game;
  const GameOver({super.key, required this.game});

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
        future: goToQuestion(context),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot){
          if (snapshot.connectionState == ConnectionState.done) {
            return gameOver(context);
          } else {
            return const Padding(
                padding: EdgeInsets.all(24),
                child:  Center(
                  child: CircularProgressIndicator(
                      color: Color.fromRGBO(34, 157, 67, 1)),
                )
            );
          }
        }
    );
  }

  Widget gameOver(BuildContext context){
    const blackTextColor = Color.fromRGBO(0, 0, 0, 1);
    const whiteTextColor = Color.fromRGBO(255, 255, 255, 1);

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
      Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Question(NumberOfBugsToFind: game.numberOfBugsToFind, NumberTypeBugToFind: game.numberTypeBugToFind, correct: isCorrect, count: game.counter),
          ));
    });
  }


}