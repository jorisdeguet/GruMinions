
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_p2p_connection/flutter_p2p_connection.dart';

class BossPage extends StatefulWidget {
  MyHomePage(){}

  @override
  State<BossPage> createState() => _BossPageState();
}

class _BossPageState extends State<BossPage> with WidgetsBindingObserver  {

  final _flutterP2pConnectionPlugin = FlutterP2pConnection();

  // les autres appareils
  List<DiscoveredPeers> peers = [];

  WifiP2PInfo? wifiP2PInfo;

  StreamSubscription<WifiP2PInfo>? _streamWifiInfo;
  StreamSubscription<List<DiscoveredPeers>>? _streamPeers;

  @override
  void initState() {
    super.initState();
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

    _streamWifiInfo = _flutterP2pConnectionPlugin.streamWifiP2PInfo().listen((event) {
      // Handle changes in connection
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
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Boss mode"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          MaterialButton(
            onPressed: () {
              print("TODO give me a name" );
            },
            child: Text("Boss mode"),


            //_flutterP2pConnectionPlugin.createGroup();
          ),
          Row(
            children: [
              Expanded(
                child: MaterialButton(
                  onPressed: () {
                    _flutterP2pConnectionPlugin.createGroup();
                  },
                  child: Text("creer le groupe"),

                ),
              ),
              Expanded(
                child: MaterialButton(
                  onPressed: () {
                    _flutterP2pConnectionPlugin.removeGroup();
                  },
                  child: Text("Détruire le groupe"),

                ),
              ),
            ],
          ),

          MaterialButton(
            onPressed: () async {
              try {
                var s = await _flutterP2pConnectionPlugin.connect(
                    wifiP2PInfo!.groupOwnerAddress);
                print(s);
              }catch(e){
                print(e);
              }
            },
            child: Text("connecter au groupe"),

          ),
          //
          MaterialButton(
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


          Row(
            children: [
              Expanded(
                child: MaterialButton(
                  onPressed: () {
                    startSocket();
                  },
                  child: Text("HOST : start socket"),

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
          MaterialButton(
            onPressed: () {
              _flutterP2pConnectionPlugin.sendStringToSocket("pipo");
            },
            child: Text("Envoyer pipo"),

          ),


          Row(
            children: [
              MaterialButton(
                onPressed: () {
                  _flutterP2pConnectionPlugin.discover();
                },
                child: Text("decouvrir les pairs"),

              ),
              MaterialButton(
                onPressed: () {
                  _flutterP2pConnectionPlugin.stopDiscovery();
                },
                child: Text("arreter la decouverte le groupe"),

              ),
            ],
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
          Text(
            'yo boss',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          Expanded(
            child: ListView(
              children: this.peers.map( convert).toList(),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {

        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
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
          print("$name connected to socket with address: $address");
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
          print("connected to socket: $address");
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

  Widget convert(DiscoveredPeers e) {
    return Container(
      // color: Colors.red,
      // height: 50,
      // width: 50,
      child: ListTile(
        title:  Text(e.deviceAddress) ,
        subtitle: Text(e.deviceName + e.isGroupOwner.toString()),
        leading: MaterialButton(
          onPressed: () async{
            var s = await _flutterP2pConnectionPlugin.connect(e.deviceAddress);
            print(s);

          },
          child: Text("CONNECT"),
        ),
      ),
    );
  }
}
