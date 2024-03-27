import 'package:flame/components.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scaled_list/scaled_list.dart';
import 'package:stroke_text/stroke_text.dart';

class ControllerCharacter extends StatefulWidget {
  const ControllerCharacter({super.key});

  @override
  State<ControllerCharacter> createState() => _ControllerCharacterState();
}

class _ControllerCharacterState extends State<ControllerCharacter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StrokeText(
              text: 'Characters',
              strokeColor: Colors.black,
              strokeWidth: 4,
              textStyle: GoogleFonts.pixelifySans(
                textStyle: const TextStyle(
                  fontSize: 70,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            ScaledList(
              itemCount: characters.length,
              itemColor: (index) {
                return mixedColors[index % mixedColors.length];
              },
              cardWidthRatio: 0.7,
              marginWidthRatio: 0.1,
              selectedCardHeightRatio: 0.5,
              unSelectedCardHeightRatio: 0.4,
              itemBuilder: (index, selectedIndex) {
                final character = characters[index];
                return InkWell(
                  onTap: () {
                    //set character
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: SpriteAnimationWidget.asset(
                          path: character.image,
                          data: SpriteAnimationData.sequenced(
                            amount: 11,
                            stepTime: 0.05,
                            textureSize: Vector2(32, 32),
                            loop: true,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        character.name,
                        style: GoogleFonts.pixelifySans(
                          color: Colors.black,
                          fontSize: 40,
                          fontWeight: FontWeight.w200,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      const SizedBox(height: 10)
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
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

  final List<Characters> characters = [
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
}

class Characters {
  final String image;
  final String name;

  Characters({required this.image, required this.name});
}
