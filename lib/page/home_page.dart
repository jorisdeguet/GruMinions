import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gru_minions/page/controller_page.dart';
import 'package:gru_minions/page/screen_page.dart';
import 'package:gru_minions/service/controller_service.dart';
import 'package:gru_minions/service/screen_service.dart';
import 'package:gru_minions/service/utils.dart';
import 'package:stroke_text/stroke_text.dart';

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
              image:
                  const AssetImage('assets/images/Background/Wallpaper1.gif'),
              fit: BoxFit.fill,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
            BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      StrokeText(
                        text: 'Pixel Aventure Remake',
                        strokeColor: Colors.black,
                        strokeWidth: 2,
                        textStyle: GoogleFonts.pixelifySans(
                          textStyle: const TextStyle(
                            fontSize: 80,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 100),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _screenButton(context),
                          _controllerButton(context),
                        ],
                      ),
                    ],
                  ),
                )),
          ],
        ),
        floatingActionButton: _permissionsButton(context));
  }

  Widget _controllerButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 200,
        height: 60,
        child: ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Controller()),
            ).then((value) => _resetServices());
          },
          icon: const Icon(Icons.gamepad, color: Colors.black),
          label: Text(
            'Controller',
            style: GoogleFonts.pixelifySans(
              textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _screenButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 200,
        height: 60,
        child: ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ScreenPage()),
            ).then((value) => _resetServices());
          },
          icon: const Icon(Icons.tv, color: Colors.black),
          label: Text(
            'Screen',
            style: GoogleFonts.pixelifySans(
              textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
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
      child: const Icon(
        Icons.settings,
        color: Colors.black,
      ),
    );
  }

  void _resetServices() {
    Get.delete<ControllerService>();
    Get.delete<ScreenService>();
  }
}
