import 'package:flutter/material.dart';
import 'package:vieux_pixels/widget/boss_base_widget.dart';

class BossTestAppPage extends StatefulWidget {
  const BossTestAppPage({super.key});

  @override
  State<BossTestAppPage> createState() => _BossTestAppPageState();
}

class _BossTestAppPageState extends BossBaseWidgetState<BossTestAppPage> {


  @override
  Widget content(BuildContext context) {
    return Text('Test App Page');
  }
}
