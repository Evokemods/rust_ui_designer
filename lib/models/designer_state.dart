import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'ui_element.dart';
import 'ui_page.dart';
import 'panel_element.dart';
import 'button_element.dart';
import 'label_element.dart';
import 'image_element.dart';
import 'image_button_element.dart';

class DesignerState with ChangeNotifier {
  final List<UiPage> _pages = [];
  int _currentPageIndex = 0;
  String? _selectedElementId;
  String _projectName = 'MyPlugin';
  String _mainUiName = 'MyPlugin_Main';
  bool _showRustBackground = false;
  String? _backgroundImageUrl;
  bool _snapToGrid = true; // Default: snap enabled

  DesignerState() {
    // Create initial page
    _pages.add(UiPage(
      id: const Uuid().v4(),
      name: 'Page 1',
    ));
  }

  List<UiPage> get pages => _pages;
  int get currentPageIndex => _currentPageIndex;
  UiPage get currentPage => _pages[_currentPageIndex];
  List<UiElement> get elements => currentPage.elements;
  String? get selectedElementId => _selectedElementId;
  String get projectName => _projectName;
  String get mainUiName => _mainUiName;
  bool get showRustBackground => _showRustBackground;
  String? get backgroundImageUrl => _backgroundImageUrl;
  bool get snapToGrid => _snapToGrid;

  UiElement? get selectedElement {
    if (_selectedElementId == null) return null;
    try {
      return currentPage.elements.firstWhere((e) => e.id == _selectedElementId);
    } catch (e) {
      return null;
    }
  }

  PanelElement? get rootPanel {
    return currentPage.rootPanel;
  }

  void setProjectName(String name) {
    _projectName = name;
    notifyListeners();
  }

  void setMainUiName(String name) {
    _mainUiName = name;
    notifyListeners();
  }

  // Page Management
  void addPage({String? name}) {
    final pageNumber = _pages.length + 1;
    _pages.add(UiPage(
      id: const Uuid().v4(),
      name: name ?? 'Page $pageNumber',
    ));
    notifyListeners();
  }

  void removePage(int index) {
    if (_pages.length <= 1) return; // Keep at least one page
    _pages.removeAt(index);
    if (_currentPageIndex >= _pages.length) {
      _currentPageIndex = _pages.length - 1;
    }
    _selectedElementId = null;
    notifyListeners();
  }

  void setCurrentPage(int index) {
    if (index >= 0 && index < _pages.length) {
      _currentPageIndex = index;
      _selectedElementId = null;
      notifyListeners();
    }
  }

  void renamePage(int index, String newName) {
    if (index >= 0 && index < _pages.length) {
      _pages[index].name = newName;
      notifyListeners();
    }
  }

  // Element Management
  void addElement(UiElement element) {
    currentPage.elements.add(element);
    notifyListeners();
  }

  void removeElement(String id) {
    currentPage.elements.removeWhere((e) => e.id == id);
    // Also remove any children
    currentPage.elements.removeWhere((e) => e.parentId == id);
    if (_selectedElementId == id) {
      _selectedElementId = null;
    }
    notifyListeners();
  }

  void selectElement(String? id) {
    _selectedElementId = id;
    notifyListeners();
  }

  void updateElement(String id, UiElement updatedElement) {
    int index = currentPage.elements.indexWhere((e) => e.id == id);
    if (index != -1) {
      currentPage.elements[index] = updatedElement;
      notifyListeners();
    }
  }

  void clearAll() {
    currentPage.elements.clear();
    _selectedElementId = null;
    notifyListeners();
  }

  void toggleRustBackground() {
    _showRustBackground = !_showRustBackground;
    notifyListeners();
  }

  void setBackgroundImageUrl(String? url) {
    _backgroundImageUrl = url;
    notifyListeners();
  }

  void toggleSnapToGrid() {
    _snapToGrid = !_snapToGrid;
    notifyListeners();
  }

  void loadFromJson(Map<String, dynamic> json) {
    _projectName = json['projectName'] ?? 'MyPlugin';
    _mainUiName = json['mainUiName'] ?? 'MyPlugin_Main';
    _backgroundImageUrl = json['backgroundImageUrl'];
    _snapToGrid = json['snapToGrid'] ?? true; // Default to true if not in file
    _pages.clear();

    // Support both old format (single page) and new format (multiple pages)
    if (json.containsKey('pages')) {
      // New multi-page format
      List<dynamic> pagesJson = json['pages'] ?? [];
      for (var pageJson in pagesJson) {
        _pages.add(UiPage.fromJson(pageJson));
      }
    } else if (json.containsKey('elements')) {
      // Old single-page format - convert to page
      _pages.add(UiPage(
        id: const Uuid().v4(),
        name: 'Page 1',
      ));

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
          _pages[0].elements.add(element);
        }
      }
    }

    // Ensure at least one page exists
    if (_pages.isEmpty) {
      _pages.add(UiPage(
        id: const Uuid().v4(),
        name: 'Page 1',
      ));
    }

    _currentPageIndex = 0;
    notifyListeners();
  }

  Map<String, dynamic> toJson() {
    return {
      'projectName': _projectName,
      'mainUiName': _mainUiName,
      'backgroundImageUrl': _backgroundImageUrl,
      'snapToGrid': _snapToGrid,
      'pages': _pages.map((p) => p.toJson()).toList(),
    };
  }
}
