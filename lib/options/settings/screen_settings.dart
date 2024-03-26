import 'package:flutter/material.dart';

class ScreenSettings extends StatefulWidget {
  const ScreenSettings({
    super.key,
    required this.macAddress,
  });

  final String macAddress;

  @override
  State<ScreenSettings> createState() => _ScreenSettingsState();
}

class _ScreenSettingsState extends State<ScreenSettings> {
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
