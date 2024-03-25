
import 'package:flutter/material.dart';


class ViewLevel extends StatefulWidget {
  const ViewLevel({
    super.key,
    required this.character,
  });

  final String character;

  @override
  State<ViewLevel>  createState() => _ViewLevelState();
}

class _ViewLevelState extends State<ViewLevel> {

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('View Character')
          ],
        ),
      ),
    );
  }
}
