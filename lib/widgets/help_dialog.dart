import 'package:flutter/material.dart';

class HelpDialog extends StatelessWidget {
  const HelpDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Theme(
        data: ThemeData.light(),
        child: Container(
          width: 900,
          height: 700,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'UI Designer - Help & Tips',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSection('Getting Started', [
                        '1. Click "Panel" to create a root panel (required first)',
                        '2. Add Buttons, Labels, or Images as child elements',
                        '3. Click elements to select and edit properties',
                        '4. Drag elements to move them, use handles to resize',
                        '5. Click "Export Code" to generate C# code',
                      ]),
                      _buildSection('Keyboard Shortcuts', [
                        'Delete - Remove selected element',
                        'Backspace - Edit text in properties panel',
                      ]),
                      _buildSection('✅ What You CAN Do (Features)', [
                        '• Create panels as containers',
                        '• Add buttons with click commands',
                        '• Add text labels (with optional background)',
                        '• Add images from URLs',
                        '• Use anchor-based positioning (0-1 normalized)',
                        '• Set colors using RGBA values',
                        '• Enable mouse/keyboard interaction on panels',
                        '• Nest elements inside panels',
                        '• Use predefined Rust UI colors',
                      ]),
                      _buildSection('❌ What You CANNOT Do (Limitations)', [
                        '• Cannot nest elements inside Buttons/Labels/Images (only Panels can be parents)',
                        '• Cannot use complex CSS-like styling',
                        '• Cannot add animations (Rust UI is static)',
                        '• Cannot use gradients or shadows',
                        '• Cannot use custom fonts (Rust uses built-in fonts)',
                        '• Cannot use relative sizes (must use anchors 0-1)',
                      ]),
                      _buildSection('Positioning System', [
                        'Anchors: 0-1 normalized coordinates',
                        '• 0,0 = Bottom-left corner',
                        '• 1,1 = Top-right corner',
                        '• 0.5,0.5 = Center',
                        '',
                        'Reference Resolution: 1920×1080',
                        '• Designer uses standard HD resolution',
                        '• Test in-game to verify positioning',
                        '• May need adjustments for different resolutions',
                        '',
                        'Examples:',
                        '• Full screen: 0,0 to 1,1',
                        '• Center 50%: 0.25,0.25 to 0.75,0.75',
                        '• Top bar: 0,0.9 to 1,1',
                        '• Bottom bar: 0,0 to 1,0.1',
                      ]),
                      _buildSection('Color System', [
                        'Colors are RGBA (0-1 normalized):',
                        '• Red: 1, 0, 0, 1',
                        '• Green: 0, 1, 0, 1',
                        '• Blue: 0, 0, 1, 1',
                        '• White: 1, 1, 1, 1',
                        '• Black: 0, 0, 0, 1',
                        '• Transparent: any color with alpha = 0',
                        '',
                        'Rust UI Preset Colors:',
                        '• UiColors.Body - Dark background',
                        '• UiColors.Header - Header bar',
                        '• UiColors.Button - Standard button',
                        '• UiColors.Text - White text',
                        '• UiColors.CloseButton - Red close button',
                      ]),
                      _buildSection('Best Practices', [
                        '1. Always create a root Panel first',
                        '2. Use consistent spacing (0.05 = 5% gaps)',
                        '3. Keep button font sizes 12-16 for readability',
                        '4. Use label font sizes 14-18 for titles',
                        '5. Designer uses 1920×1080 for design clarity',
                        '6. Use the grid overlay for alignment',
                        '7. Give buttons descriptive command names',
                        '8. Add a close button (usually top-right)',
                      ]),
                      _buildSection('Element Types', [
                        'Panel:',
                        '• Container for other elements',
                        '• Can have background color',
                        '• Can enable mouse/keyboard interaction',
                        '• Only element that can be a parent',
                        '',
                        'Button:',
                        '• Clickable with console command',
                        '• Has text, font size, and colors',
                        '• Triggers console command on click',
                        '',
                        'Label:',
                        '• Displays text',
                        '• Optional background color',
                        '• Cannot be clicked',
                        '',
                        'Image:',
                        '• Displays image from URL',
                        '• Use rustlabs.com for item icons',
                        '• Can tint with color',
                      ]),
                      _buildSection('Common UI Patterns', [
                        'Title Bar:',
                        '• Position: 0,0.95 to 1,1',
                        '• Add close button in top-right',
                        '',
                        'Menu Grid:',
                        '• Use consistent spacing (e.g., 0.05 gaps)',
                        '• Equal sized buttons',
                        '• Centered layout',
                        '',
                        'Info Panel:',
                        '• Large panel with labels',
                        '• Item icons with stats',
                        '• Action buttons at bottom',
                      ]),
                      _buildSection('Image URLs', [
                        'Rust Labs (Item Icons):',
                        '• https://rustlabs.com/img/items180/wood.png',
                        '• https://rustlabs.com/img/items180/stone.png',
                        '• Replace "wood" with any item name',
                        '',
                        'Your Own Images:',
                        '• Must be publicly accessible URL',
                        '• PNG or JPG format',
                        '• Smaller images load faster',
                      ]),
                      _buildSection('Workflow Tips', [
                        '1. Design in the app',
                        '2. Export C# code',
                        '3. Copy to clipboard',
                        '4. Paste into your plugin',
                        '5. Save project for future edits',
                        '6. Use descriptive button commands',
                        '7. Test in-game with /menu command',
                      ]),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<String> items) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 8),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 4),
                child: Text(
                  item,
                  style: const TextStyle(fontSize: 13, height: 1.4),
                ),
              )),
        ],
      ),
    );
  }
}
