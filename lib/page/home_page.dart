import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gru_minions/page/main_gru_page.dart';
import 'package:gru_minions/page/main_minion_page.dart';
import 'package:gru_minions/page/main_screen_page.dart';
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _permissionsButton(context),
            _gruButton(context),
            _minionButton(context),
            // TODO: Add Screen option
            _screenButton(context)
          ],
        ),
      ),
    );
  }

  Widget _minionButton(BuildContext context) {
    return ElevatedButton(
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
        minimumSize: const Size(200, 100),
        shadowColor: Colors.grey,
        elevation: 5,
        side: const BorderSide(
            color: Colors.blueAccent, width: 2, style: BorderStyle.solid),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        tapTargetSize: MaterialTapTargetSize.padded,
      ),
      child: const Text("Mode Minion"),
    );
  }

  Widget _screenButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          // TODO : Change MaterialPageRoute to MainScreenPage
          MaterialPageRoute(builder: (context) => const MainScreenPage()),
        ).then((value) => _resetServices());
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Colors.yellow,
        textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        disabledForegroundColor: Colors.blue.withOpacity(0.38),
        disabledBackgroundColor: Colors.blue.withOpacity(0.12),
        minimumSize: const Size(200, 100),
        shadowColor: Colors.grey,
        elevation: 5,
        side: const BorderSide(
            color: Colors.blueAccent, width: 2, style: BorderStyle.solid),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        tapTargetSize: MaterialTapTargetSize.padded,
      ),
      child: const Text("Mode Écran"),
    );
  }

  Widget _permissionsButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        askPermissions();
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Colors.blueGrey,
        textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        disabledForegroundColor: Colors.blue.withOpacity(0.38),
        disabledBackgroundColor: Colors.blue.withOpacity(0.12),
        minimumSize: const Size(200, 100),
        shadowColor: Colors.grey,
        elevation: 5,
        side: const BorderSide(
            color: Colors.blueAccent, width: 2, style: BorderStyle.solid),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        tapTargetSize: MaterialTapTargetSize.padded,
      ),
      child: const Text("Permissions"),
    );
  }

  Widget _gruButton(BuildContext context) {
    return ElevatedButton(
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
        minimumSize: const Size(200, 100),
        shadowColor: Colors.grey,
        elevation: 5,
        side: BorderSide(
            color: Colors.redAccent.shade400,
            width: 2,
            style: BorderStyle.solid),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        tapTargetSize: MaterialTapTargetSize.padded,
      ),
      child: const Text("Mode Gru"),
    );
  }

  void _resetServices() {
    Get.delete<GruService>();
    Get.delete<MinionService>();
  }
}
