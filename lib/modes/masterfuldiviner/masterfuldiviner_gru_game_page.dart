import 'package:flutter/material.dart';

class GruMasterfulDivinerPage extends StatefulWidget {
  final Function send;

  const GruMasterfulDivinerPage({super.key, required this.send});

  @override
  GruMasterfulDivinerState createState() => GruMasterfulDivinerState();
}

class GruMasterfulDivinerState extends State<GruMasterfulDivinerPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: Color.fromRGBO(0, 0, 0, 1),
        body: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text('Masterful Diviner Game Page', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
          ],
        ));
  }
}
