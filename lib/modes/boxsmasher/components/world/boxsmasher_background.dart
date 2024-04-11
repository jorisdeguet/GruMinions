import 'package:flame/components.dart';
import 'package:gru_minions/modes/boxsmasher/boxsmasher_game.dart';

class BoxSmasherBackground extends SpriteComponent {
  final BoxSmasherGame gameRef;
  BoxSmasherBackground(this.gameRef);

  @override
  Future<void> onLoad() async {
    final backgroundSprite = await gameRef.images.load('BoxSmasherBackground.png');
    sprite = Sprite(backgroundSprite);
    anchor = Anchor.topLeft;
    center = gameRef.size / 3;
    size = gameRef.size + Vector2(50, 0);
    height = gameRef.size.y;
  }
}