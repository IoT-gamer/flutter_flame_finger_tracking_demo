import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flame/text.dart';

import '../finger_tracking_game.dart';

class Status extends TextComponent with HasGameReference<FingerTrackingGame> {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    text = 'no hand detected';
    position = Vector2(-game.gameHeight + width, -game.gameHeight / 2 + height);
    textRenderer = TextPaint(
      style: const TextStyle(
        fontSize: 24.0,
        color: Color.fromARGB(255, 255, 255, 255),
      ),
    );
  }
}
