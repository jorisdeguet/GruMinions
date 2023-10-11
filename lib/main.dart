import 'package:flutter/material.dart';
import 'package:flutter_p2p_connection/flutter_p2p_connection.dart';
import 'package:vieux_pixels/home.dart';

void main() {
  FlutterP2pConnection().checkStoragePermission();
  FlutterP2pConnection().askStoragePermission();
  FlutterP2pConnection().checkLocationPermission();
  FlutterP2pConnection().askLocationPermission();
  FlutterP2pConnection().checkLocationEnabled();
  FlutterP2pConnection().enableLocationServices();
  FlutterP2pConnection().checkWifiEnabled();
  FlutterP2pConnection().enableWifiServices();
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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
