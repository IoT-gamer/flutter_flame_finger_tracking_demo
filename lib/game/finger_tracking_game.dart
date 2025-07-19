import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_bloc/flame_bloc.dart';

import '../cubit/hand_tracking_cubit.dart';
import 'components/player.dart';
import 'components/controller.dart';
import 'components/status.dart';

class FingerTrackingGame extends FlameGame
    with HasGameReference<FingerTrackingGame> {
  final HandTrackingCubit handTrackingCubit;
  late final FingerTrackingWorld handTrackingWorld;
  late final double gameWidth;
  late final double gameHeight;

  FingerTrackingGame({required this.handTrackingCubit});

  @override
  Future<void> onLoad() async {
    // select width to the largest dimension of the screen
    final size = game.size;

    if (size.x > size.y) {
      gameWidth = size.x;
      gameHeight = size.y;
    } else {
      gameWidth = size.y;
      gameHeight = size.x;
    }

    camera = CameraComponent.withFixedResolution(
      width: gameWidth,
      height: gameHeight,
    );

    handTrackingWorld = FingerTrackingWorld();
    world = handTrackingWorld;
  }
}

class FingerTrackingWorld extends World
    with HasGameReference<FingerTrackingGame> {
  final Player player = Player();
  final Status status = Status();

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await add(player);
    await add(status);
    await add(
      FlameBlocProvider<HandTrackingCubit, HandTrackingState>.value(
        value: game.handTrackingCubit,
        children: [Controller()],
      ),
    );
  }
}
