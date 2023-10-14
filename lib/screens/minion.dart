
import 'dart:async';
import 'dart:math';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_p2p_connection/flutter_p2p_connection.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:gru_minions/modes/halloween.dart';
import 'package:gru_minions/modes/piano.dart';
import 'package:mac_address/mac_address.dart';
import 'package:gru_minions/utils.dart';
//import 'package:get_mac_address/get_mac_address.dart';

class MinionPage extends StatefulWidget {

  final CameraDescription camera;

  const MinionPage({super.key, required this.camera});

  @override
  State<MinionPage> createState() => _MinionPageState();
}


enum MinionMode { config, mirror, tapelelapin, Halloween, piano }


// https://stackoverflow.com/questions/10968951/wi-fi-direct-and-normal-wi-fi-different-mac

// halloween mode, change image every 3 to 5 seconds. if touched all tablets play mouahahaha and reset their timers
//

class _MinionPageState extends State<MinionPage> with WidgetsBindingObserver  {

  MinionMode mode = MinionMode.config;
  String rabAdress = "";


  FlutterSoundPlayer _myPlayer = FlutterSoundPlayer();
  FlutterSoundRecorder _myRecorder = FlutterSoundRecorder();

  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  WifiP2PInfo? wifiP2PInfo;

  // les autres appareils
  List<DiscoveredPeers> peers = [];

  final _flutterP2pConnectionPlugin = FlutterP2pConnection();

  StreamSubscription<WifiP2PInfo>? _streamWifiInfo;
  StreamSubscription<List<DiscoveredPeers>>? _streamPeers;

  String _macAddress = "";

  Color backgroundColor = Colors.white;
  int padding = 10;

  bool connectedToGru = false;



  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    WidgetsBinding.instance.addObserver(this);
    _init();
    // camera shit
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );
    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
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
        print("==========================");
        print("   "+p.isGroupOwner.toString());
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
      case MinionMode.piano: {
        return getPiano(Random().nextInt(5));
      }
      case MinionMode.Halloween: {
        return GestureDetector(
              onTap: () {
                print("coucou");
              },
              child: Image.asset(getImageRandom())
          );
      }
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
                child: Text("Minion mode"),
              ),
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
      case MinionMode.tapelelapin:
        {
          String monAdresse = _macAddress.substring(2, 17).toUpperCase();
          String rabAdresse = rabAdress.substring(2, 17).toUpperCase();
          print("mon adresse = " + monAdresse + " adresse Lapin " + rabAdresse);
          bool isMe = (monAdresse == rabAdresse);
          return Column(
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  child: MaterialButton(
                    color: isMe ? Colors.white : Colors.white,
                    onPressed: () {
                      //
                      if (isMe) {
                        _flutterP2pConnectionPlugin.sendStringToSocket(_macAddress+"hit");
                      } else {
                        _flutterP2pConnectionPlugin.sendStringToSocket(_macAddress+"miss");
                      }
                    },
                    child: isMe ? Image.asset("assets/rabbit.png") : Image.asset("assets/mole.jpg") ,
                  ),
                ),
              )
            ],
          );
        }
      case MinionMode.mirror:
        {
          return Container(
            width: double.infinity,
            color: backgroundColor,
            child: GestureDetector(
              onTap: () {
                _flutterP2pConnectionPlugin.sendStringToSocket("Hi " +_macAddress);
              },
              onDoubleTap: () {
                takePicture(_controller);
              },
              onLongPress: () {

              },
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Spacer(),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(padding.toDouble()),
                      child: frontCameraPreview(),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      default: {
        return CircularProgressIndicator();
      }
    }
  }

  FutureBuilder<void> frontCameraPreview() {
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // If the Future is complete, display the preview.
          return CameraPreview(_controller);
        } else {
          // Otherwise, display a loading indicator.
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
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
        // downloadPath is the directory where received file will be stored
        downloadPath: "/storage/emulated/0/Download/",
        // the max number of downloads at a time. Default is 2.
        maxConcurrentDownloads: 2,
        // delete incomplete transfered file
        deleteOnError: true,
        // on connected to socket
        onConnect: (address) {
          // TODO swith the whole interface mode
          print("connected to socket: $address");
          connectedToGru = true;
          mode = MinionMode.mirror;
          setState(() {});
        },
        transferUpdate: (transfer) {
          print(
              "ID: ${transfer.id}, FILENAME: ${transfer.filename}, PATH: ${transfer.path}, COUNT: ${transfer.count}, TOTAL: ${transfer.total}, COMPLETED: ${transfer.completed}, FAILED: ${transfer.failed}, RECEIVING: ${transfer.receiving}");
        },
        // handle string transfer from server
        receiveString: minionHandleMessage,
      );
      return result;
    }
  }

  Future<XFile?> takePicture(CameraController? cameraController) async {
    if (cameraController!.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }
    try {
      XFile file = await cameraController.takePicture();
      print("Picture on " + _macAddress);
      return file;
    } on CameraException catch (e) {
      print('Error occured while taking picture: $e');
      return null;
    }
  }

  void minionHandleMessage( m) async {
    if (m == "popi") {
      backgroundColor = Colors.orange;
      padding = 0;
    } else if (m == "pipo") {
      padding = 10;
      //url.
    } else if (m == "piano") {
      mode = MinionMode.piano;
      setState(() {});
      //url.
    } else if (m == "halloween") {
      playSound("assets/halloween/mouahaha.m4a");
      mode = MinionMode.Halloween;
      startHalloween();
      //url.
    } else if (m == "miroir") {
      mode = MinionMode.mirror;
      setState(() {});
    } else if (m.contains("miss")) {
      playSound("assets/non.mp3");
    } else if (m == "popo") {
      backgroundColor = Colors.brown;
      padding = 0;
      SystemSound.play(SystemSoundType.click);
    } else {
      if (m.contains("rabbit")){
        // on passe en mode tape le lapin
        mode = MinionMode.tapelelapin;
        rabAdress = m.split("rab")[0];
        if (m.contains(_macAddress)) {
          print("Je suis le lapin");
        } else {
          print("Je suis une taupe");
        }
      }
    }
    setState(() {});
    print(m);
    //SnackBar snackBar = SnackBar(content: Text('message  ' + m.toString()),);
    //ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void startHalloween() {
    int delay = Random().nextInt(5000) + 1000;
    Timer(Duration(milliseconds: delay), () {
      // TODO change image
      print("TODO changer image sur " + _macAddress);
      setState(() {});
    });
  }
}

