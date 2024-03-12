import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gru_minions/modes/flame/game.dart';

import 'menu.dart';

class LifeBar extends StatelessWidget {
  const LifeBar({
    super.key,
    required this.life,
    required this.game,
  });

  final ValueNotifier<double> life;
  final MainGame game;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: life,
      builder: (context, score, child) {
        return Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: InkWell(
                onTap: () {
                  game.pauseEngine();
                  showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => Dialog(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Menu(game: game),
                          )));
                },
                child: Container(
                    width: 40,
                    height: 40.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: const Icon(
                      Icons.menu,
                      color: Color(0xFF211F30),
                    )),
              ),
            ),
            Container(
              width: 400.0,
              height: 40.0,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Stack(
                children: [
                  FractionallySizedBox(
                    widthFactor: life.value / 100,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      '${(life.value).toInt()}%',
                      style: GoogleFonts.pixelifySans(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
