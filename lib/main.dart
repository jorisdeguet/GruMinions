import 'package:flutter/material.dart';
import 'package:flutter_p2p_connection/flutter_p2p_connection.dart';
import 'package:get/get.dart';
import 'package:vieux_pixels/page/home_page.dart';

void main() {
  runApp(const MainApp());
  FlutterP2pConnection().checkStoragePermission();
  FlutterP2pConnection().askStoragePermission();
  FlutterP2pConnection().checkLocationPermission();
  FlutterP2pConnection().askLocationPermission();
  FlutterP2pConnection().checkLocationEnabled();
  FlutterP2pConnection().enableLocationServices();
  FlutterP2pConnection().checkWifiEnabled();
  FlutterP2pConnection().enableWifiServices();
}

class MainApp extends StatefulWidget {
  const MainApp({
    Key? key,
  }) : super(key: key);

  @override
  State<MainApp> createState() => _MainState();
}

class _MainState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'GruMinions',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
