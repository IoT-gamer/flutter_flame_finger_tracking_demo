import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'dart:async';
import 'package:camera/camera.dart';
import 'package:hand_landmarker/hand_landmarker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/hand_tracking_service.dart';

part 'hand_tracking_state.dart';

// Manages the state of the HandTracking feature.
class HandTrackingCubit extends Cubit<HandTrackingState> {
  final HandTrackingService _handTrackingService = HandTrackingService();

  HandTrackingCubit() : super(HandTrackingInitial());

  // Starts the hand tracking process.
  Future<void> startTracking() async {
    try {
      // Emit loading state to show a progress indicator in the UI.
      emit(HandTrackingLoading());

      // Initialize the service.
      await _handTrackingService.initialize();
      final controller = _handTrackingService.cameraController;

      if (controller == null) {
        emit(const HandTrackingFailure("Camera controller is not available."));
        return;
      }

      // Emit success state with the controller to build the CameraPreview.
      emit(HandTrackingSuccess(controller: controller));

      // Start listening to the image stream for hand detections.
      _handTrackingService.startImageStream((hands) {
        // When new hands are detected, emit a new success state with the landmark data.
        if (state is HandTrackingSuccess) {
          final currentState = state as HandTrackingSuccess;
          emit(currentState.copyWith(hands: hands));
        }
      });
    } catch (e) {
      // If any error occurs, emit a failure state.
      emit(HandTrackingFailure(e.toString()));
    }
  }

  // Stops the hand tracking process.
  void stopTracking() {
    _handTrackingService.stopImageStream();
  }

  // Overriding the close method to ensure resources are released.
  @override
  Future<void> close() {
    _handTrackingService.dispose();
    return super.close();
  }
}
