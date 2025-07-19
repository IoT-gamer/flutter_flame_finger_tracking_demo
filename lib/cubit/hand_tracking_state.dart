part of 'hand_tracking_cubit.dart';

// An abstract base class for all hand tracking states.
// Using a sealed-like pattern helps in handling all possible states in the UI.
abstract class HandTrackingState extends Equatable {
  const HandTrackingState();

  @override
  List<Object?> get props => [];
}

// The initial state before any tracking has started.
class HandTrackingInitial extends HandTrackingState {}

// The state while the camera and hand landmark model are being initialized.
class HandTrackingLoading extends HandTrackingState {}

// The state when tracking is active and successful.
// It holds the camera controller for the preview and the detected hand landmarks.
class HandTrackingSuccess extends HandTrackingState {
  final CameraController controller;
  final List<Hand> hands;

  const HandTrackingSuccess({required this.controller, this.hands = const []});

  @override
  List<Object?> get props => [controller, hands];

  // Helper to create a new state with updated hands, avoiding boilerplate code.
  HandTrackingSuccess copyWith({List<Hand>? hands}) {
    return HandTrackingSuccess(
      controller: controller,
      hands: hands ?? this.hands,
    );
  }
}

// The state when an error occurs during initialization or tracking.
class HandTrackingFailure extends HandTrackingState {
  final String error;

  const HandTrackingFailure(this.error);

  @override
  List<Object?> get props => [error];
}
