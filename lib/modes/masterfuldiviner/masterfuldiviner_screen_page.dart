import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:gru_minions/modes/masterfuldiviner/masterfuldiviner_game.dart';

class ScreenMasterfulDivinerPage extends StatefulWidget {
  final MasterfulDivinerGame gameA;

  const ScreenMasterfulDivinerPage(
      {super.key, required this.gameA});

  @override
  ScreenMasterfulDivinerState createState() => ScreenMasterfulDivinerState();
}

class ScreenMasterfulDivinerState extends State<ScreenMasterfulDivinerPage> {
  late MasterfulDivinerGame controllerAGame = widget.gameA;

  Widget theGameWidget(MasterfulDivinerGame game) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: GameWidget(game: game),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(0, 0, 0, 1),
        body: Row(
          children: [
            Expanded(
              child: theGameWidget(controllerAGame),
            ),
          ],
        )
    );
  }
}
