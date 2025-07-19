import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';

import '../finger_tracking_game.dart';

class Player extends CircleComponent with HasGameReference<FingerTrackingGame> {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    radius = 20.0;
    paint.color = const Color.fromARGB(255, 45, 204, 45);
    position = Vector2(0, 0);
  }
}
