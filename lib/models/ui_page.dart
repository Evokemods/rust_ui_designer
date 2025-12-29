import 'ui_element.dart';
import 'panel_element.dart';
import 'button_element.dart';
import 'label_element.dart';
import 'image_element.dart';
import 'image_button_element.dart';

class UiPage {
  final String id;
  String name;
  List<UiElement> elements;

  UiPage({
    required this.id,
    required this.name,
    List<UiElement>? elements,
  }) : elements = elements ?? [];

  PanelElement? get rootPanel {
    try {
      return elements.firstWhere((e) => e is PanelElement && e.parentId == null) as PanelElement;
    } catch (e) {
      return null;
    }
  }

  UiPage clone() {
    return UiPage(
      id: id,
      name: name,
      elements: elements.map((e) => e).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'elements': elements.map((e) => e.toJson()).toList(),
    };
  }

  factory UiPage.fromJson(Map<String, dynamic> json) {
    List<UiElement> pageElements = [];
    List<dynamic> elementsJson = json['elements'] ?? [];

    for (var elementJson in elementsJson) {
      String type = elementJson['type'];
      UiElement? element;

      switch (type) {
        case 'Panel':
          element = PanelElement.fromJson(elementJson);
          break;
        case 'Button':
          element = ButtonElement.fromJson(elementJson);
          break;
        case 'Label':
          element = LabelElement.fromJson(elementJson);
          break;
        case 'Image':
          element = ImageElement.fromJson(elementJson);
          break;
        case 'ImageButton':
          element = ImageButtonElement.fromJson(elementJson);
          break;
      }

      if (element != null) {
        pageElements.add(element);
      }
    }

    return UiPage(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Page',
      elements: pageElements,
    );
  }
}
