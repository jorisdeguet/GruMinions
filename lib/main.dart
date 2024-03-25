import 'package:flutter/material.dart';
import 'package:gru_minions/page/splash_screen_game.dart';

// TODO make issue / fork / pull request on bug on Map<String, dynamic>? json = jsonDecode(obj); line 123 in
// flutter_p2p_connection.dart ::: some peripherals for me a roku TCL TV ends up with bad JSON
// line 408 in FlutterP2pConnectionPlugin.kt builds JSON "a la main" so does not handle double quotes correctly

// TODO see how can we make a udp broadcast
// https://medium.com/flutter-community/working-with-sockets-in-dart-15b443007bc9
// https://pub.dev/packages/connectme
// https://pub.dev/packages/flutter_socket_plugin

// TODO see if we can have a UDP broadcast
// https://stackoverflow.com/questions/15524593/broadcasting-over-wi-fi-direct

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arcade',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreenGame(),
    );
  }
}
