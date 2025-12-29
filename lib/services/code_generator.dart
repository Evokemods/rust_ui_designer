import '../models/ui_element.dart';
import '../models/ui_page.dart';
import '../models/panel_element.dart';
import '../models/button_element.dart';
import '../models/image_button_element.dart';

class CodeGenerator {
  /// Generates a complete C# plugin file with all boilerplate
  static String generateCompletePlugin({
    required List<UiPage> pages,
    required String projectName,
    required String mainUiName,
    String pluginAuthor = 'YourName',
    String pluginVersion = '1.0.0',
  }) {
    if (pages.isEmpty) {
      return '// No pages to generate';
    }

    StringBuffer code = StringBuffer();

    // Add using statements
    code.writeln('using Oxide.Core;');
    code.writeln('using Oxide.Core.Plugins;');
    code.writeln('using Oxide.Game.Rust.Cui;');
    code.writeln('using UnityEngine;');
    code.writeln();

    // Add namespace
    code.writeln('namespace Oxide.Plugins');
    code.writeln('{');

    // Add plugin info attributes
    code.writeln('    [Info("$projectName", "$pluginAuthor", "$pluginVersion")]');
    code.writeln('    [Description("$projectName UI Plugin")]');
    code.writeln('    public class $projectName : RustPlugin');
    code.writeln('    {');

    // Generate the UI code (indented by 8 spaces for class body)
    String uiMethods = generate(pages: pages, projectName: projectName, mainUiName: mainUiName);
    // Indent each line by 8 spaces
    List<String> lines = uiMethods.split('\n');
    for (var line in lines) {
      if (line.isNotEmpty) {
        code.writeln('        $line');
      } else {
        code.writeln();
      }
    }

    // Close class and namespace
    code.writeln('    }');
    code.writeln('}');

    return code.toString();
  }

  /// Generates just the UI methods (for copy-paste into existing plugin)
  static String generate({
    required List<UiPage> pages,
    required String projectName,
    required String mainUiName,
  }) {
    if (pages.isEmpty) {
      return '// No pages to generate';
    }

    StringBuffer code = StringBuffer();

    // Generate constant
    code.writeln('private const string MAIN_UI = "$mainUiName";');
    code.writeln();

    // Generate chat command to open UI (opens first page)
    code.writeln('[ChatCommand("menu")]');
    code.writeln('void CmdMenu(BasePlayer player, string command, string[] args)');
    code.writeln('{');
    code.writeln('    CreatePage1UI(player);');
    code.writeln('}');
    code.writeln();

    // Generate create UI method for each page
    for (int i = 0; i < pages.length; i++) {
      final page = pages[i];
      final pageNumber = i + 1;

      code.write(_generatePageUI(page, pageNumber, pages, mainUiName));
      code.writeln();

      // Check if page has image buttons - if so, generate clicked version too
      final hasImageButtons = page.elements.any((e) => e is ImageButtonElement);
      if (hasImageButtons) {
        code.write(_generatePageUIClicked(page, pageNumber, pages, mainUiName));
        code.writeln();
      }
    }

    // Generate DestroyUI method
    code.writeln('void DestroyUI(BasePlayer player)');
    code.writeln('{');
    code.writeln('    CuiHelper.DestroyUi(player, MAIN_UI);');
    code.writeln('}');
    code.writeln();

    // Generate console commands for all buttons across all pages
    code.write(_generateButtonCommands(pages));

    return code.toString();
  }

  static String _generatePageUI(UiPage page, int pageNumber, List<UiPage> allPages, String mainUiName) {
    return _generatePageUIInternal(page, pageNumber, allPages, mainUiName, isClickedVersion: false);
  }

  static String _generatePageUIClicked(UiPage page, int pageNumber, List<UiPage> allPages, String mainUiName) {
    return _generatePageUIInternal(page, pageNumber, allPages, mainUiName, isClickedVersion: true);
  }

