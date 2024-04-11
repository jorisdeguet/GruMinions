import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gru_minions/service/screen_status.dart';

import '../service/screen_service.dart';
import 'custom_circle.dart';

abstract class ScreenBaseWidgetState<T extends StatefulWidget> extends State<T>
    with TickerProviderStateMixin {
  late ScreenService viewService;
  late AnimationController _animationController;
  late Animation _animation;
  final double size = 200.0;

  Widget content(BuildContext context);

  @override
  void initState() {
    super.initState();
    viewService = Get.find();
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 6000), vsync: this);
    _animationController.repeat(reverse: true);
    _animation = Tween(begin: 0.0, end: 6.28).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    debugPrint('ScreenBaseWidgetState: dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        switch (viewService.bossStatus.value) {
          case ViewStatus.initializing:
            return _loading(subText: 'Initialization...');
          case ViewStatus.creatingGroup:
            return _loading(subText: 'Creating group...');
          case ViewStatus.openingSocket:
            return _loading(subText: 'Opening socket...');
          case ViewStatus.active:
            return content(context);
          default:
            return _loading();
        }
      }),
    );
  }

  Widget _loading({String? subText}) {
    return Center(
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
          )
        ],
      ),
    );
  }
}
