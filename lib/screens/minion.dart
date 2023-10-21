
import 'dart:async';
import 'dart:math';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_p2p_connection/flutter_p2p_connection.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:gru_minions/modes/base-mode.dart';
import 'package:gru_minions/modes/halloween.dart';
import 'package:gru_minions/modes/miroir.dart';
import 'package:gru_minions/modes/piano.dart';
import 'package:gru_minions/modes/tapelelapin.dart';
import 'package:mac_address/mac_address.dart';
import 'package:gru_minions/utils.dart';
//import 'package:get_mac_address/get_mac_address.dart';

class MinionPage extends StatefulWidget {

  final CameraDescription camera;

  const MinionPage({super.key, required this.camera});

  @override
  State<MinionPage> createState() => _MinionPageState();
}


enum MinionMode { config, miroir, tapelelapin, halloween, piano }


// https://stackoverflow.com/questions/10968951/wi-fi-direct-and-normal-wi-fi-different-mac

// halloween mode, change image every 3 to 5 seconds. if touched all tablets play mouahahaha and reset their timers
//

class _MinionPageState extends State<MinionPage> with WidgetsBindingObserver  {

  String _macAddress = "";

  // les autres appareils / connectivité WiFi Direct
  List<DiscoveredPeers> peers = [];
  WifiP2PInfo? wifiP2PInfo;
  final _flutterP2pConnectionPlugin = FlutterP2pConnection();
  StreamSubscription<WifiP2PInfo>? _streamWifiInfo;
  StreamSubscription<List<DiscoveredPeers>>? _streamPeers;
  bool connectedToGru = false;


  // Gestion des modes
  MinionMode mode = MinionMode.config;
  late List<GruMinionMode> modes = [
    HalMode(sendToOthers: sendMessageToAll),
    PianoMode(sendToOthers: sendMessageToAll),
    Miroir.forMinion(camera: widget.camera,sendToOthers: sendMessageToAll),
    TapeLeLapin(sendToOthers: sendMessageToAll),
  ];

  late GruMinionMode currentMode = modes[0];



  void sendMessageToAll(String m){
    _flutterP2pConnectionPlugin.sendStringToSocket(m);
  }

  @override
  void initState() {
    super.initState();
    // Full screen mode
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    WidgetsBinding.instance.addObserver(this);
    _init();
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
    WidgetsFlutterBinding.ensureInitialized();

    await _flutterP2pConnectionPlugin.initialize();
    await _flutterP2pConnectionPlugin.register();
    await _flutterP2pConnectionPlugin.discover();
    _streamWifiInfo = _flutterP2pConnectionPlugin.streamWifiP2PInfo().listen((event) {
      // Handle changes in connection
      setState(() {
        wifiP2PInfo = event;
        print(event);
      });
    });
    _streamPeers = _flutterP2pConnectionPlugin.streamPeers().listen((event) async {
      // Handle discovered peers
      this.peers = [];
      for (DiscoveredPeers p in event){
        //print("==========================");
        //print("   "+p.isGroupOwner.toString());
        if (p.isGroupOwner) {
          this.peers.add(p);
        }
      }
      setState(() {});

    });
    try {
      _macAddress = await GetMac.macAddress ?? 'Unknown mac address';
      print("MAC address is " + _macAddress);
    } on PlatformException {
      _macAddress = 'Failed to get Device MAC Address.';
    }
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: mainBody(),
    );
  }

  Widget mainBody(){
    switch (mode) {
      case MinionMode.config:
        {
          return Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Spacer(),
              MaterialButton(
                onPressed: () async {
                  print("TODO give me group info" );
                  WifiP2PGroupInfo? info = await _flutterP2pConnectionPlugin.groupInfo();
                  var snackBar = SnackBar(
                    content: Text('Yay! A SnackBar! ' + (info==null? "no info":info!.toString()) ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  print(info.toString());
                },
                child: Text("Minion mode : group info"),
              ),
              MaterialButton(
                onPressed: () async {
                  print("Si ca connecte pas, essaie de redemander permissions" );
                  askPermissions();
                },
                child: Text("Connecte marche pas, demande permissios"),
              ),
              Text("Si le minion semble ne pas recevoir les messages, oublier le reseau wifi"),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Minion @ ' + _macAddress,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Searching for Gru ... ' ,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ) ,
              Expanded(
                child: ListView(
                  children: this.peers.map(convert).toList(),
                ),
              )
            ],
          );
        }
      default: {
        return currentMode.minionWidget(context);
      }
    }
  }

  Widget convert(DiscoveredPeers e) {
    return ListTile(
      title: Text(e.deviceAddress),
      subtitle: Text(e.deviceName + e.isGroupOwner.toString()),
      leading: MaterialButton(
        onPressed: () async {
          // potentiel Gru, try to connect
          var wifi_connect = await _flutterP2pConnectionPlugin.connect(
              e.deviceAddress);
          print(wifi_connect.toString());
          await connectToSocket();
        },
        child: Text("CONNECTE"),
      ),
    );
  }

  Future connectToSocket() async {
    if (wifiP2PInfo != null) {
      var result = await _flutterP2pConnectionPlugin.connectToSocket(
        groupOwnerAddress: wifiP2PInfo!.groupOwnerAddress!,
        downloadPath: "/storage/emulated/0/Download/",
        maxConcurrentDownloads: 2,
        deleteOnError: true,
        onConnect: (address) {
          // TODO swith the whole interface mode
          print("connected to socket: $address");
          connectedToGru = true;
          changeMode("miroir");
          setState(() {});
        },
        transferUpdate: (transfer) {
          print(
              "ID: ${transfer.id}, FILENAME: ${transfer.filename}, PATH: ${transfer.path}, COUNT: ${transfer.count}, TOTAL: ${transfer.total}, COMPLETED: ${transfer.completed}, FAILED: ${transfer.failed}, RECEIVING: ${transfer.receiving}");
        },
        receiveString: minionHandleMessage,
      );
      return result;
    }
  }

  void changeMode(String m) {
    for (GruMinionMode mode in modes) {
      if (m == mode.name()) {
        currentMode = mode;
      }
    }
    for (var value in MinionMode.values) {
      if( m == value.name){
        mode = value;
      }
    }
    setState(() {});
  }

  void minionHandleMessage( m) async {
    print(m);
    // Handle mode change messages
    changeMode(m);
    // La vraie gestion de la logique est déléguée au mode
    currentMode.handleMessageAsMinion(m);
  }

}

