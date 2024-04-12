import 'package:flutter/material.dart';

class MainMenu extends StatelessWidget {
  //Exposing the onpress for the buttons as voidCallback allows us
  //To setup the handlers of the buttons in our game class which make
  //This make the widget code free from any flame related code
  const MainMenu({super.key, this.onPlayPressed, this.onSettingsPressed});

  //To avoid hardcoding the stringId we are storing them as static const id inside the route itself
  static const id = 'MainMenu';

  final VoidCallback? onPlayPressed;
  final VoidCallback? onSettingsPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text(
            'Ski Master',
            style: TextStyle(fontSize: 30),
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: 150,
            child: OutlinedButton(
              onPressed: onPlayPressed,
              child: const Text('Play'),
            ),
          ),
          const SizedBox(height: 5),
          SizedBox(
            width: 150,
            child: OutlinedButton(
              onPressed: onSettingsPressed,
              child: const Text('Settings'),
            ),
          ),
        ]),
      ),
    );
  }
}
