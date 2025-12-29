import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/designer_state.dart';
import '../widgets/canvas_widget.dart';
import '../widgets/toolbox_widget.dart';
import '../widgets/properties_panel_widget.dart';
import '../widgets/page_tabs_widget.dart';
import '../widgets/export_dialog.dart';
import '../widgets/help_dialog.dart';
import '../widgets/background_settings_dialog.dart';
import '../services/code_generator.dart';
import '../services/project_manager.dart';

class DesignerScreen extends StatelessWidget {
  const DesignerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rust UI Visual Designer'),
        backgroundColor: Colors.grey[900],
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            tooltip: 'Help & Tips',
            onPressed: () => _showHelp(context),
          ),
          const SizedBox(width: 10),
          Consumer<DesignerState>(
            builder: (context, state, child) {
              return IconButton(
                icon: Icon(
                  state.showRustBackground ? Icons.image : Icons.image_outlined,
                ),
                tooltip: 'Background Image Settings',
                onPressed: () => _showBackgroundSettings(context, state),
                color: state.showRustBackground ? Colors.green : null,
              );
            },
          ),
          const SizedBox(width: 10),
          Consumer<DesignerState>(
            builder: (context, state, child) {
              return IconButton(
                icon: Icon(
                  state.snapToGrid ? Icons.grid_on : Icons.grid_off,
                ),
                tooltip: state.snapToGrid ? 'Snap to Grid: ON' : 'Snap to Grid: OFF',
                onPressed: () => state.toggleSnapToGrid(),
                color: state.snapToGrid ? Colors.green : Colors.grey,
              );
            },
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: const Icon(Icons.file_open),
            tooltip: 'Open Project',
            onPressed: () => _loadProject(context),
          ),
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Save Project',
            onPressed: () => _saveProject(context),
          ),
          const SizedBox(width: 20),
          ElevatedButton.icon(
            onPressed: () => _exportCode(context),
            icon: const Icon(Icons.code),
            label: const Text('Export Code'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[700],
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Consumer<DesignerState>(
        builder: (context, state, child) {
          return Row(
            children: const [
              ToolboxWidget(),
              Expanded(
                child: Column(
                  children: [
                    PageTabsWidget(),
                    Expanded(child: CanvasWidget()),
                  ],
                ),
              ),
              PropertiesPanelWidget(),
            ],
          );
        },
      ),
    );
  }

  void _showHelp(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const HelpDialog(),
    );
  }

  void _showBackgroundSettings(BuildContext context, DesignerState state) async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => BackgroundSettingsDialog(
        currentUrl: state.backgroundImageUrl,
      ),
    );

    if (result != null) {
      // User clicked Save or Clear
      if (result.isEmpty) {
        // Clear button
        state.setBackgroundImageUrl(null);
        state.toggleRustBackground(); // Turn off background
      } else {
        // Save button with URL
        state.setBackgroundImageUrl(result);
        if (!state.showRustBackground) {
          state.toggleRustBackground(); // Turn on background
        }
      }
    }
  }

  void _exportCode(BuildContext context) {
    var state = context.read<DesignerState>();

    // Check if any page has elements
    bool hasElements = state.pages.any((page) => page.elements.isNotEmpty);
    if (!hasElements) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No elements to export. Add some UI elements first.')),
      );
      return;
    }

    // Generate code snippet (for pasting into existing plugin)
    String codeSnippet = CodeGenerator.generate(
      pages: state.pages,
      projectName: state.projectName,
      mainUiName: state.mainUiName,
    );

    // Generate complete plugin file
    String completePlugin = CodeGenerator.generateCompletePlugin(
      pages: state.pages,
      projectName: state.projectName,
      mainUiName: state.mainUiName,
      pluginAuthor: 'YourName',
      pluginVersion: '1.0.0',
    );

    showDialog(
      context: context,
      builder: (context) => ExportDialog(
        codeSnippet: codeSnippet,
        completePlugin: completePlugin,
        fileName: '${state.projectName}.cs',
      ),
    );
  }

  Future<void> _saveProject(BuildContext context) async {
    var state = context.read<DesignerState>();
    Map<String, dynamic> projectData = state.toJson();

    bool success = await ProjectManager.saveProject(projectData);

    if (success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Project saved successfully!')),
      );
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Save cancelled or failed')),
      );
    }
  }

  Future<void> _loadProject(BuildContext context) async {
    Map<String, dynamic>? projectData = await ProjectManager.loadProject();

    if (projectData != null && context.mounted) {
      var state = context.read<DesignerState>();
      state.loadFromJson(projectData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Project loaded successfully!')),
      );
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Load cancelled or failed')),
      );
    }
  }
}
