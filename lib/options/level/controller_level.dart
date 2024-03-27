import 'package:carousel_slider/carousel_slider.dart';
import 'package:flame/components.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stroke_text/stroke_text.dart';

class ControllerLevel extends StatefulWidget {
  final Function send;

  const ControllerLevel({
    super.key,
    required this.send,
  });

  @override
  State<ControllerLevel> createState() => _ControllerLevelState();
}

class _ControllerLevelState extends State<ControllerLevel> {
  final CarouselController _controller = CarouselController();
  late int _current = 0;

  @override
  Widget build(BuildContext context) {
    List<Level> levels = [
      Level(image: "Menu/Levels/01.png", name: "Level 01"),
      Level(image: "Menu/Levels/02.png", name: "Level 02"),
      Level(image: "Menu/Levels/03.png", name: "Level 03"),
    ];

    List<Widget> characterSliders = levels
        .map((item) => Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
          child: Stack(
            children: <Widget>[
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SpriteAnimationWidget.asset(
                  path: item.image,
                  //running
                  data: SpriteAnimationData.sequenced(
                    amount: 1,
                    stepTime: 1,
                    textureSize: Vector2(19, 17),
                    loop: true,
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
                text: 'Choose your level'.toUpperCase(),
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
              const SizedBox(
                height: 20,
              ),
              CarouselSlider(
                items: characterSliders,
                disableGesture: true,
                options: CarouselOptions(enlargeCenterPage: true, height: 200),
                carouselController: _controller,
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      _controller.previousPage();
                      _current = _current - 1;

                      if (_current < 0) {
                        _current = 2;
                      }
                      widget.send(levels[_current].name);
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
                      _current = _current + 1;
                      if (_current > 2) {
                        _current = 0;
                      }
                      widget.send(levels[_current].name);
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

class Level {
  final String image;
  final String name;

  Level({required this.image, required this.name});
}

