import 'package:carousel_slider/carousel_slider.dart';
import 'package:flame/components.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stroke_text/stroke_text.dart';

import '../../comm/message.dart';
import '../../dialogs/successful_selected.dart';
import '../../models/character.dart';

class ControllerCharacter extends StatefulWidget {
  final Function send;

  const ControllerCharacter({super.key, required this.send});

  @override
  State<ControllerCharacter> createState() => _ControllerCharacterState();
}

class _ControllerCharacterState extends State<ControllerCharacter> {
  //final variables
  final CarouselController _controller = CarouselController();

  //late variables
  late int _current = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> characterSliders = characters
        .map((item) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        width: 500,
                        height: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: item.color,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 100,
                              height: 100,
                              child: SpriteAnimationWidget.asset(
                                path:
                                    "Main Characters/${item.name}/Idle (32x32).png",
                                data: SpriteAnimationData.sequenced(
                                  amount: 11,
                                  stepTime: 0.05,
                                  textureSize: Vector2(32, 32),
                                  loop: true,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 0.0,
                        left: 0.0,
                        right: 0.0,
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(200, 0, 0, 0),
                                Color.fromARGB(0, 0, 0, 0)
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          child: Text(
                            item.name,
                            style: GoogleFonts.pixelifySans(
                              textStyle: const TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ))
        .toList();

    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          StrokeText(
            text: 'Choose your character'.toUpperCase(),
            strokeColor: Colors.black,
            strokeWidth: 2,
            textStyle: GoogleFonts.pixelifySans(
              textStyle: const TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          CarouselSlider(
            items: characterSliders,
            disableGesture: true,
            options: CarouselOptions(enlargeCenterPage: true, height: 300),
            carouselController: _controller,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  _controller.previousPage();
                  _current = _current - 1;

                  if (_current < 0) {
                    _current = 3;
                  }
                  widget.send('View:${characters[_current].name}');
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: const Color(0xffa14744)),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: Color(0xffa14744),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  currentConfig.characterPlayer1 = characters[_current].name;
                  widget.send('Selected:${characters[_current].name}');
                  showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => SuccessfulSelected(
                            characterName: characters[_current].name,
                          ));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 120,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: const Color(0xffa14744)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Select',
                          style: GoogleFonts.pixelifySans(
                            textStyle: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xffa14744),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  _controller.nextPage();
                  _current = _current + 1;
                  if (_current > 3) {
                    _current = 0;
                  }
                  widget.send('View:${characters[_current].name}');
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: const Color(0xffa14744)),
                    ),
                    child: const Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0xffa14744),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    ));
  }
}
