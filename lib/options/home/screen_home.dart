import 'package:blinking_text/blinking_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mac_address/mac_address.dart';
import 'package:stroke_text/stroke_text.dart';

class ScreenHome extends StatefulWidget {
  const ScreenHome({
    super.key,
  });

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  late String _macAddress = 'no mac';

  @override
  initState() {
    super.initState();
    initMac();
  }

  initMac() async {
    _macAddress = await GetMac.macAddress;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StrokeText(
              text: 'Pixel Adventure',
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
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 256,
                    height: 144,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: const Image(
                        image:
                        AssetImage('assets/images/Background/Level 01.gif'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 256,
                    height: 144,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: const Image(
                        image:
                        AssetImage('assets/images/Background/Level 02.gif'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 256,
                    height: 144,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: const Image(
                        image:
                        AssetImage('assets/images/Background/Level 03.gif'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            BlinkText('Continue on the controller',
                style: GoogleFonts.pixelifySans(
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                beginColor: Colors.black,
                endColor: Colors.transparent,
                times: 3600,
                duration: const Duration(seconds: 2)),
            BlinkText(_macAddress,
                style: GoogleFonts.pixelifySans(
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                beginColor: Colors.black,
                endColor: Colors.transparent,
                times: 3600,
                duration: const Duration(seconds: 2)),
          ],
        ),
      ),
    );
  }
}
