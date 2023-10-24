// matrix mode meta-mode :
// Gru gets Two TextFields for number of row and cols
// Gru tells each minion to light up successively
// by taping the corresponding on gru we get the (x,y) coords of each minion
// Gru can store this info for 2D position specific modes

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:gru_minions/modes/base-mode.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MatrixMode extends GruMinionMode {
  MatrixMode({required super.sendToOthers});

  @override
  void handleMessageAsGru(String s) {
    // TODO: implement handleMessageAsGru
  }

  @override
  void handleMessageAsMinion(String s) {
    // TODO: implement handleMessageAsMinion
  }

  @override
  Widget minionWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        QrImageView(
          data: macAddress()+"T",
          version: QrVersions.auto,
          size: 400.0,
        ),
        Spacer(),
        Row(
          children: [
            Spacer(),
            QrImageView(
              data: macAddress(),
              version: QrVersions.auto,
              size: 400.0,
            ),
          ],
        ),
      ],
    );
  }

  @override
  String name() => "calibration";

  @override
  void initGru() {}

  @override
  void initMinion() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    // TODO: implement initMinion
  }

  @override
  Widget gruWidget() {
    return MobileScanner(
      // fit: BoxFit.contain,
      onDetect: (capture) {
        final List<Barcode> barcodes = capture.barcodes;
        final Uint8List? image = capture.image;
        sendToOthers(barcodes.length.toString() + "  found ");
        for (final barcode in barcodes) {
          debugPrint('Barcode found! ${barcode.rawValue} ');
        }
      },
    );
  }

}