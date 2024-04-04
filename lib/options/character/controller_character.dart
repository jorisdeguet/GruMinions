import 'package:carousel_slider/carousel_slider.dart';
import 'package:flame/components.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stroke_text/stroke_text.dart';

import '../../comm/message.dart';
import '../../dialogs/successful_select.dart';
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
  late int _currentIndex;

  @override
  void initState() {
    // will set the current index depending on the character's name
    // check if the id is 1 or 2 to find the correct character
    if(id == 1) {
      _currentIndex = characters.indexWhere((element) => element.name == currentConfig.characterPlayer1);
      debugPrint('Index found: $_currentIndex');
    } else if(id == 2) {
      _currentIndex = characters.indexWhere((element) => element.name == currentConfig.characterPlayer2);
      debugPrint('Index found: $_currentIndex');
    }
    super.initState();
  }

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
            options: CarouselOptions(enlargeCenterPage: true, height: 300, initialPage: _currentIndex),
            carouselController: _controller,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  _controller.previousPage();
                  _currentIndex = _currentIndex - 1;

                  if (_currentIndex < 0) {
                    _currentIndex = 3;
                  }
                  widget.send('$id\'s current view:${characters[_currentIndex].name}');
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
                  //the local player is stocked
                  if(id == 1) {
                    currentConfig.characterPlayer1 = characters[_currentIndex].name;
                  } else if(id == 2) {
                    currentConfig.characterPlayer2 = characters[_currentIndex].name;
                  }
                  widget.send('$id has selected:${characters[_currentIndex].name}'); // send to stock it in the device with the screen role
                  showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => SuccessfulSelect(
                            characterName: characters[_currentIndex].name,
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
                  _currentIndex = _currentIndex + 1;
                  if (_currentIndex > 3) {
                    _currentIndex = 0;
                  }
                  widget.send('$id\'s current view:${characters[_currentIndex].name}');
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
