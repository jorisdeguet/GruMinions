// Make a mode where minion light in a succession with sound and color.

// player has to redo the sequence, then sequence gets longer.

import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_p2p_connection/flutter_p2p_connection.dart';
import 'package:get/get.dart';
import 'package:gru_minions/comm/message.dart';
import 'package:gru_minions/modes/base-mode.dart';
import 'package:gru_minions/service/gru_service.dart';
import 'package:gru_minions/service/utils.dart';

enum SimonStatus { showing, playing, waiting }

class SimonMode extends GruMinionMode {
  final Random _rand = Random();

  SimonStatus _gruStatus = SimonStatus.waiting;
  final List<String> _gruSequence = [];
  int _gruIndex = 0;

  late int _minionType = _rand.nextInt(4);
  late Color _minionColor = _colors()[_minionType];
  late String _minionNote = notes()[_minionType];
  double _minionPadding = 0;

  SimonMode({required super.sendToOthers});

  @override
  void handleMessageAsGru(String s) {
    print("======================================= $s   $_gruStatus");
    print(_gruSequence.toString());
    if (_gruStatus == SimonStatus.showing) {
      // ignore
      // if a touch happens while I play the sequence do not do nothing
      if (s == "doneShowing") {
        _gruStatus = SimonStatus.playing;
        print("Gru status is playing");
      }
    } else if (_gruStatus == SimonStatus.waiting) {
      // any touch and we show
      // if a touch happens while I play the sequence do not do nothing
      _gruStatus = SimonStatus.showing;
      _addOneToSequence();
    } else if (_gruStatus == SimonStatus.playing) {
      print("Gru got touch playing  $s");
      if (s.contains("touch")) {
        String adresse = s.split("touch")[0];
        print("Gru Someone touched$adresse gruIndex $_gruIndex");
        if (_gruIndex < _gruSequence.length &&
            estMemeAdresse(adresse, _gruSequence[_gruIndex])) {
          print("Gru OK for note$_gruIndex");
          _gruIndex++;
          if (_gruIndex == _gruSequence.length) {
            print("Win");
            playSound("assets/halloween/mouahaha.m4a");
            Timer(const Duration(milliseconds: 3000), () {
              print(
                  "AAAAAAAAAAAAAAADDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD ONE");
              _gruIndex = 0;
              _addOneToSequence();
            });
            // gruIndex = 0;
            // TODO play sound
            //playSound("assets/halloween/tonnerre.m4a");
            // TODO ajouter un a la sequence
            //addOneToSequence();
          }
        } else {
          playSound("assets/non.mp3");
          _gruStatus = SimonStatus.waiting;
          _gruIndex = 0;
          _gruSequence.clear();
          //addOneToSequence();
          // foirade
          // jouer un son
          // repartir la sequence
        }
      }
    }
  }

  String _atRandom(List<Client> clients) {
    return clients[_rand.nextInt(clients.length)].deviceAddress;
  }

  @override
  void handleMessageAsMinion(String s) {
    _minionPadding = 0;
    if (s.startsWith("{")) {
      _traiterSequence(s);
    }
    if (s.contains(":::")) {
      String adresse = s.split(":::")[0];
      if (estMonAdresse(adresse)) {
        _minionType = int.parse(s.split(":::")[1]);
        _minionColor = _colors()[_minionType];
        _minionNote = notes()[_minionType];
      }
    }
    if (s == "off") {
      //minionColor = Colors.white;
      _minionPadding = 0;
    }
  }

  void _traiterSequence(String s) async {
    SimonSequence sequence = SimonSequence.fromJson(jsonDecode(s));
    print("Minion pieces $sequence");
    String adresse = sequence.sequence[0];
    if (estMonAdresse(adresse)) {
      _minionPadding = 80;
      // je dois jouer ma note n fois
      while (
          sequence.sequence.isNotEmpty && estMonAdresse(sequence.sequence[0])) {
        print("Je joue ma note ${sequence.sequence}");
        playSound(_minionNote);
        await Future.delayed(const Duration(milliseconds: 400));
        sequence.sequence = sequence.sequence.sublist(1);
      }
      if (sequence.sequence.isNotEmpty) {
        sendToOthers(jsonEncode(sequence.toJson()));
      } else {
        sendToOthers("doneShowing");
      }
    } else {
      _minionPadding = 0;
    }
  }

  @override
  void initGru() {
    GruService service = Get.find<GruService>();
    List<Client> clients = service.info!.clients;
    print("--------------------------------------------------");

    int type = 0;
    for (Client s in clients) {
      print(" client ${s.deviceAddress}");
      sendToOthers("${s.deviceAddress}:::$type");
      type++;
    }
    _gruStatus = SimonStatus.waiting;
  }

  @override
  void initMinion() {
    _minionColor = _colors()[_minionType];
    _minionNote = notes()[_minionType];
  }

  @override
  Widget minionWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(_minionPadding),
      child: GestureDetector(
        onTap: () {
          print("Minion tap note ");
          playSound(_minionNote);
          sendToOthers("${macAddress()}touch");
          print("Minion tap note has sent to others ");
        },
        child: Container(
          color: _minionColor,
        ),
      ),
    );
  }

  @override
  String name() => "simon";

  void _addOneToSequence() {
    GruService service = Get.find<GruService>();
    List<Client> clients = service.info!.clients;
    print("--------------------------------------------------");
    for (Client s in clients) {
      print(" client ${s.deviceAddress}");
    }
    print("--------------------------------------------------");
    _gruSequence.add(_atRandom(clients));
    _playSequence();
  }

  @override
  Widget gruWidget() {
    return Column(
      children: [
        Text("SIMON $_gruSequence"),
        const Spacer(),
        MaterialButton(
          color: Colors.green,
          onPressed: () {
            _gruIndex = 0;
            _addOneToSequence();
          },
          child: const Text("test"),
        ),
        const Spacer(),
        MaterialButton(
          color: Colors.red,
          onPressed: () {
            _gruSequence.clear();
            _gruIndex = 0;
          },
          child: const Text("clear"),
        ),
      ],
    );
  }

  void _playSequence() async {
    _gruStatus = SimonStatus.showing;
    SimonSequence message = SimonSequence();
    message.sequence = _gruSequence;

    String messageString = jsonEncode(message.toJson());
    print(messageString);
    sendToOthers(messageString);
  }

  List<String> notes() {
    return [
      "assets/piano/A3.mp3",
      "assets/piano/B3.mp3",
      "assets/piano/C3.mp3",
      "assets/piano/D3.mp3",
    ];
  }

  List<Color> _colors() {
    return [
      Colors.yellow,
      Colors.blueAccent,
      Colors.greenAccent,
      Colors.red,
    ];
  }

  void _playNoteAndPassToTheNext(String reste) async {
    // TODO TANT QUE C'EST MOI NE PAS ENVOYER DE MESSAGE, ATTENDRE ET REJOUER LA NOTE

    playSound(_minionNote);
    _minionPadding = 80;
    Timer(const Duration(milliseconds: 400), () {
      print("Minion sends the rest of the sequence $reste");
      sendToOthers(reste);
    });
  }
}
