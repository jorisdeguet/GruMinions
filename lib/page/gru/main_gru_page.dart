import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gru_minions/page/gru/apps/gru_app_page.dart';
import 'package:gru_minions/service/boss_service.dart';

import '../../widget/boss_base_widget.dart';

class MainGruPage extends StatefulWidget {
  const MainGruPage({super.key});

  @override
  State<MainGruPage> createState() => _MainBossPageState();
}

class _MainBossPageState extends BossBaseWidgetState<MainGruPage> {

  @override
  void initState() {
    Get.put(GruService());
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
          MaterialPageRoute(builder: (context) => const GruTestAppPage()),
        );
      },
      child: const Text("Test game"),
    );
  }


}
