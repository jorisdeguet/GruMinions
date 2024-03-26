import 'package:flutter/material.dart';

import '../mastefuldiviner_question.dart';
import '../masterfuldiviner_game.dart';

class GameOver extends StatelessWidget {
  static const String iD = 'GameOver';
  final MasterfulDivinerGame game;
  const GameOver({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Time is Up!',
                style: TextStyle(
                  color: whiteTextColor,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: 350,
                height: 75,
                child: ElevatedButton(
                  onPressed: () {
                    bool isCorrect;
                    if(game.counter == game.numberOfBugsToFind){
                      isCorrect = true;
                    } else {
                      isCorrect = false;
                    }
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => Question(NumberOfBugsToFind: game.numberOfBugsToFind, NumberTypeBugToFind: game.numberTypeBugToFind, correct: isCorrect, count: game.counter),
                    ));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: whiteTextColor,
                  ),
                  child: const Text(
                    'Answer The Question',
                    style: TextStyle(
                      color: blackTextColor,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}