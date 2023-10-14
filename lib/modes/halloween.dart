

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gru_minions/utils.dart';



List<String> images = [
  "assets/halloween/crane.png",
  "assets/halloween/halloween.jpg",
  "assets/halloween/pumpkin.jpg"
];


String getImageRandom() {
  Random r = Random();
  return images[r.nextInt(images.length)];
}

void playMouaha() {
  playSound("assets/halloween/mouahaha.m4a");
}

