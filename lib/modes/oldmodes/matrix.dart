// matrix mode meta-mode :
// Gru gets Two TextFields for number of row and cols
// Gru tells each minion to light up successively
// by taping the corresponding on gru we get the (x,y) coords of each minion
// Gru can store this info for 2D position specific modes
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gru_minions/modes/base-mode.dart';
import 'package:gru_minions/service/gru_service.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MatrixMode extends GruMinionMode {
  int numberOfMinions = 4; // TODO have a selector in widget

  MatrixMode({required super.sendToOthers});

  @override
  void handleMessageAsGru(String s) {
    // TODO: implement handleMessageAsGru
  }

  @override
  void handleMessageAsMinion(String s) {
    // TODO: implement handleMessageAsMinion
  }

  void handleMessageAsScreen(String s){}

  @override
  Widget screenWidget(BuildContext context) {
    return _minionWidget();
  }

  @override
  Widget minionWidget(BuildContext context) {
    return _minionWidget();
  }

  Container _minionWidget() {
    return Container(
      color: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          QrImageView(
            data: macAddress(),
            version: QrVersions.auto,
            backgroundColor: Colors.blueGrey,
            //size: 400.0,
          ),
        ],
      ),
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
    return Row(
      children: [
        Expanded(
          child: MobileScanner(
            fit: BoxFit.contain,
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              final Uint8List? image = capture.image;
              GruService service = Get.find<GruService>();
              // TODO if same number of codes as minions, we have everyone
              if (barcodes.length == service.info!.clients.length) {
                sendToOthers("${barcodes.length}  found ");
                for (final barcode in barcodes) {
                  print(
                      '============================ Barcode found! ${barcode.rawValue} ${barcode.corners}');
                  for (Offset off in barcode.corners) {
                    print("${barcode.rawValue!} @ ${off.dx}:${off.dy}     ");
                  }
                }
              }

              //processWithML(image);
            },
          ),
        ),
      ],
    );
  }

// void processWithML(ml.InputImage image) async {
//   // From ML kit
//   final List<ml.BarcodeFormat> formats = [ml.BarcodeFormat.all];
//   final barcodeScanner = ml.BarcodeScanner(formats: formats);
//   final List<ml.Barcode> barcodes = await barcodeScanner.processImage(image);
//
//   for (ml.Barcode barcode in barcodes) {
//     final ml.BarcodeType type = barcode.type;
//     final Rect boundingBox = barcode.boundingBox;
//     final String? displayValue = barcode.displayValue;
//     final String? rawValue = barcode.rawValue;
//
//     // See API reference for complete list of supported types
//     print(rawValue);
//   }
// }
}
