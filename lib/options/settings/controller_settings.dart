import 'package:flutter/material.dart';

class ControllerSettings extends StatefulWidget {
  const ControllerSettings({super.key, required this.macAddress});

  final String macAddress;

  @override
  State<ControllerSettings> createState() => _ControllerSettingsState();
}

class _ControllerSettingsState extends State<ControllerSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Settings controller : ${widget.macAddress}'),
          ],
        ),
      ),
    );
  }
}
