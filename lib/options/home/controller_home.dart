import 'dart:ui';

import 'package:flutter/material.dart';


class ControllerHome extends StatefulWidget {
  const ControllerHome({
    super.key,
  });

  @override
  State<ControllerHome> createState() => _ControllerHomeState();
}

class _ControllerHomeState extends State<ControllerHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Image(
            image: const AssetImage('assets/images/Background/Wallpaper1.gif'),
            fit: BoxFit.fill,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          ),
        ],
      ),
    );
  }
}
