// piano mode make // requires matrix mode

// Each minions displays a bunch of white and black button that plays notes

import 'package:flutter/material.dart';
import 'package:gru_minions/utils.dart';

Widget getPiano(int octave) {
  Map<String, Color> notes = {
    "A": Colors.red,
    "B": Colors.yellow,
    "C": Colors.orange,
    "D": Colors.blue,
    "E": Colors.green,
    "F": Colors.purple,
    "G": Colors.pink};
  List<Widget> notesWidgets = [];
  for (var note in notes.keys) {
    notesWidgets.add(Expanded(child: tapForNote(note, octave, notes[note]!)));
  }
  return Column(
    children: notesWidgets,
  );
}
Widget tapForNote(String note, int octave, Color color) {
  String fileName = "assets/piano/"+note+octave.toString()+".mp3";
  print("Piano for " + fileName);
  return GestureDetector(
    child: Container(
      color: color,

    ),
    onTap: () {

      String fileName = "assets/piano/"+note+octave.toString()+".mp3";
      print("Piano for " + fileName);
      playSound(fileName);
    },
  );
}
