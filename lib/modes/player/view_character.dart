import 'package:flutter/material.dart';


class ViewCharacter extends StatefulWidget {
  const ViewCharacter({super.key});

  @override
  State<ViewCharacter> createState() => _ViewCharacterState();
}

class _ViewCharacterState extends State<ViewCharacter> {

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('View Character')
          ],
        ),
      ),
    );
  }
}