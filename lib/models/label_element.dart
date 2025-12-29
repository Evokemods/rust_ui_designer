import 'package:flutter/material.dart';
import 'ui_element.dart';
import '../utils/color_utils.dart';

class LabelElement extends UiElement {
  String text;
  int fontSize;
  Color textColor;
  Color? backgroundColor;
  TextAlign textAlign;

  LabelElement({
    required super.id,
    super.parentId,
    super.anchorMinX,
    super.anchorMinY,
    super.anchorMaxX,
    super.anchorMaxY,
    this.text = 'Label',
    this.fontSize = 14,
    this.textColor = const Color(0xFFFFFFFF),
    this.backgroundColor,
    this.textAlign = TextAlign.center,
  });

  @override
  String get elementType => 'Label';

  @override
  String generateCode({required bool isRoot, String builderVar = 'builder'}) {
    String anchorMin = '${anchorMinX.toStringAsFixed(3)} ${anchorMinY.toStringAsFixed(3)}';
    String anchorMax = '${anchorMaxX.toStringAsFixed(3)} ${anchorMaxY.toStringAsFixed(3)}';
    String textColorStr = _colorToCuiColor(textColor);
    String textAnchor = _getTextAnchor();

    return '''elements.Add(new CuiLabel
    {
        Text = { Text = "$text", FontSize = $fontSize, Align = TextAnchor.$textAnchor, Color = "$textColorStr" },
        RectTransform = { AnchorMin = "$anchorMin", AnchorMax = "$anchorMax", OffsetMin = "0 0", OffsetMax = "0 0" }
    }, MAIN_UI);''';
  }

  String _getTextAnchor() {
    // Map Flutter TextAlign to Unity TextAnchor
    switch (textAlign) {
      case TextAlign.left:
        return 'MiddleLeft';
      case TextAlign.right:
        return 'MiddleRight';
      case TextAlign.center:
      default:
        return 'MiddleCenter';
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
      'text': text,
      'fontSize': fontSize,
      'textColor': ColorUtils.colorToInt(textColor),
      'backgroundColor': backgroundColor != null ? ColorUtils.colorToInt(backgroundColor!) : null,
      'textAlign': textAlign.index,
    };
  }

  factory LabelElement.fromJson(Map<String, dynamic> json) {
    return LabelElement(
      id: json['id'],
      parentId: json['parentId'],
      anchorMinX: json['anchorMinX'],
      anchorMinY: json['anchorMinY'],
      anchorMaxX: json['anchorMaxX'],
      anchorMaxY: json['anchorMaxY'],
      text: json['text'],
      fontSize: json['fontSize'],
      textColor: Color(json['textColor']),
      backgroundColor: json['backgroundColor'] != null ? Color(json['backgroundColor']) : null,
      textAlign: TextAlign.values[json['textAlign']],
    );
  }

  @override
  LabelElement clone() {
    return LabelElement(
      id: id,
      parentId: parentId,
      anchorMinX: anchorMinX,
      anchorMinY: anchorMinY,
      anchorMaxX: anchorMaxX,
      anchorMaxY: anchorMaxY,
      text: text,
      fontSize: fontSize,
      textColor: textColor,
      backgroundColor: backgroundColor,
      textAlign: textAlign,
    );
  }
}
