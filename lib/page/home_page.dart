import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gru_minions/page/control_page.dart';
import 'package:gru_minions/page/view_page.dart';
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
      body: Stack(
        children: <Widget>[
          Image(
            image: const AssetImage('assets/images/Background/Wallpaper.png'),
            fit: BoxFit.fill,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Welcome',
                  style: GoogleFonts.pixelifySans(
                    textStyle: const TextStyle(
                      fontSize: 100,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 100),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _controllerButton(context),
                    _screenButton(context),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
      floatingActionButton: _permissionsButton(context)
    );
  }

  Widget _controllerButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ControlPage()),
          ).then((value) => _resetServices());
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          disabledForegroundColor: Colors.blue.withOpacity(0.38),
          disabledBackgroundColor: Colors.blue.withOpacity(0.12),
          minimumSize: const Size(80, 80),
          shadowColor: Colors.grey,
          elevation: 5,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(2),
              bottomLeft: Radius.circular(2),
              bottomRight: Radius.circular(10),
            ),
          ),
          tapTargetSize: MaterialTapTargetSize.padded,
        ),
        child: Text(
          "Controller",
          style: GoogleFonts.pixelifySans(
            textStyle: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
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
            MaterialPageRoute(builder: (context) => const ViewPage()),
          ).then((value) => _resetServices());
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          disabledForegroundColor: Colors.blue.withOpacity(0.38),
          disabledBackgroundColor: Colors.blue.withOpacity(0.12),
          minimumSize: const Size(80, 80),
          shadowColor: Colors.grey,
          elevation: 5,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(2),
              bottomLeft: Radius.circular(2),
              bottomRight: Radius.circular(10),
            ),
          ),
          tapTargetSize: MaterialTapTargetSize.padded,
        ),
        child: Text(
          "Screen",
          style: GoogleFonts.pixelifySans(
            textStyle: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget _permissionsButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        askPermissions();
      },
      backgroundColor: Colors.white,
      child: const Icon(Icons.wifi, color: Colors.black,),
    );
  }

  void _resetServices() {
    Get.delete<GruService>();
    Get.delete<MinionService>();
  }
}
