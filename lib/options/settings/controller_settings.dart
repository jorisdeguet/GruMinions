import 'package:flutter/material.dart';


class ControllerSettings extends StatefulWidget {
  const ControllerSettings({
    super.key,
    required this.character,
  });

  final String character;

  @override
  State<ControllerSettings> createState() => _ControllerSettingsState();
}

class _ControllerSettingsState extends State<ControllerSettings> {

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
