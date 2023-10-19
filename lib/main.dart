import 'package:flutter/material.dart';
import 'package:gru_minions/screens/home.dart';

// To disable support for one platfrom
// https://docs.flutter.dev/platform-integration/desktop
// flutter config --no-enable-ios
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}
