import 'package:flutter/material.dart';


class ScreenSettings extends StatefulWidget {
  const ScreenSettings({
    super.key,
    required this.character,
  });

  final String character;

  @override
  State<ScreenSettings> createState() => _ScreenSettingsState();
}

class _ScreenSettingsState extends State<ScreenSettings> {

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          children: [
            Expanded(
                child: Text('Settings controller')
            ),
          ],
        ),
      ),
    );
  }
}