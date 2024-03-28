import 'dart:ui';

class Character {
  final String image;
  final String name;
  final Color color;

  Character({required this.image, required this.name, required this.color});
}

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