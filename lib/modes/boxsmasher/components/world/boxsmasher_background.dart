import 'package:flame/components.dart';
import 'package:gru_minions/modes/boxsmasher/boxsmasher_game.dart';

class BoxSmasherBackground extends SpriteComponent with HasGameRef<BoxSmasherGame>{
  BoxSmasherBackground();

  @override
  Future<void> onLoad() async {
    final backgroundSprite = await gameRef.images.load('BoxSmasherBackground.png');
    sprite = Sprite(backgroundSprite);
    anchor = Anchor.topLeft;
    center = gameRef.size / 2;
    size = gameRef.size;
    height = gameRef.size.y;
  }
}