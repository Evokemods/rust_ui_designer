enum UiLayer {
  hud('Hud'),
  overlay('Overlay'),
  overall('Overall');

  final String value;
  const UiLayer(this.value);
}

abstract class UiElement {
  final String id;
  String? parentId;

  // Anchor-based positioning (0-1 normalized)
  double anchorMinX;
  double anchorMinY;
  double anchorMaxX;
  double anchorMaxY;

  // Optional offset-based positioning (pixels)
  double? offsetMinX;
  double? offsetMinY;
  double? offsetMaxX;
  double? offsetMaxY;

  UiElement({
    required this.id,
    this.parentId,
    this.anchorMinX = 0,
    this.anchorMinY = 0,
    this.anchorMaxX = 1,
    this.anchorMaxY = 1,
    this.offsetMinX,
    this.offsetMinY,
    this.offsetMaxX,
    this.offsetMaxY,
  });

  String get elementType;

  String generateCode({required bool isRoot, String builderVar = 'builder'});

  Map<String, dynamic> toJson();

  UiElement clone();
}
