import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter_p2p_connection/flutter_p2p_connection.dart';

void playSound(nomFichier){
  AssetsAudioPlayer.newPlayer().open(
    Audio(nomFichier),
    autoStart: true,
    showNotification: false,
  );
}

void askPermissions(){
  FlutterP2pConnection().checkStoragePermission();
  FlutterP2pConnection().askStoragePermission();
  FlutterP2pConnection().checkLocationPermission();
  FlutterP2pConnection().askLocationPermission();
  FlutterP2pConnection().checkLocationEnabled();
  FlutterP2pConnection().enableLocationServices();
  FlutterP2pConnection().checkWifiEnabled();
  FlutterP2pConnection().enableWifiServices();
}