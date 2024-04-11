import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gru_minions/service/controller_service.dart';
import 'package:gru_minions/service/controller_status.dart';
import 'package:mac_address/mac_address.dart';

import 'custom_circle.dart';

abstract class ControllerBaseWidgetState<T extends StatefulWidget>
    extends State<T> with SingleTickerProviderStateMixin {

  //late variables
  late ControllerService controllerService;
  late AnimationController _animationController;
  late Animation _animation;

  //final variables
  final double size = 200.0;

  Widget content(BuildContext context);

  String _macAddress = "no mac";

  void _initMac() async {
    _macAddress = await GetMac.macAddress;
    setState(() {});
  }

  String macAddress() => _macAddress;

  @override
  void initState() {
    super.initState();
    _initMac();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    controllerService = Get.find();

    _animationController = AnimationController(
        duration: const Duration(milliseconds: 6000), vsync: this);
    _animationController.repeat(reverse: true);
    _animation = Tween(begin: 0.0, end: 6.28).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        switch (controllerService.minionStatus.value) {
          case ControllerStatus.initializing:
            return _loading(subText: 'Initialization...');
          case ControllerStatus.searchingBoss:
            return _loading(subText: 'Searching for screen...');
          case ControllerStatus.connectingBoss:
            return _loading(subText: 'Connecting to the screen...');
          case ControllerStatus.connectingSocket:
            return _loading(subText: 'Connecting to screen\'s socket...');
          case ControllerStatus.active:
            return content(context);
          default:
            return _loading();
        }
      }),
    );
  }

  Widget _loading({String? subText}) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 20.0, bottom: 20.0),
            child: Container(
              width: MediaQuery.of(context).size.width / 2.2,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: Colors.black,
                  width: 2,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      CustomPaint(
                        size: Size(size, size),
                        painter: CustomCircle(const Color(0xffea71bd),
                            1.1 + _animation.value, size, size),
                      ),
                      CustomPaint(
                        size: Size(size, size),
                        painter: CustomCircle(const Color(0xff6cd9f1),
                            1.5 * _animation.value, size, size),
                      ),
                      CustomPaint(
                        size: Size(size, size),
                        painter: CustomCircle(const Color(0xffcc3048),
                            2.0 * _animation.value, size, size),
                      ),
                      CustomPaint(
                        size: Size(size, size),
                        painter: CustomCircle(const Color(0xff288610),
                            2.5 * _animation.value, size, size),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      subText ?? 'Loading...',
                      style: GoogleFonts.pixelifySans(
                        textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 2.2,
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Networks detected',
                        style: GoogleFonts.pixelifySans(
                          textStyle: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        )),
                  ),
                  controllerService.grus.length < 2
                      ? const SizedBox()
                      : Expanded(
                          child: ListView(
                            children: controllerService.grus.map((gru) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    right: 16.0, left: 16.0, top: 8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 2,
                                    ),
                                  ),
                                  child: ListTile(
                                    title: Text(gru.deviceName,
                                        style: GoogleFonts.pixelifySans(
                                          textStyle: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        )),
                                    subtitle: Text(gru.deviceAddress,
                                        style: GoogleFonts.pixelifySans(
                                          textStyle: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        )),
                                    trailing: ElevatedButton.icon(
                                        onPressed: () {
                                          controllerService
                                              .initiateConnectionToGru(gru);
                                        },
                                        icon: const Icon(Icons.wifi_find, color: Colors.black,),
                                        label: Text('Connect',
                                            style: GoogleFonts.pixelifySans(
                                              textStyle: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            )),
                                        style: ButtonStyle(
                                          backgroundColor:
                                                MaterialStateProperty.all<Color>(
                                                    Colors.white),
                                            shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(4)),
                                                    side: BorderSide(
                                                        color: Colors.black))))),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
