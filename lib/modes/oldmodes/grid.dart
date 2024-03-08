import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_p2p_connection/flutter_p2p_connection.dart';
import 'package:get/get.dart';
import 'package:gru_minions/modes/base-mode.dart';
import 'package:gru_minions/service/gru_service.dart';
import 'package:gru_minions/service/utils.dart';

class GridState {
  final Map<(int, int), Client> _griddy = {};

  void _set(Client sender, int gruRow, int gruColumn) {
    var key = (gruRow, gruColumn);
    _griddy[key] = sender;
    _printGrid();
  }

  int _maxRow() {
    int result = 0;
    for ((int, int) key in _griddy.keys) {
      var (row, _) = key;
      if (row > result) result = row;
    }
    return result + 1;
  }

  int _maxCol() {
    int result = 0;
    for ((int, int) key in _griddy.keys) {
      var (_, col) = key;
      if (col > result) result = col;
    }
    return result + 1;
  }

  String _printGrid() {
    for ((int, int) key in _griddy.keys) {
      print("$key ${_griddy[key]!.deviceAddress}");
    }
    String res =
        "Grid is ==========================================================================";
    for (var r = 0; r < _maxRow(); r++) {
      res += "\n";
      for (var c = 0; c < _maxCol(); c++) {
        res += "  ";
        res += _griddy.containsKey((r, c))
            ? _griddy[(r, c)]!.deviceAddress
            : "Empty          ";
      }
    }
    return res;
  }

  void _reset() {
    _griddy.clear();
  }
}

class GridMode extends GruMinionMode {
  GridMode({required super.sendToOthers});

  int _gruRow = 0;
  int _gruColumn = 0;
  int _minionRow = 0;
  int _minionColumn = 0;
  bool _minionIsCalibrating = true;

  List<DeviceOrientation> _orientations = [
    DeviceOrientation.landscapeRight,
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.portraitDown,
  ];

  DeviceOrientation _minionOrientation = DeviceOrientation.landscapeRight;

  final GridState _gruGrid = GridState();

  @override
  void handleMessageAsGru(String s) {
    if (s.contains("|")) {
      String adresse = s.split("|")[0];
      //print("Gru got answer for " + adresse + " " + gruRow.toString() + " " + gruColumn.toString());
      // Add client to coordinates
      Client? sender = Get.find<GruService>().info!.clients.firstWhereOrNull(
          (element) => estMemeAdresse(element.deviceAddress, adresse));
      if (sender != null) {
        int r = int.parse(s.split("|")[1]);
        int c = int.parse(s.split("|")[2]);

        //debugPrint("Gru got client for position " + sender!.deviceAddress.toString());
        _gruGrid._set(sender, r, c);
        print("Size is ${_gruGrid._maxRow()} * ${_gruGrid._maxCol()}");
        print(_gruGrid._printGrid());
      }

      // ask the new one
      _gruColumn++;
      sendToOthers("select:$_gruRow:$_gruColumn");
    }
  }

  @override
  void handleMessageAsMinion(String s) {
    if (s.startsWith("select")) {
      _minionRow = int.parse(s.split(":")[1]);
      _minionColumn = int.parse(s.split(":")[2]);
    }
  }

  void handleMessageAsScreen(String s){}

  @override
  void initGru() {}

  @override
  void initMinion() {
    _minionIsCalibrating = true;
    _orientations = [
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitDown,
    ];
  }

  @override
  Widget screenWidget(BuildContext context) {
    return _minionWidget();
  }

  @override
  Widget minionWidget(BuildContext context) {
    return _minionWidget();
  }

  Widget _minionWidget() {
    SystemChrome.setPreferredOrientations([_minionOrientation]);
    if (!_minionIsCalibrating) {
      return const Text("TODO cmpute showing grid");
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          "Row $_minionRow",
          style: const TextStyle(fontSize: 30),
        ),
        Text(
          "Col $_minionColumn",
          style: const TextStyle(fontSize: 30),
        ),
        MaterialButton(
          color: Colors.greenAccent,
          onPressed: () {
            sendToOthers("${macAddress()}|$_minionRow|$_minionColumn");
          },
          child: const Text(
            "Appuie si c'est celle là",
            style: TextStyle(fontSize: 30),
          ),
        ),
        MaterialButton(
          color: Colors.greenAccent,
          onPressed: () {
            debugPrint(
                "-----------------------------------------------------------");
            print("$_orientations for  $_minionOrientation");
            int index = _orientations.indexOf(_minionOrientation);
            int next = (index + 1) % _orientations.length;
            print("index is $index > $next");
            _minionOrientation = _orientations[next];
            sendToOthers("${macAddress()}^^$_minionOrientation");
          },
          child: const Text(
            "Change orientation",
            style: TextStyle(fontSize: 30),
          ),
        ),
      ],
    );
  }

  @override
  Widget gruWidget() {
    return Column(
      children: [
        Row(children: [
          MaterialButton(
            onPressed: () {
              _gruGrid._reset();
              _gruRow = 0;
              _gruColumn = 0;
              sendToOthers("select:$_gruRow:$_gruColumn");
            },
            child: const Text(
              "start sequence",
              style: TextStyle(fontSize: 30),
            ),
          ),
          const Spacer(),
          MaterialButton(
            onPressed: () {
              print("next row");
              _gruRow++;
              _gruColumn = 0;
              sendToOthers("select:$_gruRow:$_gruColumn");
            },
            child: const Text(
              "Next row",
              style: TextStyle(fontSize: 30),
            ),
          ),
          const Spacer(),
          MaterialButton(
            onPressed: () {
              sendToOthers("finished ");
              Get.find<GruService>().grid = _gruGrid;
              // TODO save it in GruService ?
            },
            child: const Text(
              "Finished",
              style: TextStyle(fontSize: 30),
            ),
          ),
        ]),
        Expanded(
          child: Container(
            color: Colors.yellow,
            child: _gridRepresentation(),
          ),
        ),
      ],
    );
  }

  @override
  String name() => "grid";

  Widget _gridRepresentation() {
    List<Widget> rows = [];
    for (int r = 0; r < _gruGrid._maxRow(); r++) {
      List<Widget> cells = [];
      for (int c = 0; c < _gruGrid._maxCol(); c++) {
        Client? client = _gruGrid._griddy[(r, c)];
        cells.add(Expanded(
          child: MaterialButton(
            onPressed: () {
              if (client != null) {
                sendToOthers("ping ${client.deviceAddress}");
              }
            },
            child: Text(
                "$r $c : ${client == null ? "NOPE " : client.deviceAddress}"),
          ),
        ));
      }
      rows.add(Expanded(
          child: Row(
        children: cells,
      )));
    }
    return Column(
      children: rows,
    );
  }
}
