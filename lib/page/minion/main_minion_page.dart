import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vieux_pixels/service/minion_service.dart';

import '../../widget/minion_base_widget.dart';

class MainMinionPage extends StatefulWidget {
  const MainMinionPage({super.key});

  @override
  State<MainMinionPage> createState() => _MainMinionPageState();
}

class _MainMinionPageState extends MinionBaseWidgetState<MainMinionPage> {
  @override
  void initState() {
    Get.put(MinionService());
    super.initState();
  }

  @override
  Widget content(BuildContext context) {
    return Text('Connecté à Boss. En attente d''instructions...');
  }
}
