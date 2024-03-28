import 'package:blinking_text/blinking_text.dart';
import 'package:flame/components.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ControllerSettings extends StatefulWidget {
  const ControllerSettings({super.key, required this.macAddress});

  final String macAddress;

  @override
  State<ControllerSettings> createState() => _ControllerSettingsState();
}

enum Options { english, spanish, french }

class _ControllerSettingsState extends State<ControllerSettings> {
  final TextEditingController languagesController = TextEditingController();
  double music = 50;
  double soundFX = 50;
  bool sound = true;
  bool fullScreen = true;
  Color player1Color = const Color(0xff30acd9);
  Color player2Color = const Color(0xffcc3048);
  Color color = const Color(0xffa14744);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              width: 300,
              height: 600,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black38,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Player 1',
                    style: GoogleFonts.pixelifySans(
                      textStyle: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: player1Color,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: SpriteAnimationWidget.asset(
                      path: "Main Characters/Pink Man/Idle (32x32).png",
                      //player 1's character
                      data: SpriteAnimationData.sequenced(
                        amount: 11,
                        stepTime: 0.05,
                        textureSize: Vector2(32, 32),
                        loop: true,
                      ),
                    ),
                  ),
                  BlinkText('Connected',
                      style: GoogleFonts.pixelifySans(
                        textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      beginColor: player1Color,
                      endColor: Colors.transparent,
                      times: 3600,
                      duration: const Duration(seconds: 2)),
                  const SizedBox(height: 40),
                  const Divider(
                    thickness: 2,
                    color: Colors.black38,
                    indent: 10,
                    endIndent: 10,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Text(
                    'Player 2',
                    style: GoogleFonts.pixelifySans(
                      textStyle: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: player2Color,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: SpriteAnimationWidget.asset(
                      path: "Main Characters/Virtual Guy/Idle (32x32).png",
                      //player 2's character
                      data: SpriteAnimationData.sequenced(
                        amount: 11,
                        stepTime: 0.05,
                        textureSize: Vector2(32, 32),
                        loop: true,
                      ),
                    ),
                  ),
                  BlinkText('Connected',
                      style: GoogleFonts.pixelifySans(
                        textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      beginColor: player2Color,
                      endColor: Colors.transparent,
                      times: 3600,
                      duration: const Duration(seconds: 2)),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              width: 600,
              height: 600,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Settings',
                    style: GoogleFonts.pixelifySans(
                      textStyle: TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.normal,
                        color: color,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Music ',
                        style: GoogleFonts.pixelifySans(
                          textStyle: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 300,
                        child: Slider(
                          min: 0,
                          max: 100,
                          activeColor: color,
                          inactiveColor: Colors.black12,
                          value: music,
                          onChanged: (value) {
                            setState(() {
                              music = value.floorToDouble();
                            });
                          },
                        ),
                      ),
                      Text(
                          '$music %',
                       style : GoogleFonts.pixelifySans(
                      textStyle: TextStyle(
                      fontSize: 30,
                        fontWeight: FontWeight.normal,
                        color: color,
                      ),
            ),
                      )
                    ],
                  ), //Music slider
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Sound FX ',
                        style: GoogleFonts.pixelifySans(
                          textStyle: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 300,
                        child: Slider(
                          min: 0,
                          max: 100,
                          activeColor: color,
                          inactiveColor: Colors.black12,
                          value: soundFX,
                          onChanged: (value) {
                            setState(() {
                              soundFX = value.floorToDouble();
                            });
                          },
                        ),
                      ),
                      Text(
                          '$soundFX %',
                        style: GoogleFonts.pixelifySans(
                          textStyle: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.normal,
                            color: color,
                          ),
                        ),
                      )
                    ],
                  ), //Sound FX slider
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Sound ',
                        style: GoogleFonts.pixelifySans(
                          textStyle: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                      ),
                      Switch(
                        value: sound,
                        activeColor: color,
                        onChanged: (bool value) {
                          setState(() {
                            sound = value;
                          });
                        },
                      ),
                      Text(
                        'Full Screen',
                        style: GoogleFonts.pixelifySans(
                          textStyle: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                      ),
                      Switch(
                        value: fullScreen,
                        activeColor: color,
                        onChanged: (bool value) {
                          setState(() {
                            fullScreen = value;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      DropdownMenu<Options>(
                        initialSelection: Options.english,
                        controller: languagesController,
                        //requestFocusOnTap: true,
                        enableSearch: false,
                        menuStyle: MenuStyle(
                          backgroundColor: MaterialStateProperty.all(color),
                        ),
                        textStyle: GoogleFonts.pixelifySans(
                          textStyle: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.normal,
                            color: color,
                          ),
                        ),
                        label: Text(
                            'Languages',
                          style: GoogleFonts.pixelifySans(
                            textStyle: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.normal,
                              color: color,
                            ),
                          ),
                        ),
                        onSelected: (Options? language) {
                          setState(() {
                            language = language;
                          });
                        },
                        dropdownMenuEntries: Options.values
                            .map<DropdownMenuEntry<Options>>(
                                (Options language) {
                          return DropdownMenuEntry<Options>(
                            value: language,
                            label: language.toString(),
                            enabled: language.toString() != 'english',
                          );
                        }).toList(),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  ), //Language dropdown
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
