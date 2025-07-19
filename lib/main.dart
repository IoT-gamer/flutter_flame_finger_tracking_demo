import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'game/game.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  Flame.device.setLandscapeLeftOnly();
  WakelockPlus.enable();
  runApp(GamePage());
}
