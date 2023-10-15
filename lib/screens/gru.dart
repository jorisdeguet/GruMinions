
import 'dart:async';
import 'dart:math';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_p2p_connection/flutter_p2p_connection.dart';
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
        print(event);
      });
    });
    _streamPeers = _flutterP2pConnectionPlugin.streamPeers().listen((event) {
      this.peers = event;
      print(event);
      setState(() {});
      print(peers);
    });
    try {
      _macAddress = await GetMac.macAddress ?? 'Unknown mac address';
      print("MAC address is " + _macAddress);
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
          Expanded(
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
                  child: wifiP2PInfo == null ? Container(height: 10, width: 10, color: Colors.red) :
                  ListTile(
                    leading: Text(wifiP2PInfo!.isGroupOwner.toString()),
                    title: Text(wifiP2PInfo!.groupOwnerAddress.toString()),
                    subtitle: Text(wifiP2PInfo!.clients.toString()),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: MaterialButton(
                    color: Colors.indigo,
                    onPressed: () {
                      _flutterP2pConnectionPlugin.sendStringToSocket("pipo");
                    },
                    child: Text("Envoyer pipo"),
                  ),
                ),
                Expanded(
                  child: MaterialButton(
                    color: Colors.indigoAccent,
                    onPressed: () {
                      _flutterP2pConnectionPlugin.sendStringToSocket("popi");
                    },
                    child: Text("Envoyer popi"),
                  ),
                ),
                Expanded(
                  child: MaterialButton(
                    color: Colors.lightBlue,
                    onPressed: () {
                      _flutterP2pConnectionPlugin.sendStringToSocket("popo");
                    },
                    child: Text("Envoyer popo"),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MaterialButton(
                  color: Colors.amber,
                    onPressed: choisisUnLapin,
                    child : Text("Tape le Lapin", style: TextStyle(fontSize: 25),)
                ),
                MaterialButton(
                  color: Colors.amberAccent,
                    onPressed: () {
                      _flutterP2pConnectionPlugin.sendStringToSocket("miroir");
                    },
                    child : Text("Miroir", style: TextStyle(fontSize: 25),)
                ),
                MaterialButton(
                    color: Colors.purple,
                    onPressed: () {
                      _flutterP2pConnectionPlugin.sendStringToSocket("piano");
                    },
                    child : Text("Piano", style: TextStyle(fontSize: 25),)
                ),
                MaterialButton(
                    color: Colors.amberAccent,
                    onPressed: () {
                      // playSound("assets/halloween/cri.m4a");
                      playSound("assets/halloween/mouahaha.m4a");
                      playSound("assets/halloween/tonnerre.m4a");
                      _flutterP2pConnectionPlugin.sendStringToSocket("halloween");
                    },
                    child : Text("Halloween!!", style: TextStyle(fontSize: 25),)
                )
              ],
            ),
          ),
          Row(
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
          ),
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
                    print(info!.groupNetworkName);
                    print(info!.isGroupOwner);
                    print(info!.passPhrase);
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
      await _flutterP2pConnectionPlugin.startSocket(
        groupOwnerAddress: wifiP2PInfo!.groupOwnerAddress!,
        // downloadPath is the directory where received file will be stored
        downloadPath: "/storage/emulated/0/Download/",
        // the max number of downloads at a time. Default is 2.
        maxConcurrentDownloads: 2,
        // delete incomplete transfered file
        deleteOnError: true,
        // handle connections to socket
        onConnect: (name, address) {
          socketActive = true;
          setState(() {});
          print("$name connected to socket with address: $address");
        },
        // receive transfer updates for both sending and receiving.
        transferUpdate: (transfer) {
          print(
              "ID: ${transfer.id}, FILENAME: ${transfer.filename}, PATH: ${transfer.path}, COUNT: ${transfer.count}, TOTAL: ${transfer.total}, COMPLETED: ${transfer.completed}, FAILED: ${transfer.failed}, RECEIVING: ${transfer.receiving}");
        },
        // handle string transfer from server
        receiveString: handleMessage,
      );
    }
  }

  void handleMessage(req) async {
    if (req.contains("hit")) {
      choisisUnLapin();
    }
    print(req);
    // SnackBar snackBar = SnackBar(
    //   content: Text('message  ' + req.toString()),
    // );
    // ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget convert(DiscoveredPeers e) {
    return ListTile(
      title:  Text(e.deviceAddress + " " + e.primaryDeviceType) ,
      subtitle: Text(e.deviceName + e.isGroupOwner.toString()),
      leading: MaterialButton(
        onPressed: () async {
          var s = await _flutterP2pConnectionPlugin.connect(e.deviceAddress);
          print(s);
        },
        child: Text("CONNECT"),
      ),
    );
  }

  Widget clients() {
    if (wifiP2PInfo == null) return Container();
    for (Client c in wifiP2PInfo!.clients) {
      print(c.deviceAddress);
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
    String nouvelleAdresse = wifiP2PInfo!.clients[Random().nextInt(wifiP2PInfo!.clients.length)].deviceAddress;
    do {
      nouvelleAdresse = wifiP2PInfo!.clients[Random().nextInt(wifiP2PInfo!.clients.length)].deviceAddress;
    } while(adresseDuLapin == nouvelleAdresse);
    adresseDuLapin = nouvelleAdresse;
    print("Lapin sera " + adresseDuLapin);
    _flutterP2pConnectionPlugin.sendStringToSocket(adresseDuLapin + "rabbit");
  }
}
