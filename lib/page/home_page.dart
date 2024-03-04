import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gru_minions/page/main_gru_page.dart';
import 'package:gru_minions/page/main_minion_page.dart';
import 'package:gru_minions/service/gru_service.dart';
import 'package:gru_minions/service/minion_service.dart';
import 'package:gru_minions/service/utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    _resetServices();
    super.initState();
  }

  @override
  void didUpdateWidget(HomePage oldWidget) {
    _resetServices();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 400,
          height: 500,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.blueGrey.shade100,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Welcome', style: TextStyle(fontSize: 30)),
              _controllerButton(context),
              _screenButton(context),
              _permissionsButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _controllerButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MainGruPage()),
          ).then((value) => _resetServices());
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.red,
          textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          disabledForegroundColor: Colors.blue.withOpacity(0.38),
          disabledBackgroundColor: Colors.blue.withOpacity(0.12),
          minimumSize: const Size(80, 80),
          shadowColor: Colors.grey,
          elevation: 5,
          side: BorderSide(
              color: Colors.redAccent.shade400,
              width: 2,
              style: BorderStyle.solid),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          tapTargetSize: MaterialTapTargetSize.padded,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Icon(Icons.gamepad),
            ),
            Text("Controller"),
          ],
        ),
      ),
    );
  }

  Widget _screenButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0, left: 20.0, bottom: 20.0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MainMinionPage()),
          ).then((value) => _resetServices());
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: Colors.yellow,
          textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          disabledForegroundColor: Colors.blue.withOpacity(0.38),
          disabledBackgroundColor: Colors.blue.withOpacity(0.12),
          minimumSize: const Size(80, 80),
          shadowColor: Colors.grey,
          elevation: 5,
          side: const BorderSide(
              color: Colors.blueAccent, width: 2, style: BorderStyle.solid),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          tapTargetSize: MaterialTapTargetSize.padded,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Icon(Icons.screenshot_monitor_rounded),
            ),
            Text("Screen"),
          ],
        ),
      ),
    );
  }

  Widget _permissionsButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0, left: 20.0),
      child: ElevatedButton(
        onPressed: () {
          askPermissions();
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: Colors.yellow,
          textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          disabledForegroundColor: Colors.blue.withOpacity(0.38),
          disabledBackgroundColor: Colors.blue.withOpacity(0.12),
          minimumSize: const Size(80, 80),
          shadowColor: Colors.grey,
          elevation: 5,
          side: const BorderSide(
              color: Colors.blueAccent, width: 2, style: BorderStyle.solid),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          tapTargetSize: MaterialTapTargetSize.padded,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Icon(Icons.wifi),
            ),
            Text("Permissions"),
          ],
        ),
      ),
    );
  }

  void _resetServices() {
    Get.delete<GruService>();
    Get.delete<MinionService>();
  }
}
