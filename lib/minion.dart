
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

  final _flutterP2pConnectionPlugin = FlutterP2pConnection();

  StreamSubscription<WifiP2PInfo>? _streamWifiInfo;
  StreamSubscription<List<DiscoveredPeers>>? _streamPeers;

  String _macAddress = "";

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
    _streamWifiInfo = _flutterP2pConnectionPlugin.streamWifiP2PInfo().listen((event) {
      // Handle changes in connection
    });
    _streamPeers = _flutterP2pConnectionPlugin.streamPeers().listen((event) {
      // Handle discovered peers
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
      body: Column(

        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          MaterialButton(

            onPressed: () async {
              print("TODO give me group info" );
              WifiP2PGroupInfo? info = await _flutterP2pConnectionPlugin.groupInfo();

              const snackBar = SnackBar(
                content: Text('Yay! A SnackBar!'),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);

              print(info.toString());
            },
            child: Text("Minion mode"),
          ),
          // MaterialButton(
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => const SecondRoute()),
          //     );
          //   },
          //   child: Text("Minion mode"),
          // ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Minion @ ' + _macAddress,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //
      //   },
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
