import 'dart:ui';

class Character {
  final String name;
  final Color color;

  Character({required this.name, required this.color});
}

List<Character> characters = [
  Character(
      name: "Mask Dude",
      color: const Color(0xffea71bd)),
  Character(
      name: "Ninja Frog",
      color: const Color(0xff6cd9f1)),
  Character(
      name: "Pink Man",
      color: const Color(0xffcc3048)),
  Character(
      name: "Virtual Guy",
      color: const Color(0xff288610)),
];