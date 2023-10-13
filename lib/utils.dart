import 'package:assets_audio_player/assets_audio_player.dart';

void playSound(nomFichier){
  AssetsAudioPlayer.newPlayer().open(
    Audio(nomFichier),
    autoStart: true,
    showNotification: false,
  );
}