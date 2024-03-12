import 'package:flame/components.dart';

class CollisionBlock extends PositionComponent {
  CollisionBlock({super.position, super.size, this.isPlatform = false, this.isFallingPlatform = false});
  bool isPlatform;
  bool isFallingPlatform;
}