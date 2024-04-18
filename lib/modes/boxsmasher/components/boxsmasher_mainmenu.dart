import 'package:flutter/material.dart';

import '../boxsmasher_game.dart';
import '../screen_boxsmasher_page.dart';

class BoxSmasherMenu extends StatefulWidget {
  final Function send;
  late BoxSmasherGame gameA;
  late BoxSmasherGame gameB;
  BoxSmasherMenu({super.key, required this.send, required this.gameA, required this.gameB});

  @override
  _BoxSmasherMenuState createState() => _BoxSmasherMenuState();
}

class _BoxSmasherMenuState extends State<BoxSmasherMenu> {
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
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Box Smasher',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FilledButton(
                      onPressed: (){
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                ScreenBoxSmasherPage(gameA: widget.gameA, gameB: widget.gameB, send: widget.send),
                          ),
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                      ),
                      child: const Text('Start Game', style: TextStyle(color: Colors.black, fontSize: 20),),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}