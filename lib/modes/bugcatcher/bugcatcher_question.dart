import 'package:flutter/material.dart';

import 'bugcatcher_game.dart';
import 'bugcatcher_screen_page.dart';
class Question extends StatelessWidget {
  final int NumberTypeBugToFind;
  final int NumberOfBugsToFind;
  final int count;
  final bool correct;
  Question({super.key, required this.NumberTypeBugToFind, required this.NumberOfBugsToFind, required this.correct, required this.count});

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
    return Image.asset('assets/bugcatcher/flame/$NumberTypeBugToFind.png', width: 50, scale: 0.1,);
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
          child: Text("$count was your answer.", style: const TextStyle(color: Colors.white, fontSize: 24)),
        ),
      ],
    );
  }

  Widget areYouCorrect(){
    if(correct){
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(0, 0, 0, 1),
        body: Stack(
          children: [
            Align(
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
                  MaterialButton(
                    onPressed: () {
                        Navigator.of(context).pop();
                    },
                    child: const Text('Back To Main Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
                  ),
                ],
              ),
            ),
          ],
        )
    );
  }
}