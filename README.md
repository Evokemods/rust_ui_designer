# Rust UI Visual Designer

A Flutter desktop application for visually designing Rust plugin UIs and exporting them as C# code using the [Rust.UI](https://github.com/dassjosh/Rust.UI) library.

## Features

- **Visual Canvas**: Design UIs on a 1920x1080 canvas with drag-and-drop positioning
- **Element Toolbox**: Add Panels, Buttons, Labels, and Images
- **Properties Panel**: Edit colors, text, positions, and other element properties
- **Live Preview**: See your UI design in real-time as you edit
- **Code Export**: Generate ready-to-use C# code for Oxide/uMod plugins
- **Save/Load Projects**: Save your designs as JSON files and reload them later
- **Clipboard Support**: Copy generated code directly to clipboard

## Getting Started

### Prerequisites

- Flutter SDK (3.9.2 or higher)
- Desktop platform enabled (Windows, macOS, or Linux)

### Installation

1. Navigate to the project directory:
   ```bash
   cd rust_ui_designer
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the application:
   ```bash
   flutter run
   ```

## Usage

### Creating a UI Design

1. **Add a Root Panel**: Click the "Panel" button in the toolbox to create your main UI container
2. **Add Elements**: Click Button, Label, or Image to add child elements
3. **Position Elements**:
   - Click and drag elements on the canvas to move them
   - Use the resize handles (blue squares) on selected elements to resize
4. **Edit Properties**: Select an element and use the Properties panel to customize:
   - Colors (background, text)
   - Text content and font size
   - Button commands
   - Anchor positions

### Exporting Code

1. Click the "Export Code" button in the top toolbar
2. Review the generated C# code
3. Either:
   - Click "Copy to Clipboard" to copy the code
   - Click "Save to File" to export as a .cs file

### Saving/Loading Projects

- **Save**: Click the save icon in the toolbar and choose a location
- **Load**: Click the folder icon to open a previously saved project

### Keyboard Shortcuts

- **Delete**: Remove selected element (Backspace is reserved for text editing)

## Understanding the Generated Code

The exported code includes:

- A constant for the UI name
- A `ChatCommand` to open the UI
- A `CreateMainUI` method with all your UI elements
- `ConsoleCommand` methods for button click handlers
- Proper cleanup in close commands

Example output:
```csharp
private const string MAIN_UI = "MyPlugin_Main";

[ChatCommand("menu")]
void CmdMenu(BasePlayer player, string command, string[] args)
{
    CreateMainUI(player);
}

void CreateMainUI(BasePlayer player)
{
    UiBuilder builder = UiBuilder.Create(
        UiPosition.MiddleMiddle,
        new UiOffset(-400, -300, 400, 300),
        new UiColor(0.165f, 0.165f, 0.165f, 1.000f),
        "MyPlugin_Main",
        UiLayer.Hud
    );

    builder.NeedsMouse();

    // ... your UI elements ...

    builder.AddUi(player);
}
```

## Project Structure

```
lib/
├── main.dart                          # App entry point
├── models/                            # Data models
│   ├── ui_element.dart               # Base element class
│   ├── panel_element.dart            # Panel element
│   ├── button_element.dart           # Button element
│   ├── label_element.dart            # Label element
│   ├── image_element.dart            # Image element
│   └── designer_state.dart           # State management
├── screens/
│   └── designer_screen.dart          # Main designer screen
├── widgets/
│   ├── canvas_widget.dart            # Canvas with element rendering
│   ├── toolbox_widget.dart           # Element toolbox sidebar
│   ├── properties_panel_widget.dart  # Properties editor
│   └── export_dialog.dart            # Code export dialog
└── services/
    ├── code_generator.dart           # C# code generation
    └── project_manager.dart          # Save/load functionality
```

## About Rust.UI

Rust UI is a performance-optimized library for creating UIs in Rust game plugins:
- **51x faster** than default Oxide CUI
- **Zero memory allocations**
- Uses builder pattern with helper classes
- Repository: https://github.com/dassjosh/Rust.UI

## Tips

- Start by creating a root panel first
- Use anchor values (0-1) for responsive positioning
- Common anchor presets:
  - Center: 0.5, 0.5, 0.5, 0.5
  - Full screen: 0, 0, 1, 1
  - Top center: 0.5, 1, 0.5, 1
- Button commands like "menu.close" will auto-generate close handlers
- The grid overlay helps with element alignment

## Built With

- [Flutter](https://flutter.dev/) - UI framework
- [Provider](https://pub.dev/packages/provider) - State management
- [flutter_colorpicker](https://pub.dev/packages/flutter_colorpicker) - Color picker
- [file_picker](https://pub.dev/packages/file_picker) - File operations

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
