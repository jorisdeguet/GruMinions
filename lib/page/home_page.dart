import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gru_minions/page/gru/main_gru_page.dart';
import 'package:gru_minions/page/minion/main_minion_page.dart';
import 'package:gru_minions/service/boss_service.dart';
import 'package:gru_minions/service/minion_service.dart';
import 'package:gru_minions/service/utils.dart';


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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            permissionsButton(context),
            gruButton(context),
            minionButton(context),
          ],
        ),
      ),
    );
  }

  Widget minionButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const MainMinionPage()),
        ).then((value) => _resetServices());
      }, //This prop for beautiful expressions
      child: Text(
          "Mode Minion"), // This child can be everything. I want to choose a beautiful Text Widget
      style: ElevatedButton.styleFrom(
        textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        minimumSize: Size(200, 100), //change size of this beautiful button
        // We can change style of this beautiful elevated button thanks to style prop
        primary: Colors.yellow, // we can set primary color
        onPrimary: Colors.black, // change color of child prop
        onSurface: Colors.blue, // surface color
        shadowColor: Colors
            .grey, //shadow prop is a very nice prop for every button or card widgets.
        elevation: 5, // we can set elevation of this beautiful button
        side: BorderSide(
            color: Colors.blueAccent, //change border color
            width: 2, //change border width
            style: BorderStyle
                .solid), // change border side of this beautiful button
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              30), //change border radius of this beautiful button thanks to BorderRadius.circular function
        ),
        tapTargetSize: MaterialTapTargetSize.padded,
      ),
    );

  }



  Widget permissionsButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        askPermissions();
      }, //This prop for beautiful expressions
      child: Text(
          "Ask permissions"), // This child can be everything. I want to choose a beautiful Text Widget
      style: ElevatedButton.styleFrom(
        textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        minimumSize: Size(200, 100), //change size of this beautiful button
        // We can change style of this beautiful elevated button thanks to style prop
        primary: Colors.blueGrey, // we can set primary color
        onPrimary: Colors.black, // change color of child prop
        onSurface: Colors.blue, // surface color
        shadowColor: Colors
            .grey, //shadow prop is a very nice prop for every button or card widgets.
        elevation: 5, // we can set elevation of this beautiful button
        side: BorderSide(
            color: Colors.blueAccent, //change border color
            width: 2, //change border width
            style: BorderStyle
                .solid), // change border side of this beautiful button
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              20), //change border radius of this beautiful button thanks to BorderRadius.circular function
        ),
        tapTargetSize: MaterialTapTargetSize.padded,
      ),
    );

  }

  Widget gruButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const MainGruPage()),
        ).then((value) => _resetServices());
      }, //This prop for beautiful expressions
      child: Text(
          "Mode Gru"), // This child can be everything. I want to choose a beautiful Text Widget
      style: ElevatedButton.styleFrom(
        textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        minimumSize: Size(200, 100), //change size of this beautiful button
        // We can change style of this beautiful elevated button thanks to style prop
        primary: Colors.red, // we can set primary color
        onPrimary: Colors.white, // change color of child prop
        onSurface: Colors.blue, // surface color
        shadowColor: Colors
            .grey, //shadow prop is a very nice prop for every button or card widgets.
        elevation: 5, // we can set elevation of this beautiful button
        side: BorderSide(
            color: Colors.redAccent.shade400, //change border color
            width: 2, //change border width
            style: BorderStyle
                .solid), // change border side of this beautiful button
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              30), //change border radius of this beautiful button thanks to BorderRadius.circular function
        ),
        tapTargetSize: MaterialTapTargetSize.padded,
      ),
    );
  }

  void _resetServices() {
    Get.delete<GruService>();
    Get.delete<MinionService>();
  }
}
