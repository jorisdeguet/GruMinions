// piano mode make // requires matrix mode

// Each minions displays a bunch of white and black button that plays notes

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gru_minions/modes/base-mode.dart';
import 'package:gru_minions/service/utils.dart';

class PianoMode extends GruMinionMode {
  PianoMode({required super.sendToOthers});

  @override
  void handleMessageAsGru(String s) {
    print("Nothing to do");
  }

  @override
  void handleMessageAsMinion(String s) {
    print("Nothing to do");
  }

  @override
  Widget minionWidget(BuildContext context) {
    return getPiano(Random().nextInt(5) + 1);
  }

  @override
  String name() => "piano";

  @override
  void initGru() {}

  @override
  void initMinion() {}

  @override
  Widget gruWidget() {
    return const Text("TODO");
  }

  Widget getPiano(int octave) {
    Map<String, Color> notes = {
      "A": Colors.red,
      "B": Colors.yellow,
      "C": Colors.orange,
      "D": Colors.blue,
      "E": Colors.green,
      "F": Colors.purple,
      "G": Colors.pink
    };
    List<Widget> notesWidgets = [];
    for (var note in notes.keys) {
      notesWidgets.add(Expanded(child: tapForNote(note, octave, notes[note]!)));
    }
    return Column(
      children: notesWidgets,
    );
  }

  Widget tapForNote(String note, int octave, Color color) {
    String fileName = "assets/piano/$note$octave.mp3";
    print("Piano for $fileName");
    return GestureDetector(
      child: Container(
        color: color,
      ),
      onTapDown: (e) {
        String fileName = "assets/piano/$note$octave.mp3";
        sendToOthers("played $note");
        print("Piano for $fileName");
        playSound(fileName);
      },
    );
  }
}
