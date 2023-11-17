import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gru_minions/modes/base-mode.dart';
import 'package:gru_minions/service/minion_service.dart';

class Miroir extends GruMinionMode {

  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  
  CameraDescription? camera;

  String imagePath = "";

  Miroir({required super.sendToOthers}){
    // Next, initialize the controller. This returns a Future.
    //_initializeControllerFuture = _controller.initialize();
  }


  @override
  void handleMessageAsGru(String s) {
    print("Gru in miror mode " + s);
  }

  @override
  void handleMessageAsMinion(String s) {
    print("Minion in miror mode " + s);
  }

  @override
  Widget minionWidget(BuildContext context) {
    // TODO: implement minionWidget
    return Scaffold(
      body: Stack(
          children: [
            Container(
              width: double.infinity,
              child: GestureDetector(
                onTap: () {
                  sendToOthers("Hi ");
                },
                onDoubleTap: () {
                  //takePicture(_controller);
                },
                onLongPress: () {

                },
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // Spacer(),
                    Expanded(
                      child: frontCameraPreview(),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: 200,
              height: 200,
              color: Colors.blue,
              child: imagePath == "" ? Container() : Image.file(File(this.imagePath)),
            ),
          ]
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            final XFile image = await _controller.takePicture();
            print("Image " + image.path);
            this.imagePath = image.path;
            Get.find<MinionService>().p2p.sendFiletoSocket([this.imagePath]);
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }

  @override
  String name() => "miroir";

  FutureBuilder<void> frontCameraPreview() {
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // If the Future is complete, display the preview.
          return CameraPreview(_controller);
        } else {
          // Otherwise, display a loading indicator.
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  void initGru() {
    // TODO: implement init
  }

  @override
  void initMinion() {
    _initCamera();
    // TODO: implement initMinion
  }

  void _initCamera() async {
    final cameras = await availableCameras();
    camera = cameras.last;
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      camera!,
      // Define the resolution to use.
      ResolutionPreset.high,
    );
    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  Widget gruWidget() {
    return new Text("Miroir console TODO");
  }


// // TODO test and see if we can share with other minions
// Future<XFile?> takePicture(CameraController? cameraController) async {
//   if (cameraController!.value.isTakingPicture) {
//     // A capture is already pending, do nothing.
//     return null;
//   }
//   try {
//     XFile file = await cameraController.takePicture();
//     print("Picture on " + _macAddress);
//     return file;
//   } on CameraException catch (e) {
//     print('Error occured while taking picture: $e');
//     return null;
//   }
// }
}
