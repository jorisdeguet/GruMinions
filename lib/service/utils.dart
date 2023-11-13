import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter_p2p_connection/flutter_p2p_connection.dart';

bool estMemeAdresse(String a, String b){
  // du au fait que les adresses MAC en Wifi direct ne sont pas exactement celle de Wifi
  String aa = a.substring(2, 17).toUpperCase();
  String bb = b.substring(2, 17).toUpperCase();
  return aa == bb;
}


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