// lib/services/hand_tracking_service.dart

import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hand_landmarker/hand_landmarker.dart';
import 'package:integral_isolates/integral_isolates.dart';

class HandTrackingService {
  CameraController? _controller;
  static HandLandmarkerPlugin? _plugin;
  List<CameraDescription>? _cameras;

  StatefulIsolate? _isolate;
  RootIsolateToken? _rootIsolateToken;

  CameraController? get cameraController => _controller;

  static Future<List<Hand>> _detectLandmarks(Map<String, dynamic> data) async {
    final token = data['token'] as RootIsolateToken;
    BackgroundIsolateBinaryMessenger.ensureInitialized(token);

    _plugin ??= HandLandmarkerPlugin.create(
      numHands: 1,
      minHandDetectionConfidence: 0.5,
      delegate: HandLandmarkerDelegate.CPU,
    );

    final image = data['image'] as CameraImage;
    final orientation = data['orientation'] as int;

    try {
      final hands = _plugin!.detect(image, orientation);
      return hands;
    } catch (e) {
      debugPrint('Error detecting landmarks in isolate: $e');
      return [];
    }
  }

  Future<void> initialize() async {
    _cameras = await availableCameras();
    final camera = _cameras!.firstWhere(
      (cam) => cam.lensDirection == CameraLensDirection.front,
      orElse: () => _cameras!.first,
    );
    _controller = CameraController(
      camera,
      ResolutionPreset.medium,
      enableAudio: false,
    );
    await _controller!.initialize();

    _rootIsolateToken = RootIsolateToken.instance;
    if (_rootIsolateToken != null) {
      _isolate = StatefulIsolate(
        backpressureStrategy: ReplaceBackpressureStrategy(),
      );
    }
  }

  /// Starts the camera stream and passes frames to the isolate for processing.
  void startImageStream(void Function(List<Hand> hands) onHandsDetected) {
    if (_controller == null || _isolate == null || _rootIsolateToken == null) {
      return;
    }

    _controller!.startImageStream((image) {
      // Offload the detection task to the isolate.
      _isolate!
          .compute(_detectLandmarks, {
            'image': image,
            'orientation': _controller!.description.sensorOrientation,
            'token': _rootIsolateToken!,
          })
          .then((hands) {
            // Send the results back to the main thread.
            onHandsDetected(hands);
          })
          .catchError((error) {
            // Backpressure exceptions are expected when frames are dropped.
            // We can safely ignore them to prevent the app from crashing.
            if (error is! BackpressureDropException) {
              // Log any other unexpected errors.
              debugPrint('HandTrackingService Error: $error');
            }
          });
    });
  }

  void stopImageStream() {
    if (_controller?.value.isStreamingImages ?? false) {
      _controller?.stopImageStream();
    }
  }

  void dispose() {
    stopImageStream();
    _controller?.dispose();
    _isolate?.dispose();
    _plugin?.dispose();
    _plugin = null;
  }
}
