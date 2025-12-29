import 'package:flutter/material.dart';
import 'ui_element.dart';
import '../utils/color_utils.dart';

class PanelElement extends UiElement {
  Color backgroundColor;
  bool needsMouse;
  bool needsKeyboard;
  String name;
  UiLayer layer;

  PanelElement({
    required super.id,
    super.parentId,
    super.anchorMinX,
    super.anchorMinY,
    super.anchorMaxX,
    super.anchorMaxY,
    super.offsetMinX,
    super.offsetMinY,
    super.offsetMaxX,
    super.offsetMaxY,
    this.backgroundColor = const Color(0xFF2A2A2A),
    this.needsMouse = false,
    this.needsKeyboard = false,
    this.name = 'Panel',
    this.layer = UiLayer.hud,
  });

  @override
  String get elementType => 'Panel';

  @override
  String generateCode({required bool isRoot, String builderVar = 'builder'}) {
    String colorStr = _colorToCuiColor(backgroundColor);
    String layerName = layer == UiLayer.hud ? 'Hud' : layer == UiLayer.overlay ? 'Overlay' : 'Overall';

    if (isRoot) {
      // Root panel - use BankSystem approach with center anchor + pixel offsets
      // Calculate pixel dimensions from anchors using Rust's 1280x720 reference resolution
      double width = (anchorMaxX - anchorMinX) * 1280;
      double height = (anchorMaxY - anchorMinY) * 720;
      double centerX = (anchorMinX + anchorMaxX) / 2;
      double centerY = (anchorMinY + anchorMaxY) / 2;

      // Convert to pixel offsets from center
      double offsetMinX = -(width / 2);
      double offsetMinY = -(height / 2);
      double offsetMaxX = width / 2;
      double offsetMaxY = height / 2;

      return '''elements.Add(new CuiPanel
    {
        Image = { Color = "$colorStr" },
        RectTransform = { AnchorMin = "${centerX.toStringAsFixed(3)} ${centerY.toStringAsFixed(3)}", AnchorMax = "${centerX.toStringAsFixed(3)} ${centerY.toStringAsFixed(3)}", OffsetMin = "${offsetMinX.toStringAsFixed(1)} ${offsetMinY.toStringAsFixed(1)}", OffsetMax = "${offsetMaxX.toStringAsFixed(1)} ${offsetMaxY.toStringAsFixed(1)}" },
        CursorEnabled = $needsMouse
    }, "$layerName", MAIN_UI);''';
    } else {
      // Child elements - use anchors relative to parent (0-1 range already correct)
      String anchorMin = '${anchorMinX.toStringAsFixed(3)} ${anchorMinY.toStringAsFixed(3)}';
      String anchorMax = '${anchorMaxX.toStringAsFixed(3)} ${anchorMaxY.toStringAsFixed(3)}';

      return '''elements.Add(new CuiPanel
    {
        Image = { Color = "$colorStr" },
        RectTransform = { AnchorMin = "$anchorMin", AnchorMax = "$anchorMax", OffsetMin = "0 0", OffsetMax = "0 0" }
    }, MAIN_UI);''';
    }
  }

  String _colorToCuiColor(Color color) {
    // Convert Flutter Color to CUI color format "r g b a" (space-separated, 0-1 range)
    double r = color.r;
    double g = color.g;
    double b = color.b;
    double a = color.a;
    return '${r.toStringAsFixed(3)} ${g.toStringAsFixed(3)} ${b.toStringAsFixed(3)} ${a.toStringAsFixed(3)}';
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': elementType,
      'id': id,
      'parentId': parentId,
      'anchorMinX': anchorMinX,
      'anchorMinY': anchorMinY,
      'anchorMaxX': anchorMaxX,
      'anchorMaxY': anchorMaxY,
      'offsetMinX': offsetMinX,
      'offsetMinY': offsetMinY,
      'offsetMaxX': offsetMaxX,
      'offsetMaxY': offsetMaxY,
      'backgroundColor': ColorUtils.colorToInt(backgroundColor),
      'needsMouse': needsMouse,
      'needsKeyboard': needsKeyboard,
      'name': name,
      'layer': layer.value,
    };
  }

  factory PanelElement.fromJson(Map<String, dynamic> json) {
    return PanelElement(
      id: json['id'],
      parentId: json['parentId'],
      anchorMinX: json['anchorMinX'],
      anchorMinY: json['anchorMinY'],
      anchorMaxX: json['anchorMaxX'],
      anchorMaxY: json['anchorMaxY'],
      offsetMinX: json['offsetMinX'],
      offsetMinY: json['offsetMinY'],
      offsetMaxX: json['offsetMaxX'],
      offsetMaxY: json['offsetMaxY'],
      backgroundColor: Color(json['backgroundColor']),
      needsMouse: json['needsMouse'],
      needsKeyboard: json['needsKeyboard'],
      name: json['name'],
      layer: UiLayer.values.firstWhere((e) => e.value == json['layer']),
    );
  }

  @override
  PanelElement clone() {
    return PanelElement(
      id: id,
      parentId: parentId,
      anchorMinX: anchorMinX,
      anchorMinY: anchorMinY,
      anchorMaxX: anchorMaxX,
      anchorMaxY: anchorMaxY,
      offsetMinX: offsetMinX,
      offsetMinY: offsetMinY,
      offsetMaxX: offsetMaxX,
      offsetMaxY: offsetMaxY,
      backgroundColor: backgroundColor,
      needsMouse: needsMouse,
      needsKeyboard: needsKeyboard,
      name: name,
      layer: layer,
    );
  }
}
