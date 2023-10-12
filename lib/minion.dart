
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_p2p_connection/flutter_p2p_connection.dart';
import 'package:mac_address/mac_address.dart';
//import 'package:get_mac_address/get_mac_address.dart';

class MinionPage extends StatefulWidget {
  MyHomePage(){}

  @override
  State<MinionPage> createState() => _MinionPageState();
}

class _MinionPageState extends State<MinionPage> with WidgetsBindingObserver  {

  WifiP2PInfo? wifiP2PInfo;

  // les autres appareils
  List<DiscoveredPeers> peers = [];

  final _flutterP2pConnectionPlugin = FlutterP2pConnection();

  StreamSubscription<WifiP2PInfo>? _streamWifiInfo;
  StreamSubscription<List<DiscoveredPeers>>? _streamPeers;

  String _macAddress = "";

  Color backgroundColor = Colors.white;

  bool searchingForGru = true;

  bool connectedToGru = false;

  @override
  void initState() {
    super.initState();
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
    if (connectedToGru) {
      return Container(
        width: double.infinity,
        color: backgroundColor,
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Spacer(),
            Expanded(
              child: MaterialButton(
                onPressed: () {
                  _flutterP2pConnectionPlugin.sendStringToSocket("Hi " +_macAddress);
                },
                child: Text(""),
              ),
            ),
            Spacer(),
          ],
        ),
      );
    } else {
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

          searchingForGru ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Searching for Gru ... ' ,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ) : Text("Gru found"),
          Expanded(
            child: ListView(
              children: this.peers.map(convert).toList(),
            ),
          )
        ],
      );
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
          //print(socket_connect.toString());
          // if (!socket_connect){
          //   print("Gru needs a socket");
          //   searchingForGru = true;
          //   setState(() {});
          // } else {
          //   searchingForGru = false;
          //   setState(() {});
          // }
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

  void minionHandleMessage( m) {
    if (m == "popi") {
      backgroundColor = Colors.redAccent;
    } else if (m == "pipo") {
      backgroundColor = Colors.yellow;
    } else if (m == "popo") {
      backgroundColor = Colors.brown;
      SystemSound.play(SystemSoundType.click);
      SystemSound.play(SystemSoundType.click);
      SystemSound.play(SystemSoundType.click);
      SystemSound.play(SystemSoundType.click);
    }
    setState(() {});
    print(m);
    SnackBar snackBar = SnackBar(content: Text('message  ' + m.toString()),);
    //ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

