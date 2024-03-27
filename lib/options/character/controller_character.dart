import 'package:carousel_slider/carousel_slider.dart';
import 'package:flame/components.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stroke_text/stroke_text.dart';

class ControllerCharacter extends StatefulWidget {
  const ControllerCharacter({super.key, required this.send});

  final Function send;

  @override
  State<ControllerCharacter> createState() => _ControllerCharacterState();
}

class _ControllerCharacterState extends State<ControllerCharacter> {
  final CarouselController _controller = CarouselController();
  late int _current = 0;

  @override
  Widget build(BuildContext context) {
    List<Character> characters = [
      Character(
          image: "Main Characters/Mask Dude/Run (32x32).png",
          name: "Mask Dude",
          color: const Color(0xffea71bd)),
      Character(
          image: "Main Characters/Ninja Frog/Run (32x32).png",
          name: "Ninja Frog",
          color: const Color(0xff6cd9f1)),
      Character(
          image: "Main Characters/Pink Man/Run (32x32).png",
          name: "Pink Man",
          color: const Color(0xffcc3048)),
      Character(
          image: "Main Characters/Virtual Guy/Run (32x32).png",
          name: "Virtual Guy",
          color: const Color(0xff288610)),
    ];

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
                                path: "Main Characters/${item.name}/Idle (32x32).png",
                                //running
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
                      ), //replace with sprite animation
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
            options: CarouselOptions(enlargeCenterPage: true, height: 300),
            carouselController: _controller,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  _controller.previousPage();
                  if(_current > 0){
                    _current - 1;
                  }
                  else{
                    _current = 3;
                  }
                  widget.send(characters[_current].name);
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
                onTap: () {
                  //stock character name
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
                  if(_current < 3){
                    _current + 1;
                  }
                  else{
                    _current = 0;
                  }
                  widget.send(characters[_current].name);
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

class Character {
  final String image;
  final String name;
  final Color color;

  Character({required this.image, required this.name, required this.color});
}
