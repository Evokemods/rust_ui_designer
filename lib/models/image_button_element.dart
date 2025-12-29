import 'ui_element.dart';

class ImageButtonElement extends UiElement {
  String imageUrl;
  String imageUrlClicked;
  String command;

  ImageButtonElement({
    required super.id,
    super.parentId,
    super.anchorMinX,
    super.anchorMinY,
    super.anchorMaxX,
    super.anchorMaxY,
    this.imageUrl = 'https://rustlabs.com/img/items180/wood.png',
    this.imageUrlClicked = 'https://rustlabs.com/img/items180/stones.png',
    this.command = 'imagebutton.click',
  });

  @override
  String get elementType => 'ImageButton';

  @override
  String generateCode({required bool isRoot, String builderVar = 'builder'}) {
    String anchorMin = '${anchorMinX.toStringAsFixed(3)} ${anchorMinY.toStringAsFixed(3)}';
    String anchorMax = '${anchorMaxX.toStringAsFixed(3)} ${anchorMaxY.toStringAsFixed(3)}';

    // Generate the image element
    String imageCode = '''elements.Add(new CuiElement
    {
        Parent = MAIN_UI,
        Components =
        {
            new CuiRawImageComponent { Url = "$imageUrl" },
            new CuiRectTransformComponent { AnchorMin = "$anchorMin", AnchorMax = "$anchorMax", OffsetMin = "0 0", OffsetMax = "0 0" }
        }
    });''';

    // Generate transparent button overlay
    String buttonCode = '''elements.Add(new CuiButton
    {
        Button = { Command = "$command", Color = "0.000 0.000 0.000 0.000" },
        RectTransform = { AnchorMin = "$anchorMin", AnchorMax = "$anchorMax", OffsetMin = "0 0", OffsetMax = "0 0" },
        Text = { Text = "", FontSize = 1, Align = TextAnchor.MiddleCenter, Color = "0.000 0.000 0.000 0.000" }
    }, MAIN_UI);''';

    return '$imageCode\n\n    $buttonCode';
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
      'imageUrlClicked': imageUrlClicked,
      'command': command,
    };
  }

  factory ImageButtonElement.fromJson(Map<String, dynamic> json) {
    return ImageButtonElement(
      id: json['id'],
      parentId: json['parentId'],
      anchorMinX: json['anchorMinX'],
      anchorMinY: json['anchorMinY'],
      anchorMaxX: json['anchorMaxX'],
      anchorMaxY: json['anchorMaxY'],
      imageUrl: json['imageUrl'] ?? 'https://rustlabs.com/img/items180/wood.png',
      imageUrlClicked: json['imageUrlClicked'] ?? 'https://rustlabs.com/img/items180/stones.png',
      command: json['command'] ?? 'imagebutton.click',
    );
  }

  @override
  ImageButtonElement clone() {
    return ImageButtonElement(
      id: id,
      parentId: parentId,
      anchorMinX: anchorMinX,
      anchorMinY: anchorMinY,
      anchorMaxX: anchorMaxX,
      anchorMaxY: anchorMaxY,
      imageUrl: imageUrl,
      imageUrlClicked: imageUrlClicked,
      command: command,
    );
  }
}