  static String _generatePageUIInternal(UiPage page, int pageNumber, List<UiPage> allPages, String mainUiName, {required bool isClickedVersion}) {
    if (page.elements.isEmpty) {
      return '// Page $pageNumber has no elements';
    }

    // Find root panel
    PanelElement? rootPanel = page.rootPanel;
    if (rootPanel == null) {
      return '// Error: Page $pageNumber has no root panel. Please add a panel first.';
    }

    StringBuffer code = StringBuffer();

    // Generate CreatePageXUI or CreatePageXUIClicked method
    final methodName = isClickedVersion ? 'CreatePage${pageNumber}UIClicked' : 'CreatePage${pageNumber}UI';
    code.writeln('void $methodName(BasePlayer player)');
    code.writeln('{');
    code.writeln('    // Destroy existing UI first');
    code.writeln('    DestroyUI(player);');
    code.writeln();
    code.writeln('    // Create CUI elements${isClickedVersion ? ' with clicked image' : ''}');
    code.writeln('    var elements = new CuiElementContainer();');
    code.writeln();

    // Generate root panel creation
    code.writeln('    ${rootPanel.generateCode(isRoot: true)}');
    code.writeln();

    // Generate child elements (convert to parent-relative coordinates)
    List<UiElement> childElements = page.elements
        .where((e) => e.id != rootPanel.id)
        .toList();

    // Map page IDs to page numbers for navigation
    Map<String, int> pageIdToNumber = {};
    for (int i = 0; i < allPages.length; i++) {
      pageIdToNumber[allPages[i].id] = i + 1;
    }

    // Store original root panel bounds for conversion
    double rootMinX = rootPanel.anchorMinX;
    double rootMinY = rootPanel.anchorMinY;
    double rootMaxX = rootPanel.anchorMaxX;
    double rootMaxY = rootPanel.anchorMaxY;
    double rootWidth = rootMaxX - rootMinX;
    double rootHeight = rootMaxY - rootMinY;

    for (var element in childElements) {
      // Convert screen-relative coords to parent-relative coords
      UiElement convertedElement = element.clone();
      convertedElement.anchorMinX = (element.anchorMinX - rootMinX) / rootWidth;
      convertedElement.anchorMinY = (element.anchorMinY - rootMinY) / rootHeight;
      convertedElement.anchorMaxX = (element.anchorMaxX - rootMinX) / rootWidth;
      convertedElement.anchorMaxY = (element.anchorMaxY - rootMinY) / rootHeight;

      // Special handling for ImageButton elements
      if (convertedElement is ImageButtonElement) {
        if (isClickedVersion) {
          // Generate code with clicked image
          code.writeln('    ${_generateImageButtonCode(convertedElement, useClickedImage: true)}');
        } else {
          // Generate code with normal image
          code.writeln('    ${convertedElement.generateCode(isRoot: false)}');
        }
        code.writeln();
        continue;
      }

      // Special handling for buttons with page navigation
      if (convertedElement is ButtonElement && convertedElement.navigateToPageId != null) {
        final targetPageId = convertedElement.navigateToPageId!;
        if (pageIdToNumber.containsKey(targetPageId)) {
          final targetPageNumber = pageIdToNumber[targetPageId]!;
          // Modify command for navigation
          convertedElement.command = 'nav.page$targetPageNumber';
          code.writeln('    ${convertedElement.generateCode(isRoot: false)}');
          code.writeln();
          continue;
        }
      }
      code.writeln('    ${convertedElement.generateCode(isRoot: false)}');
      code.writeln();
    }

    // Add UI to player
    code.writeln('    CuiHelper.AddUi(player, elements);');
    code.writeln('}');

    return code.toString();
  }

