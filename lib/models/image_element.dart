import 'package:flutter/material.dart';
import 'ui_element.dart';
import '../utils/color_utils.dart';

class ImageElement extends UiElement {
  String imageUrl;
  Color? color;

  ImageElement({
    required super.id,
    super.parentId,
    super.anchorMinX,
    super.anchorMinY,
    super.anchorMaxX,
    super.anchorMaxY,
    this.imageUrl = 'https://example.com/image.png',
    this.color,
  });

  @override
  String get elementType => 'Image';

  @override
  String generateCode({required bool isRoot, String builderVar = 'builder'}) {
    String anchorMin = '${anchorMinX.toStringAsFixed(3)} ${anchorMinY.toStringAsFixed(3)}';
    String anchorMax = '${anchorMaxX.toStringAsFixed(3)} ${anchorMaxY.toStringAsFixed(3)}';

    return '''elements.Add(new CuiElement
    {
        Parent = MAIN_UI,
        Components =
        {
            new CuiRawImageComponent { Url = "$imageUrl" },
            new CuiRectTransformComponent { AnchorMin = "$anchorMin", AnchorMax = "$anchorMax", OffsetMin = "0 0", OffsetMax = "0 0" }
        }
    });''';
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
      'imageUrl': imageUrl,
      'color': color != null ? ColorUtils.colorToInt(color!) : null,
    };
  }

  factory ImageElement.fromJson(Map<String, dynamic> json) {
    return ImageElement(
      id: json['id'],
      parentId: json['parentId'],
      anchorMinX: json['anchorMinX'],
      anchorMinY: json['anchorMinY'],
      anchorMaxX: json['anchorMaxX'],
      anchorMaxY: json['anchorMaxY'],
      imageUrl: json['imageUrl'],
      color: json['color'] != null ? Color(json['color']) : null,
    );
  }

  @override
  ImageElement clone() {
    return ImageElement(
      id: id,
      parentId: parentId,
      anchorMinX: anchorMinX,
      anchorMinY: anchorMinY,
      anchorMaxX: anchorMaxX,
      anchorMaxY: anchorMaxY,
      imageUrl: imageUrl,
      color: color,
    );
  }
}
