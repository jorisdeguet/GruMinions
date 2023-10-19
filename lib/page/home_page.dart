import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vieux_pixels/page/minion/main_minion_page.dart';
import 'package:vieux_pixels/service/boss_service.dart';
import 'package:vieux_pixels/service/minion_service.dart';

import 'boss/main_boss_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    _resetServices();
    super.initState();
  }

  @override
  void didUpdateWidget(HomePage oldWidget) {
    _resetServices();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MaterialButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MainBossPage()),
                ).then((value) => _resetServices());
              },
              child: const Text("Boss mode"),
            ),
            MaterialButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MainMinionPage()),
                ).then((value) => _resetServices());
              },
              child: const Text("Minion mode"),
            ),
          ],
        ),
      ),
    );
  }

  void _resetServices() {
    Get.delete<BossService>();
    Get.delete<MinionService>();
  }
}
