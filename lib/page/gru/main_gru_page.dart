import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gru_minions/page/gru/apps/gru_app_page.dart';
import 'package:gru_minions/service/boss_service.dart';
import 'package:gru_minions/widget/boss_base_widget.dart';



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
    return GruTestAppPage();
  }

  Widget _games() {
    return GruTestAppPage();
  }


}
