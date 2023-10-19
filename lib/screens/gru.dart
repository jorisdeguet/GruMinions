
import 'dart:async';
import 'dart:math';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_p2p_connection/flutter_p2p_connection.dart';
import 'package:gru_minions/modes/base-mode.dart';
import 'package:gru_minions/modes/halloween.dart';
import 'package:gru_minions/modes/miroir.dart';
import 'package:gru_minions/modes/piano.dart';
import 'package:gru_minions/modes/tapelelapin.dart';
import 'package:gru_minions/screens/minion.dart';
import 'package:gru_minions/utils.dart';
import 'package:mac_address/mac_address.dart';

// TODO see how to detect if we have a socket working, if not create one
// TODO test a message targeted to one single minion.

class GruPage extends StatefulWidget {
  const GruPage({super.key});

  @override
  State<GruPage> createState() => _GruPageState();
}

class _GruPageState extends State<GruPage> with WidgetsBindingObserver  {

  final _flutterP2pConnectionPlugin = FlutterP2pConnection();

  List<DiscoveredPeers> peers = [];

  WifiP2PInfo? wifiP2PInfo;

  StreamSubscription<WifiP2PInfo>? _streamWifiInfo;
  StreamSubscription<List<DiscoveredPeers>>? _streamPeers;

  String _macAddress = "";

  bool socketActive = false;

  // TODO toute la gestion du mode est en fait la même pour Gru et Minion,

  late List<GruMinionMode> modes = [
    HalMode(sendToOthers: sendMessageToAll),
    PianoMode(sendToOthers: sendMessageToAll),
    Miroir.forGru(sendToOthers: sendMessageToAll),
    TapeLeLapin(sendToOthers: sendMessageToAll),
  ];

  late GruMinionMode currentMode = modes[0];

  void changeMode(String m) {
    for (GruMinionMode mode in modes) {
      if (m == mode.name()) {
        currentMode = mode;
      }
    }
    _flutterP2pConnectionPlugin.sendStringToSocket(m);
    setState(() {});
  }

  void sendMessageToAll(String m){
    _flutterP2pConnectionPlugin.sendStringToSocket(m);
  }


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _init();
    Timer(Duration(milliseconds: 2000), () {
      // Si on est dans un groupe avec connection ça peut marcher
      startSocket();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _flutterP2pConnectionPlugin.unregister();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _flutterP2pConnectionPlugin.unregister();
    } else if (state == AppLifecycleState.resumed) {
      _flutterP2pConnectionPlugin.register();
    }
  }

