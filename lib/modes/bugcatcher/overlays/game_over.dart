import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../bugcatcher_game.dart';

class GameOver extends StatelessWidget {
  static const String iD = 'GameOver';
  final BugCatcherGame game;
  const GameOver({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
     return gameOver(context);
  }

  //#region How Well Did You Do
  Widget entireWellDidYouDo(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        howWellDidYouDoText(),
        const SizedBox(width: 20),
        imageOfBugToFind(),
        const SizedBox(width: 20),
        questionMark(),
      ],
    );
  }

  Widget howWellDidYouDoText(){
    return const Padding(
      padding: EdgeInsets.only(top: 23.0),
      child: Text('How well did you do', style: TextStyle(color: Colors.white, fontSize: 24)),
    );
  }

  Widget imageOfBugToFind(){
    return Image.asset('assets/bugcatcher/flame/${game.numberTypeBugToFind}.png', width: 50, scale: 0.1,);
  }

  Widget questionMark(){
    return const Padding(
      padding: EdgeInsets.only(top: 23.0),
      child: Text('?', style: TextStyle(color: Colors.white, fontSize: 24)),
    );
  }
  //#endregion

  Widget numberInAnswer(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 250,
          child: Text("${game.count} was your answer.", style: const TextStyle(color: Colors.white, fontSize: 24)),
        ),
      ],
    );
  }

  Widget areYouCorrect(){
    if(game.count == game.numberOfBugsToFind){
      return const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('You are correct!', style: TextStyle(color: Colors.green, fontSize: 32)),
        ],
      );
    } else {
      return const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('You are incorrect!', style: TextStyle(color: Colors.red, fontSize: 32)),
        ],
      );
    }
  }

  Widget spaceBetweenWidgets(){
    return const SizedBox(width: 20, height: 20);
  }

  Widget gameOver(BuildContext context){
    const blackTextColor = Color.fromRGBO(0, 0, 0, 1);
    const whiteTextColor = Color.fromRGBO(255, 255, 255, 1);
    game.pauseEngine();

    Future.delayed(const Duration(seconds: 5), () async {
      game.resetGame();
      game.overlays.remove(GameOver.iD);
      Navigator.of(context).pop();
    });

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
          child: Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                entireWellDidYouDo(),
                spaceBetweenWidgets(),
                numberInAnswer(),
                spaceBetweenWidgets(),
                areYouCorrect(),
                spaceBetweenWidgets(),
              ],
            ),
          ),
        ),
      ),
    );
  }


}