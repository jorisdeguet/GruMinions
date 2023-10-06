
import 'package:flutter/material.dart';
import 'package:flutter_p2p_connection/flutter_p2p_connection.dart';
import 'package:vieux_pixels/boss.dart';
import 'package:vieux_pixels/minion.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// https://pub.dev/packages/flutter_p2p_connection
class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    FlutterP2pConnection().checkStoragePermission();
    FlutterP2pConnection().askStoragePermission();
    FlutterP2pConnection().checkLocationPermission();
    FlutterP2pConnection().askLocationPermission();
    FlutterP2pConnection().checkLocationEnabled();
    FlutterP2pConnection().enableLocationServices();
    FlutterP2pConnection().checkWifiEnabled();
    FlutterP2pConnection().enableWifiServices();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MaterialButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  BossPage()),
                );
              },
              child: Text("Boss mode"),
            ),
            MaterialButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  MinionPage()),
                );
              },
              child: Text("Minion mode"),
            ),

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