  void _init() async {
    await _flutterP2pConnectionPlugin.initialize();
    await _flutterP2pConnectionPlugin.register();
    _streamWifiInfo = _flutterP2pConnectionPlugin.streamWifiP2PInfo().listen((event) {
      setState(() {
        wifiP2PInfo = event;
        print("Gru " + event.toString());
      });
    });
    _streamPeers = _flutterP2pConnectionPlugin.streamPeers().listen((event) {
      this.peers = event;
      print("Gru " + event.toString());
      setState(() {});
      print("Gru " + peers.toString());
    });
    try {
      _macAddress = await GetMac.macAddress ?? 'Unknown mac address';
      print("Gru MAC address is " + _macAddress);
    } on PlatformException {
      _macAddress = 'Failed to get Device MAC Address.';
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Gru mode " + _macAddress),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          gestionGroupes(),
          gestionSocket(),
          gestionDesModes(),
          gestionDesPairs(),
          Text(
            'yo boss',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          Expanded(
            child: ListView(
              children: this.peers.map( convert).toList(),
            ),
          ),
          clients(),
        ],
      ),
    );
  }

  Row gestionDesPairs() {
    return Row(
          children: [
            Expanded(
              child: MaterialButton(
                onPressed: () {
                  _flutterP2pConnectionPlugin.discover();
                },
                child: Text("decouvrir les pairs"),

              ),
            ),
            Expanded(
              child: MaterialButton(
                onPressed: () {
                  _flutterP2pConnectionPlugin.stopDiscovery();
                },
                child: Text("arreter la decouverte le groupe"),
              ),
            ),
          ],
        );
  }

  Expanded gestionDesModes() {
    return Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MaterialButton(
                color: Colors.amber,
                  onPressed: () {
                    changeMode("tapelelapin");
                    choisisUnLapin();
                  },
                  child : Text("Tape le Lapin", style: TextStyle(fontSize: 25),)
              ),
              MaterialButton(
                color: Colors.amberAccent,
                  onPressed: () {
                    changeMode("miroir");
                  },
                  child : Text("Miroir", style: TextStyle(fontSize: 25),)
              ),
              MaterialButton(
                  color: Colors.purple,
                  onPressed: () {
                    changeMode("piano");
                  },
                  child : Text("Piano", style: TextStyle(fontSize: 25),)
              ),
              MaterialButton(
                  color: Colors.amberAccent,
                  onPressed: () {
                    // playSound("assets/halloween/cri.m4a");
                    playSound("assets/halloween/mouahaha.m4a");
                    playSound("assets/halloween/tonnerre.m4a");
                    changeMode("halloween");
                  },
                  child : Text("Halloween!!", style: TextStyle(fontSize: 25),)
              )
            ],
          ),
        );
  }

  Expanded gestionSocket() {
    return Expanded(
          child: Row(
            children: [
              Expanded(
                child: MaterialButton(
                  color: Colors.cyan,
                  onPressed: () {
                    startSocket();
                  },
                  child: Text(
                      "HOST : start socket",
                      style: TextStyle(fontSize: this.socketActive?10:30),
                  ),

                ),
              ),
              Expanded(
                child: Text("Socket " + socketActive.toString()),
              ),
              Expanded(
                child: wifiP2PInfo == null ? Container(height: 10, width: 10, color: Colors.red) :
                ListTile(
                  leading: Text(wifiP2PInfo!.isGroupOwner.toString()),
                  title: Text(wifiP2PInfo!.groupOwnerAddress.toString()),
                  subtitle: Text(wifiP2PInfo!.clients.toString()),
                ),
              )
            ],
          ),
        );
  }

  Row gestionGroupes() {
    return Row(
          children: [
            Expanded(
              child: MaterialButton(
                color: Colors.green,
                onPressed: () {
                  _flutterP2pConnectionPlugin.createGroup();
                },
                child: Text("creer le groupe"),

              ),
            ),
            Expanded(
              child: MaterialButton(
                onPressed: () async {
                  try {
                    WifiP2PGroupInfo? info = await _flutterP2pConnectionPlugin.groupInfo();
                    print("Gru " + info!.groupNetworkName);
                    print("Gru " + info!.isGroupOwner.toString());
                    print("Gru " + info!.passPhrase);
                  }catch(e){
                    print(e);
                  }
                },
                child: Text("Groupe Info"),
              ),
            ),
            Expanded(
              child: MaterialButton(
                color: Colors.red,
                onPressed: () {
                  _flutterP2pConnectionPlugin.removeGroup();
                },
                child: Text("Détruire le groupe"),
              ),
            ),
          ],
        );
  }

  Future startSocket() async {
    if (wifiP2PInfo != null) {
      var res = await _flutterP2pConnectionPlugin.startSocket(
        groupOwnerAddress: wifiP2PInfo!.groupOwnerAddress!,
        // downloadPath is the directory where received file will be stored
        downloadPath: "/storage/emulated/0/Download/",
        // the max number of downloads at a time. Default is 2.
        maxConcurrentDownloads: 2,
        // delete incomplete transfered file
        deleteOnError: true,
        // handle connections to socket
        onConnect: (name, address) {

          print("Gru $name connected to socket with address: $address");
        },
        // receive transfer updates for both sending and receiving.
        transferUpdate: (transfer) {
          print(
              "Gru ID: ${transfer.id}, FILENAME: ${transfer.filename}, PATH: ${transfer.path}, COUNT: ${transfer.count}, TOTAL: ${transfer.total}, COMPLETED: ${transfer.completed}, FAILED: ${transfer.failed}, RECEIVING: ${transfer.receiving}");
        },
        // handle string transfer from server
        receiveString: handleMessage,
      );
      if (res) {
        socketActive = true;
        setState(() {});
      }
    }
  }

  void handleMessage(req) async {
    if (req.contains("hit")) {
      choisisUnLapin();
    }
    currentMode.handleMessageAsGru(req);
    print("Gru received :::" + req);
  }

  Widget convert(DiscoveredPeers e) {
    return ListTile(
      title:  Text(e.deviceAddress + " " + e.primaryDeviceType) ,
      subtitle: Text(e.deviceName + e.isGroupOwner.toString()),
      leading: MaterialButton(
        onPressed: () async {
          var s = await _flutterP2pConnectionPlugin.connect(e.deviceAddress);
          print("Gru " + s.toString());
        },
        child: Text("CONNECT"),
      ),
    );
  }

  Widget clients() {
    if (wifiP2PInfo == null) return Container();
    for (Client c in wifiP2PInfo!.clients) {
      print("Gru " + c.deviceAddress);
    }
    return Expanded(
      child: ListView(
        children: wifiP2PInfo!.clients.map( convertClient).toList(),
      ),
    );
  }

  Widget convertClient(Client c){
    return ListTile(
      title: Text(" ew" + c.deviceName),
      subtitle: Text(c.deviceAddress),
    );
  }

  String adresseDuLapin = "";

  void choisisUnLapin() async {
    _flutterP2pConnectionPlugin.sendStringToSocket("tapelelapin");
    String nouvelleAdresse = wifiP2PInfo!.clients[Random().nextInt(wifiP2PInfo!.clients.length)].deviceAddress;
    do {
      nouvelleAdresse = wifiP2PInfo!.clients[Random().nextInt(wifiP2PInfo!.clients.length)].deviceAddress;
    } while(adresseDuLapin == nouvelleAdresse);
    adresseDuLapin = nouvelleAdresse;
    print("Gru Lapin sera " + adresseDuLapin);
    _flutterP2pConnectionPlugin.sendStringToSocket(adresseDuLapin + "rabbit");
  }
}
