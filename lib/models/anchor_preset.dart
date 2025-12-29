/// Represents an anchor preset similar to Unity's RectTransform anchor system.
///
/// Each preset defines where the element's anchors should be positioned
/// relative to its parent container using normalized coordinates (0-1 range).
class AnchorPreset {
  final String name;
  final String description;
  final double minX;
  final double minY;
  final double maxX;
  final double maxY;
  final AnchorPresetCategory category;

  const AnchorPreset({
    required this.name,
    required this.description,
    required this.minX,
    required this.minY,
    required this.maxX,
    required this.maxY,
    required this.category,
  });

  /// Checks if the given anchor values match this preset
  bool matches(double anchorMinX, double anchorMinY, double anchorMaxX, double anchorMaxY) {
    const tolerance = 0.001;
    return (anchorMinX - minX).abs() < tolerance &&
           (anchorMinY - minY).abs() < tolerance &&
           (anchorMaxX - maxX).abs() < tolerance &&
           (anchorMaxY - maxY).abs() < tolerance;
  }
}

enum AnchorPresetCategory {
  point,    // Single point anchors (9 positions)
  stretch,  // Stretch anchors (horizontal, vertical, both)
}

/// Common anchor presets matching Unity's RectTransform system
class AnchorPresets {
  // ===== POINT ANCHORS (9 positions) =====

  // Top Row
  static const topLeft = AnchorPreset(
    name: 'Top Left',
    description: 'Anchor to top-left corner',
    minX: 0.0, minY: 1.0,
    maxX: 0.0, maxY: 1.0,
    category: AnchorPresetCategory.point,
  );

  static const topCenter = AnchorPreset(
    name: 'Top Center',
    description: 'Anchor to top-center',
    minX: 0.5, minY: 1.0,
    maxX: 0.5, maxY: 1.0,
    category: AnchorPresetCategory.point,
  );

  static const topRight = AnchorPreset(
    name: 'Top Right',
    description: 'Anchor to top-right corner',
    minX: 1.0, minY: 1.0,
    maxX: 1.0, maxY: 1.0,
    category: AnchorPresetCategory.point,
  );

  // Middle Row
  static const middleLeft = AnchorPreset(
    name: 'Middle Left',
    description: 'Anchor to middle-left',
    minX: 0.0, minY: 0.5,
    maxX: 0.0, maxY: 0.5,
    category: AnchorPresetCategory.point,
  );

  static const middleCenter = AnchorPreset(
    name: 'Middle Center',
    description: 'Anchor to center',
    minX: 0.5, minY: 0.5,
    maxX: 0.5, maxY: 0.5,
    category: AnchorPresetCategory.point,
  );

  static const middleRight = AnchorPreset(
    name: 'Middle Right',
    description: 'Anchor to middle-right',
    minX: 1.0, minY: 0.5,
    maxX: 1.0, maxY: 0.5,
    category: AnchorPresetCategory.point,
  );

  // Bottom Row
  static const bottomLeft = AnchorPreset(
    name: 'Bottom Left',
    description: 'Anchor to bottom-left corner',
    minX: 0.0, minY: 0.0,
    maxX: 0.0, maxY: 0.0,
    category: AnchorPresetCategory.point,
  );

  static const bottomCenter = AnchorPreset(
    name: 'Bottom Center',
    description: 'Anchor to bottom-center',
    minX: 0.5, minY: 0.0,
    maxX: 0.5, maxY: 0.0,
    category: AnchorPresetCategory.point,
  );

  static const bottomRight = AnchorPreset(
    name: 'Bottom Right',
    description: 'Anchor to bottom-right corner',
    minX: 1.0, minY: 0.0,
    maxX: 1.0, maxY: 0.0,
    category: AnchorPresetCategory.point,
  );

  // ===== STRETCH ANCHORS =====

  static const stretchTop = AnchorPreset(
    name: 'Stretch Top',
    description: 'Stretch horizontally, anchor to top',
    minX: 0.0, minY: 1.0,
    maxX: 1.0, maxY: 1.0,
    category: AnchorPresetCategory.stretch,
  );

  static const stretchMiddle = AnchorPreset(
    name: 'Stretch Middle',
    description: 'Stretch horizontally, anchor to middle',
    minX: 0.0, minY: 0.5,
    maxX: 1.0, maxY: 0.5,
    category: AnchorPresetCategory.stretch,
  );

  static const stretchBottom = AnchorPreset(
    name: 'Stretch Bottom',
    description: 'Stretch horizontally, anchor to bottom',
    minX: 0.0, minY: 0.0,
    maxX: 1.0, maxY: 0.0,
    category: AnchorPresetCategory.stretch,
  );

