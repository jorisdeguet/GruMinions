import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_p2p_connection/flutter_p2p_connection.dart';

class MinionPage extends StatefulWidget {
  @override
  State<MinionPage> createState() => _MinionPageState();
}

class _MinionPageState extends State<MinionPage> with WidgetsBindingObserver {
  final _flutterP2pConnectionPlugin = FlutterP2pConnection();

  // les autres appareils
  List<DiscoveredPeers> peers = [];

  WifiP2PInfo? wifiP2PInfo;

  StreamSubscription<WifiP2PInfo>? _streamWifiInfo;
  StreamSubscription<List<DiscoveredPeers>>? _streamPeers;

  @override
  void initState() {
    super.initState();
    print('JE SUIS UN MINION');
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
    await Future.delayed(Duration(seconds: 3));
    await _flutterP2pConnectionPlugin.initialize();
    await _flutterP2pConnectionPlugin.register();
    _flutterP2pConnectionPlugin.discover();
    _streamPeers = _flutterP2pConnectionPlugin.streamPeers().listen((event) {
      this.peers = event;
      print(event);
      setState(() {});
      print(peers);
    });

    _streamWifiInfo = _flutterP2pConnectionPlugin
        .streamWifiP2PInfo()
        .listen((WifiP2PInfo event) {
      wifiP2PInfo = event;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          MaterialButton(
            onPressed: () async {
              print("TODO give me group info");
              WifiP2PGroupInfo? info =
                  await _flutterP2pConnectionPlugin.groupInfo();

              const snackBar = SnackBar(
                content: Text('Yay! A SnackBar!'),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);

              print(info.toString());
            },
            child: Text("Minion mode"),
          ),
          Expanded(
            child: ListView(
              children: this.peers.map(convert).toList(),
            ),
          ),
          Expanded(
            child: MaterialButton(
              onPressed: () {
                connectToSocket();
              },
              child: Text("CLIENT : connect socket"),
            ),
          ),
        ],
      ),
    );
  }

  Widget convert(DiscoveredPeers e) {
    return Container(
      // color: Colors.red,
      // height: 50,
      // width: 50,
      child: ListTile(
        title: Text(e.deviceAddress),
        subtitle: Text(e.deviceName + e.isGroupOwner.toString()),
        leading: MaterialButton(
          onPressed: () async {
            var s = await _flutterP2pConnectionPlugin.connect(e.deviceAddress);
            print(s);
          },
          child: Text("CONNECT"),
        ),
      ),
    );
  }

  Future connectToSocket() async {
    if (wifiP2PInfo != null) {
      await _flutterP2pConnectionPlugin.connectToSocket(
        groupOwnerAddress: wifiP2PInfo!.groupOwnerAddress!,
        // downloadPath is the directory where received file will be stored
        downloadPath: "/storage/emulated/0/Download/",
        // the max number of downloads at a time. Default is 2.
        maxConcurrentDownloads: 2,
        // delete incomplete transfered file
        deleteOnError: true,
        // on connected to socket
        onConnect: (address) {
          SnackBar snackBar = const SnackBar(
            content: Text('Connecté à Gru'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        // receive transfer updates for both sending and receiving.
        transferUpdate: (transfer) {
          // transfer.count is the amount of bytes transfered
          // transfer.total is the file size in bytes
          // if transfer.receiving is true, you are receiving the file, else you're sending the file.
          // call `transfer.cancelToken?.cancel()` to cancel transfer. This method is only applicable to receiving transfers.
          print(
              "ID: ${transfer.id}, FILENAME: ${transfer.filename}, PATH: ${transfer.path}, COUNT: ${transfer.count}, TOTAL: ${transfer.total}, COMPLETED: ${transfer.completed}, FAILED: ${transfer.failed}, RECEIVING: ${transfer.receiving}");
        },
        // handle string transfer from server
        receiveString: (req) async {
          print(req);
          SnackBar snackBar = SnackBar(
            content: Text('message  ' + req.toString()),
          );

          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
      );
    }
  }
}
