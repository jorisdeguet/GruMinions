import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../game/pixel_adventure.dart';

class LifeBar extends StatelessWidget {
  const LifeBar({
    super.key,
    required this.life,
    required this.game,
  });

  //Final variables
  final ValueNotifier<double> life;
  final PixelAdventure game;

  Color getLifeBarColor() {
    if (life.value >= 60) {
      return Colors.green;
    } else if (life.value >= 40) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }

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
                  game.overlays.add('Menu');
                },
                child: Container(
                    width: 40,
                    height: 40.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Icon(
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
                        color: getLifeBarColor(),
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
                        fontWeight: FontWeight.w200,
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
