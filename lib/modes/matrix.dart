// matrix mode meta-mode :
// Gru gets Two TextFields for number of row and cols
// Gru tells each minion to light up successively
// by taping the corresponding on gru we get the (x,y) coords of each minion
// Gru can store this info for 2D position specific modes

import 'package:flutter/src/widgets/framework.dart';
import 'package:gru_minions/modes/base-mode.dart';

class MatrixMode extends GruMinionMode {
  MatrixMode({required super.sendToOthers});

  @override
  void handleMessageAsGru(String s) {
    // TODO: implement handleMessageAsGru
  }

  @override
  void handleMessageAsMinion(String s) {
    // TODO: implement handleMessageAsMinion
  }

  @override
  Widget minionWidget(BuildContext context) {
    // TODO: implement minionWidget
    throw UnimplementedError();
  }

  @override
  String name() {
    // TODO: implement name
    throw UnimplementedError();
  }

  @override
  void initGru() {}

  @override
  void initMinion() {
    // TODO: implement initMinion
  }

}