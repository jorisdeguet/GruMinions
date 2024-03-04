import 'package:flame/components.dart';

class CollisionBlock extends PositionComponent {
  CollisionBlock({position, size, this.isPlatform = false}) : super(position: position, size: size);//{ debugMode = true;} //set to see the collision block
  bool isPlatform = false;
}