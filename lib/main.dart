import 'package:flutter/material.dart';
import 'package:gru_minions/page/home_page.dart';

// TODO make issue / fork / pull request on bug on Map<String, dynamic>? json = jsonDecode(obj); line 123 in
// flutter_p2p_connection.dart ::: some peripherals for me a roku TCL TV ends up with bad JSON
// line 408 in FlutterP2pConnectionPlugin.kt builds JSON "a la main" so does not handle double quotes correctly
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
