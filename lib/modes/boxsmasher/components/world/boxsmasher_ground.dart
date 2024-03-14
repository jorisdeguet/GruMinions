import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Ground extends PositionComponent{
  Ground({required size, required position})
      : super(size: size, position: position) {
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox());
  }
}