  static const stretchLeft = AnchorPreset(
    name: 'Stretch Left',
    description: 'Stretch vertically, anchor to left',
    minX: 0.0, minY: 0.0,
    maxX: 0.0, maxY: 1.0,
    category: AnchorPresetCategory.stretch,
  );

  static const stretchCenter = AnchorPreset(
    name: 'Stretch Center',
    description: 'Stretch vertically, anchor to center',
    minX: 0.5, minY: 0.0,
    maxX: 0.5, maxY: 1.0,
    category: AnchorPresetCategory.stretch,
  );

  static const stretchRight = AnchorPreset(
    name: 'Stretch Right',
    description: 'Stretch vertically, anchor to right',
    minX: 1.0, minY: 0.0,
    maxX: 1.0, maxY: 1.0,
    category: AnchorPresetCategory.stretch,
  );

  static const stretchFull = AnchorPreset(
    name: 'Stretch Full',
    description: 'Stretch to fill entire parent',
    minX: 0.0, minY: 0.0,
    maxX: 1.0, maxY: 1.0,
    category: AnchorPresetCategory.stretch,
  );

  /// All available presets organized by category
  static const Map<AnchorPresetCategory, List<AnchorPreset>> allPresets = {
    AnchorPresetCategory.point: [
      topLeft, topCenter, topRight,
      middleLeft, middleCenter, middleRight,
      bottomLeft, bottomCenter, bottomRight,
    ],
    AnchorPresetCategory.stretch: [
      stretchTop, stretchMiddle, stretchBottom,
      stretchLeft, stretchCenter, stretchRight,
      stretchFull,
    ],
  };

  /// Get the current preset that matches the given anchor values, or null if custom
  static AnchorPreset? getCurrentPreset(
    double anchorMinX,
    double anchorMinY,
    double anchorMaxX,
    double anchorMaxY,
  ) {
    for (final presets in allPresets.values) {
      for (final preset in presets) {
        if (preset.matches(anchorMinX, anchorMinY, anchorMaxX, anchorMaxY)) {
          return preset;
        }
      }
    }
    return null;
  }

  /// Applies a preset by moving the element to a standard position/size.
  ///
  /// This repositions and/or resizes the element based on the preset type.
  /// Similar to Unity's Alt+Click anchor behavior.
  ///
  /// Returns a map with the new anchor values: {minX, minY, maxX, maxY}
  static Map<String, double> applyPresetMovingElement({
    required AnchorPreset newPreset,
    double defaultSize = 0.2, // Default element size (20% of parent)
  }) {
    const margin = 0.05; // 5% margin from edges

    // For point anchors, position element at that point with default size
    if (newPreset.category == AnchorPresetCategory.point) {
      // Calculate element position based on anchor point
      final anchorX = newPreset.minX;
      final anchorY = newPreset.minY;

      // Position element centered on the anchor point
      final halfSize = defaultSize / 2;

      return {
        'minX': (anchorX - halfSize).clamp(0.0, 1.0 - defaultSize),
        'minY': (anchorY - halfSize).clamp(0.0, 1.0 - defaultSize),
        'maxX': (anchorX + halfSize).clamp(defaultSize, 1.0),
        'maxY': (anchorY + halfSize).clamp(defaultSize, 1.0),
      };
    } else {
      // For stretch anchors, stretch in the specified direction(s)
      final horizontalStretch = newPreset.minX != newPreset.maxX;
      final verticalStretch = newPreset.minY != newPreset.maxY;

      double newMinX, newMaxX, newMinY, newMaxY;

      if (horizontalStretch) {
        // Stretch full width with margins
        newMinX = margin;
        newMaxX = 1.0 - margin;
      } else {
        // Fixed width, centered on anchor X
        final halfSize = defaultSize / 2;
        newMinX = (newPreset.minX - halfSize).clamp(0.0, 1.0 - defaultSize);
        newMaxX = (newPreset.maxX + halfSize).clamp(defaultSize, 1.0);
      }

      if (verticalStretch) {
        // Stretch full height with margins
        newMinY = margin;
        newMaxY = 1.0 - margin;
      } else {
        // Fixed height, centered on anchor Y
        final halfSize = defaultSize / 2;
        newMinY = (newPreset.minY - halfSize).clamp(0.0, 1.0 - defaultSize);
        newMaxY = (newPreset.maxY + halfSize).clamp(defaultSize, 1.0);
      }

      return {
        'minX': newMinX,
        'minY': newMinY,
        'maxX': newMaxX,
        'maxY': newMaxY,
      };
    }
  }
}
