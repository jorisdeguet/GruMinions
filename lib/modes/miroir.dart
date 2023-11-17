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
    if (s.contains("FILEPATH")) {
      this.imagePath = s.split("@")[1];
    }
  }

  @override
  Widget minionWidget(BuildContext context) {
    return Scaffold(
      body: Stack(
          children: [
            Container(
              width: double.infinity,
              child: GestureDetector(
                onTap: () async {
                  await takePic();
                  Get.find<MinionService>().p2p.sendFiletoSocket([this.imagePath]);
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
          await takePic();
          Get.find<MinionService>().p2p.sendFiletoSocket([this.imagePath]);
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }

  Future<void> takePic() async {
    try {
      final XFile image = await _controller.takePicture();
      print("Image " + image.path);
      this.imagePath = image.path;
    } catch (e) {
      // If an error occurs, log the error to the console.
      print(e);
    }
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
      ResolutionPreset.medium,
    );
    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  Widget gruWidget() {
    return new Text("Miroir console TODO");
  }

}
