import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vieux_pixels/page/boss/apps/boss_test_app_page.dart';
import 'package:vieux_pixels/service/boss_service.dart';

import '../../widget/boss_base_widget.dart';

class MainBossPage extends StatefulWidget {
  const MainBossPage({super.key});

  @override
  State<MainBossPage> createState() => _MainBossPageState();
}

class _MainBossPageState extends BossBaseWidgetState<MainBossPage> {

  @override
  void initState() {
    Get.put(BossService());
    super.initState();
  }

  @override
  Widget content(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _games(),
          ],
        ),
      ),
    );
  }

  Widget _games() {
    return MaterialButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const BossTestAppPage()),
        );
      },
      child: const Text("Test game"),
    );
  }


}
