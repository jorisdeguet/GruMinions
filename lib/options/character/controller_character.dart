import 'package:carousel_slider/carousel_slider.dart';
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

  @override
  Widget build(BuildContext context) {
    List<Characters> characters = [
      Characters(
          image: "assets/images/Main Characters/Mask Dude/Idle (32x32).png",
          name: "Mask Dude"),
      Characters(
          image: "/Main Characters/Ninja Frog/Idle (32x32).png",
          name: "Ninja Frog"),
      Characters(
          image: "/Main Characters/Pink Man/Idle (32x32).png",
          name: "Pink Man"),
      Characters(
          image: "/Main Characters/Virtual Guy/Idle (32x32).png",
          name: "Virtual Guy"),
    ];

    List<Widget> characterSliders = characters
        .map((item) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                  child: Stack(
                    children: <Widget>[
                      const Image(
                          image: AssetImage(
                              "assets/images/Main Characters/example.png"),
                          fit: BoxFit.cover,
                          width: 500.0), //replace with sprite animation
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
                            'Chain Saw',
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
                  widget.send("Chain Saw previous");
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
                onTap: () {},
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
                  widget.send("Chain Saw next");
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

  final List<Color> mixedColors = [
    const Color(0xffea71bd),
    const Color(0xff6cd9f1),
    const Color(0xffcc3048),
    const Color(0xff288610),
    const Color(0xffd8e1e4),
    const Color(0xffd2622e),
    const Color(0xff30acd9),
    const Color(0xffa14744),
  ];
}

class Characters {
  final String image;
  final String name;

  Characters({required this.image, required this.name});
}
