import 'package:flutter/material.dart';
import 'ui_element.dart';
import '../utils/color_utils.dart';

class ButtonElement extends UiElement {
  String text;
  int fontSize;
  Color textColor;
  Color backgroundColor;
  String command;
  String? navigateToPageId; // Optional page navigation

  ButtonElement({
    required super.id,
    super.parentId,
    super.anchorMinX,
    super.anchorMinY,
    super.anchorMaxX,
    super.anchorMaxY,
    this.text = 'Button',
    this.fontSize = 14,
    this.textColor = const Color(0xFFFFFFFF),
    this.backgroundColor = const Color(0xFF5A5A5A),
    this.command = 'button.click',
    this.navigateToPageId,
  });

  @override
  String get elementType => 'Button';

  @override
  String generateCode({required bool isRoot, String builderVar = 'builder'}) {
    String anchorMin = '${anchorMinX.toStringAsFixed(3)} ${anchorMinY.toStringAsFixed(3)}';
    String anchorMax = '${anchorMaxX.toStringAsFixed(3)} ${anchorMaxY.toStringAsFixed(3)}';
    String textColorStr = _colorToCuiColor(textColor);
    String bgColorStr = _colorToCuiColor(backgroundColor);

    return '''elements.Add(new CuiButton
    {
        Button = { Command = "$command", Color = "$bgColorStr" },
        RectTransform = { AnchorMin = "$anchorMin", AnchorMax = "$anchorMax", OffsetMin = "0 0", OffsetMax = "0 0" },
        Text = { Text = "$text", FontSize = $fontSize, Align = TextAnchor.MiddleCenter, Color = "$textColorStr" }
    }, MAIN_UI);''';
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
      'backgroundColor': ColorUtils.colorToInt(backgroundColor),
      'command': command,
      'navigateToPageId': navigateToPageId,
    };
  }

  factory ButtonElement.fromJson(Map<String, dynamic> json) {
    return ButtonElement(
      id: json['id'],
      parentId: json['parentId'],
      anchorMinX: json['anchorMinX'],
      anchorMinY: json['anchorMinY'],
      anchorMaxX: json['anchorMaxX'],
      anchorMaxY: json['anchorMaxY'],
      text: json['text'],
      fontSize: json['fontSize'],
      textColor: Color(json['textColor']),
      backgroundColor: Color(json['backgroundColor']),
      command: json['command'],
      navigateToPageId: json['navigateToPageId'],
    );
  }

  @override
  ButtonElement clone() {
    return ButtonElement(
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
      command: command,
      navigateToPageId: navigateToPageId,
    );
  }
}
