import 'package:flame/components.dart';

class Input extends Component with HasGameReference {
  final maxHAxis = 1.5;
  final sensitivity = 3;
  //this is what the external class acsess to get current state of horizontal input
  var hAxis = 0.0;
  var joystickHaxis = 0.0;
  bool active = false;

  @override
  void update(double dt) {
    hAxis = (joystickHaxis).clamp(-maxHAxis, maxHAxis);
  }
}