  static String _generateImageButtonCode(ImageButtonElement element, {required bool useClickedImage}) {
    String anchorMin = '${element.anchorMinX.toStringAsFixed(3)} ${element.anchorMinY.toStringAsFixed(3)}';
    String anchorMax = '${element.anchorMaxX.toStringAsFixed(3)} ${element.anchorMaxY.toStringAsFixed(3)}';
    String imageUrl = useClickedImage ? element.imageUrlClicked : element.imageUrl;

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
        Button = { Command = "${element.command}", Color = "0.000 0.000 0.000 0.000" },
        RectTransform = { AnchorMin = "$anchorMin", AnchorMax = "$anchorMax", OffsetMin = "0 0", OffsetMax = "0 0" },
        Text = { Text = "", FontSize = 1, Align = TextAnchor.MiddleCenter, Color = "0.000 0.000 0.000 0.000" }
    }, MAIN_UI);''';

    return '$imageCode\n\n    $buttonCode';
  }

  static String _generateButtonCommands(List<UiPage> pages) {
    StringBuffer code = StringBuffer();
    Set<String> generatedCommands = {};

    // Map page IDs to page numbers for navigation
    Map<String, int> pageIdToNumber = {};
    for (int i = 0; i < pages.length; i++) {
      pageIdToNumber[pages[i].id] = i + 1;
    }

    // Collect all ImageButton commands with their page numbers
    Map<String, int> imageButtonCommandToPage = {};
    for (int i = 0; i < pages.length; i++) {
      final page = pages[i];
      final pageNumber = i + 1;
      for (var element in page.elements.whereType<ImageButtonElement>()) {
        imageButtonCommandToPage[element.command] = pageNumber;
      }
    }

    // Collect all buttons with their target pages
    Map<String, String?> buttonCommandToPageNav = {};
    for (var page in pages) {
      for (var button in page.elements.whereType<ButtonElement>()) {
        // If button has page navigation and we haven't seen this command yet
        if (button.navigateToPageId != null && !buttonCommandToPageNav.containsKey(button.command)) {
          buttonCommandToPageNav[button.command] = button.navigateToPageId;
        }
      }
    }

    // Collect all buttons from all pages
    List<ButtonElement> allButtons = [];
    for (var page in pages) {
      allButtons.addAll(page.elements.whereType<ButtonElement>());
    }

    // Generate console commands for ImageButtons first
    for (var entry in imageButtonCommandToPage.entries) {
      final command = entry.key;
      final pageNumber = entry.value;

      if (!generatedCommands.contains(command)) {
        generatedCommands.add(command);

        code.writeln('[ConsoleCommand("$command")]');
        code.writeln('void Cmd${_toPascalCase(command)}(ConsoleSystem.Arg arg)');
        code.writeln('{');
        code.writeln('    BasePlayer player = arg.Player();');
        code.writeln('    if (player != null)');
        code.writeln('    {');
        code.writeln('        DestroyUI(player);');
        code.writeln('        CreatePage${pageNumber}UIClicked(player);');
        code.writeln('    }');
        code.writeln('}');
        code.writeln();
      }
    }

    // Generate console commands for regular buttons
    for (var button in allButtons) {
      String commandToGenerate = button.command;
      String? targetPageId = button.navigateToPageId;

      // If button has page navigation, create a unique command for this navigation
      if (targetPageId != null && pageIdToNumber.containsKey(targetPageId)) {
        final targetPageNumber = pageIdToNumber[targetPageId]!;
        commandToGenerate = 'nav.page$targetPageNumber';
      }

      if (!generatedCommands.contains(commandToGenerate)) {
        generatedCommands.add(commandToGenerate);

        code.writeln('[ConsoleCommand("$commandToGenerate")]');
        code.writeln('void Cmd${_toPascalCase(commandToGenerate)}(ConsoleSystem.Arg arg)');
        code.writeln('{');
        code.writeln('    BasePlayer player = arg.Player();');
        code.writeln('    if (player != null)');
        code.writeln('    {');

        // Check if button has page navigation
        if (targetPageId != null && pageIdToNumber.containsKey(targetPageId)) {
          final targetPageNumber = pageIdToNumber[targetPageId]!;
          code.writeln('        CreatePage${targetPageNumber}UI(player);');
        }
        // Check if this is a close button
        else if (button.command.contains('close') || button.text == '×' || button.text.toLowerCase() == 'close') {
          code.writeln('        DestroyUI(player);');
        }
        // Default: Add implementation comment
        else {
          code.writeln('        // IMPLEMENT: Add ${button.command} logic here');
        }

        code.writeln('    }');
        code.writeln('}');
        code.writeln();
      }
    }

    return code.toString();
  }

  static String _toPascalCase(String input) {
    // Convert command like "menu.close" to "MenuClose"
    return input
        .split('.')
        .map((word) => word.isEmpty ? '' : '${word[0].toUpperCase()}${word.substring(1)}')
        .join('');
  }
}
