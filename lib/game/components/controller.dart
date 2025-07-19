import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';

import '../../cubit/hand_tracking_cubit.dart';
import '../../models/hand_landmark.dart';
import '../finger_tracking_game.dart';

class Controller extends Component
    with
        FlameBlocListenable<HandTrackingCubit, HandTrackingState>,
        HasGameReference<FingerTrackingGame> {
  Vector2? _smoothedPosition;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await game.handTrackingCubit.startTracking();
  }

  @override
  void onNewState(HandTrackingState state) {
    if (state is HandTrackingSuccess) {
      if (state.hands.isNotEmpty) {
        game.handTrackingWorld.status.text = '';

        // Use the enum to get the index finger tip landmark
        final indexFinger =
            state.hands.first.landmarks[HandLandmark.INDEX_FINGER_TIP.index];
        final scaledX = game.gameWidth / 2 - indexFinger.x * game.gameWidth;
        final scaledY = indexFinger.y * game.gameHeight - game.gameHeight / 2;
        final targetPosition = Vector2(scaledX, scaledY);

        // Smoothing factor (0.0 = no movement, 1.0 = instant movement)
        const smoothing = 0.3;
        if (_smoothedPosition == null) {
          _smoothedPosition = targetPosition.clone();
        } else {
          _smoothedPosition!.lerp(targetPosition, smoothing);
        }

        print(
          'Smoothed position: (${_smoothedPosition!.x}, ${_smoothedPosition!.y})',
        );
        game.handTrackingWorld.player.position = _smoothedPosition!;
      } else {
        game.handTrackingWorld.status.text = 'no hand detected';
      }
    }
  }
}
