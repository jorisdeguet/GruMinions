
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_p2p_connection/flutter_p2p_connection.dart';
import 'package:gru_minions/screens/gru.dart';
import 'package:gru_minions/screens/minion.dart';
import 'package:gru_minions/utils.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage();

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late CameraDescription frontCamera;

  @override
  void initState() {
    initCamera();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Accueil"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: MaterialButton(
                onPressed: () {
                  askPermissions();
                },
                child: Text("Permissions"),
              ),
            ),
            //Spacer(),
            Expanded(
              child: MaterialButton(
                color: Colors.blue,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  GruPage()),
                  );
                },
                child: Text("Gru mode", style: TextStyle(fontSize: 40),),
              ),
            ),
            // Spacer(),
            Expanded(
              child: MaterialButton(
                color: Colors.yellow,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  MinionPage(camera: frontCamera)),
                  );
                },
                child: Text("Minion mode"),
              ),
            ),
            // Spacer(),

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  void initCamera() async {
    final cameras = await availableCameras();
    frontCamera = cameras.last;
  }
}
