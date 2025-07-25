/// Represents the keypoints of the MediaPipe Hand Landmarker model.
///
/// Each enum value corresponds to a specific landmark on the hand and holds its
/// integer index according to the model's output.
///
/// Reference: https://ai.google.dev/edge/mediapipe/solutions/vision/hand_landmarker#models
enum HandLandmark {
  WRIST(0),
  THUMB_CMC(1),
  THUMB_MCP(2),
  THUMB_IP(3),
  THUMB_TIP(4),
  INDEX_FINGER_MCP(5),
  INDEX_FINGER_PIP(6),
  INDEX_FINGER_DIP(7),
  INDEX_FINGER_TIP(8),
  MIDDLE_FINGER_MCP(9),
  MIDDLE_FINGER_PIP(10),
  MIDDLE_FINGER_DIP(11),
  MIDDLE_FINGER_TIP(12),
  RING_FINGER_MCP(13),
  RING_FINGER_PIP(14),
  RING_FINGER_DIP(15),
  RING_FINGER_TIP(16),
  PINKY_MCP(17),
  PINKY_PIP(18),
  PINKY_DIP(19),
  PINKY_TIP(20);

  /// The integer value of the landmark.
  final int value;

  const HandLandmark(this.value);
}
