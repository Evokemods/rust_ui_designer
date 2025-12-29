import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../models/designer_state.dart';
import '../models/ui_element.dart';
import '../models/panel_element.dart';
import '../models/button_element.dart';
import '../models/label_element.dart';
import '../models/image_element.dart';
import '../models/image_button_element.dart';
import '../models/ui_colors_presets.dart';
import '../utils/color_utils.dart';

class PropertiesPanelWidget extends StatelessWidget {
  const PropertiesPanelWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      color: Colors.grey[850],
      child: Consumer<DesignerState>(
        builder: (context, state, child) {
          if (state.selectedElement == null) {
            return const Center(
              child: Text(
                'No element selected',
                style: TextStyle(color: Colors.white54),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Properties',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Type: ${state.selectedElement!.elementType}',
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 20),
                _buildPropertiesForElement(context, state, state.selectedElement!),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPropertiesForElement(BuildContext context, DesignerState state, UiElement element) {
    List<Widget> widgets = [];

    // Common position properties
    widgets.add(_buildSectionTitle('Position'));
    widgets.add(_buildNumberField(
      'Anchor Min X',
      element.anchorMinX,
      (value) {
        element.anchorMinX = value;
        state.updateElement(element.id, element.clone());
      },
    ));
    widgets.add(_buildNumberField(
      'Anchor Min Y',
      element.anchorMinY,
      (value) {
        element.anchorMinY = value;
        state.updateElement(element.id, element.clone());
      },
    ));
    widgets.add(_buildNumberField(
      'Anchor Max X',
      element.anchorMaxX,
      (value) {
        element.anchorMaxX = value;
        state.updateElement(element.id, element.clone());
      },
    ));
    widgets.add(_buildNumberField(
      'Anchor Max Y',
      element.anchorMaxY,
      (value) {
        element.anchorMaxY = value;
        state.updateElement(element.id, element.clone());
      },
    ));

    // Element-specific properties
    if (element is PanelElement) {
      widgets.addAll(_buildPanelProperties(context, state, element));
    } else if (element is ButtonElement) {
      widgets.addAll(_buildButtonProperties(context, state, element));
    } else if (element is LabelElement) {
      widgets.addAll(_buildLabelProperties(context, state, element));
    } else if (element is ImageElement) {
      widgets.addAll(_buildImageProperties(context, state, element));
    } else if (element is ImageButtonElement) {
      widgets.addAll(_buildImageButtonProperties(context, state, element));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: widgets,
    );
  }

  List<Widget> _buildPanelProperties(BuildContext context, DesignerState state, PanelElement panel) {
    return [
      const SizedBox(height: 20),
      _buildSectionTitle('Panel Settings'),
      _buildTextField(
        'Name',
        panel.name,
        (value) {
          panel.name = value;
          state.updateElement(panel.id, panel.clone());
        },
      ),
      _buildColorField(
        context,
        'Background Color',
        panel.backgroundColor,
        (color) {
          panel.backgroundColor = color;
          state.updateElement(panel.id, panel.clone());
        },
      ),
      _buildCheckbox(
        'Needs Mouse',
        panel.needsMouse,
        (value) {
          panel.needsMouse = value;
          state.updateElement(panel.id, panel.clone());
        },
      ),
      _buildCheckbox(
        'Needs Keyboard',
        panel.needsKeyboard,
        (value) {
          panel.needsKeyboard = value;
          state.updateElement(panel.id, panel.clone());
        },
      ),
      _buildDropdownWithInfo<UiLayer>(
        context,
        'Layer',
        panel.layer,
        UiLayer.values,
        (value) {
          panel.layer = value;
          state.updateElement(panel.id, panel.clone());
        },
        (layer) => layer.value,
        _getLayerInfo,
      ),
    ];
  }

  List<Widget> _buildButtonProperties(BuildContext context, DesignerState state, ButtonElement button) {
    return [
      const SizedBox(height: 20),
      _buildSectionTitle('Button Settings'),
      _buildTextField(
        'Text',
        button.text,
        (value) {
          button.text = value;
          state.updateElement(button.id, button.clone());
        },
      ),
      _buildIntField(
        'Font Size',
        button.fontSize,
        (value) {
          button.fontSize = value;
          state.updateElement(button.id, button.clone());
        },
      ),
      _buildInfoBox('💡 Text auto-scales to fit if too large. Make the button bigger or reduce font size for best results.'),
      _buildCommandDropdown(
        context,
        button.command,
        (value) {
          button.command = value;
          state.updateElement(button.id, button.clone());
        },
      ),
      _buildPageNavigationDropdown(
        context,
        state,
        button.navigateToPageId,
        (pageId) {
          button.navigateToPageId = pageId;
          state.updateElement(button.id, button.clone());
        },
      ),
      _buildColorField(
        context,
        'Text Color',
        button.textColor,
        (color) {
          button.textColor = color;
          state.updateElement(button.id, button.clone());
        },
      ),
      _buildColorField(
        context,
        'Background Color',
        button.backgroundColor,
        (color) {
          button.backgroundColor = color;
          state.updateElement(button.id, button.clone());
        },
      ),
    ];
  }

  List<Widget> _buildLabelProperties(BuildContext context, DesignerState state, LabelElement label) {
    return [
      const SizedBox(height: 20),
      _buildSectionTitle('Label Settings'),
      _buildTextField(
        'Text',
        label.text,
        (value) {
          label.text = value;
          state.updateElement(label.id, label.clone());
        },
      ),
      _buildIntField(
        'Font Size',
        label.fontSize,
        (value) {
          label.fontSize = value;
          state.updateElement(label.id, label.clone());
        },
      ),
      _buildInfoBox('💡 Text auto-scales to fit if too large. Make the label bigger or reduce font size for best results.'),
      _buildDropdown<TextAlign>(
        'Text Align',
        label.textAlign,
        [TextAlign.left, TextAlign.center, TextAlign.right],
        (align) {
          label.textAlign = align;
          state.updateElement(label.id, label.clone());
        },
        (align) {
          switch (align) {
            case TextAlign.left: return 'Left';
            case TextAlign.center: return 'Center';
            case TextAlign.right: return 'Right';
            default: return 'Center';
          }
        },
      ),
      _buildColorField(
        context,
        'Text Color',
        label.textColor,
        (color) {
          label.textColor = color;
          state.updateElement(label.id, label.clone());
        },
      ),
      _buildColorField(
        context,
        'Background Color',
        label.backgroundColor ?? Colors.transparent,
        (color) {
          label.backgroundColor = color;
          state.updateElement(label.id, label.clone());
        },
        allowNull: true,
      ),
    ];
  }

  List<Widget> _buildImageProperties(BuildContext context, DesignerState state, ImageElement image) {
    return [
      const SizedBox(height: 20),
      _buildSectionTitle('Image Settings'),
      _buildTextField(
        'Image URL',
        image.imageUrl,
        (value) {
          image.imageUrl = value;
          state.updateElement(image.id, image.clone());
        },
      ),
      _buildInfoBox('💡 Images maintain their aspect ratio and fit within the box. Adjust box size to match your image proportions.'),
    ];
  }

  List<Widget> _buildImageButtonProperties(BuildContext context, DesignerState state, ImageButtonElement imageButton) {
    return [
      const SizedBox(height: 20),
      _buildSectionTitle('Image Button Settings'),
      _buildTextField(
        'Image URL (Normal)',
        imageButton.imageUrl,
        (value) {
          imageButton.imageUrl = value;
          state.updateElement(imageButton.id, imageButton.clone());
        },
      ),
      _buildTextField(
        'Image URL (Clicked)',
        imageButton.imageUrlClicked,
        (value) {
          imageButton.imageUrlClicked = value;
          state.updateElement(imageButton.id, imageButton.clone());
        },
      ),
      _buildInfoBox('💡 Images maintain their aspect ratio and fit within the box. Use square images for best results with square buttons.'),
      _buildCommandDropdown(
        context,
        imageButton.command,
        (value) {
          imageButton.command = value;
          state.updateElement(imageButton.id, imageButton.clone());
        },
      ),
      _buildPageNavigationDropdown(
        context,
        state,
        null, // Image buttons don't have page navigation yet
        (pageId) {
          // Could add page navigation support later
        },
      ),
    ];
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 10),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String value, Function(String) onChanged) {
    final controller = TextEditingController(text: value);
    // Set cursor to end of text
    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.text.length),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 5),
          TextField(
            controller: controller,
            onChanged: onChanged,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[700],
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberField(String label, double value, Function(double) onChanged) {
    final controller = TextEditingController(text: value.toStringAsFixed(3));
    // Set cursor to end of text
    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.text.length),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 5),
          TextField(
            controller: controller,
            onChanged: (v) {
              // Allow empty field temporarily while typing
              if (v.isEmpty) return;

              double? parsed = double.tryParse(v);
              if (parsed != null) {
                onChanged(parsed);
              }
            },
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[700],
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              hintText: 'Enter number',
              hintStyle: TextStyle(color: Colors.white38),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntField(String label, int value, Function(int) onChanged) {
    final controller = TextEditingController(text: value.toString());
    // Set cursor to end of text
    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.text.length),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 5),
          TextField(
            controller: controller,
            onChanged: (v) {
              // Allow empty field temporarily while typing
              if (v.isEmpty) return;

              int? parsed = int.tryParse(v);
              if (parsed != null && parsed > 0) {
                onChanged(parsed);
              }
            },
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[700],
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              hintText: 'Enter number',
              hintStyle: TextStyle(color: Colors.white38),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorField(
    BuildContext context,
    String label,
    Color value,
    Function(Color) onChanged, {
    bool allowNull = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 5),
          GestureDetector(
            onTap: () => _showColorPicker(context, value, onChanged),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: value,
                border: Border.all(color: Colors.white24),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Center(
                child: Text(
                  '#${ColorUtils.colorToInt(value).toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}',
                  style: TextStyle(
                    color: value.computeLuminance() > 0.5 ? Colors.black : Colors.white,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Color Presets
          Text('Color Presets:', style: TextStyle(color: Colors.white54, fontSize: 10)),
          const SizedBox(height: 4),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: UiColorsPresets.basicColors.map((name) {
              final color = UiColorsPresets.presets[name]!;
              return Tooltip(
                message: name,
                child: GestureDetector(
                  onTap: () => onChanged(color),
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: color,
                      border: Border.all(color: Colors.white24, width: 1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckbox(String label, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Checkbox(
            value: value,
            onChanged: (v) => onChanged(v ?? false),
          ),
          Text(label, style: TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildDropdown<T>(
    String label,
    T value,
    List<T> items,
    Function(T) onChanged,
    String Function(T) displayText,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 5),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.grey[700],
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.white24),
            ),
            child: DropdownButton<T>(
              value: value,
              isExpanded: true,
              dropdownColor: Colors.grey[700],
              style: TextStyle(color: Colors.white),
              underline: Container(),
              items: items.map((item) {
                return DropdownMenuItem<T>(
                  value: item,
                  child: Text(displayText(item)),
                );
              }).toList(),
              onChanged: (v) {
                if (v != null) onChanged(v);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownWithInfo<T>(
    BuildContext context,
    String label,
    T value,
    List<T> items,
    Function(T) onChanged,
    String Function(T) displayText,
    String Function(T) getInfo,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(label, style: TextStyle(color: Colors.white70, fontSize: 12)),
              const SizedBox(width: 5),
              Tooltip(
                message: 'Click for layer information',
                child: InkWell(
                  onTap: () => _showLayerInfo(context),
                  child: Icon(
                    Icons.info_outline,
                    size: 16,
                    color: Colors.blue[300],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.grey[700],
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.white24),
            ),
            child: DropdownButton<T>(
              value: value,
              isExpanded: true,
              dropdownColor: Colors.grey[700],
              style: TextStyle(color: Colors.white),
              underline: Container(),
              items: items.map((item) {
                return DropdownMenuItem<T>(
                  value: item,
                  child: Tooltip(
                    message: getInfo(item),
                    child: Text(displayText(item)),
                  ),
                );
              }).toList(),
              onChanged: (v) {
                if (v != null) onChanged(v);
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getLayerInfo(UiLayer layer) {
    switch (layer) {
      case UiLayer.hud:
        return 'Hud: Standard layer for most UIs. Closes when inventory opens. (95% of UIs use this)';
      case UiLayer.overlay:
        return 'Overlay: Middle layer. Stays visible over inventory. Use for persistent notifications.';
      case UiLayer.overall:
        return 'Overall: Top-most layer. Always visible, even over menus. Use for admin panels only.';
    }
  }

  void _showLayerInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.layers, color: Colors.blue),
            SizedBox(width: 10),
            Text('UI Layers Explained'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLayerInfoSection(
                'Hud (Default - Most Common)',
                '✅ Use this for 95% of plugin UIs',
                [
                  'Standard layer for menus, shops, info panels',
                  'Closes when player opens inventory/map',
                  'Perfect for: Shop menus, stats panels, teleport menus',
                ],
                Colors.green,
              ),
              SizedBox(height: 16),
              _buildLayerInfoSection(
                'Overlay (Middle Layer)',
                'Use for persistent information',
                [
                  'Stays visible when inventory/map opens',
                  'Renders above Hud but below Overall',
                  'Perfect for: Kill feed, notifications, event timers',
                ],
                Colors.orange,
              ),
              SizedBox(height: 16),
              _buildLayerInfoSection(
                'Overall (Top-Most)',
                '⚠️ Use sparingly - Admin/Critical only',
                [
                  'Always on top of EVERYTHING',
                  'Cannot be closed by opening inventory',
                  'Perfect for: Admin panels, server warnings, debug tools',
                  'WARNING: Players cannot close by pressing ESC/Tab',
                ],
                Colors.red,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Got it!'),
          ),
        ],
      ),
    );
  }

  Widget _buildLayerInfoSection(String title, String subtitle, List<String> points, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: color,
          ),
        ),
        SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            fontStyle: FontStyle.italic,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 8),
        ...points.map((point) => Padding(
              padding: EdgeInsets.only(left: 12, bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('• ', style: TextStyle(color: color)),
                  Expanded(
                    child: Text(
                      point,
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildCommandDropdown(BuildContext context, String value, Function(String) onChanged) {
    // Common UI commands for Rust plugins
    final List<String> commonCommands = [
      'ui.close',
      'ui.confirm',
      'ui.cancel',
      'ui.next',
      'ui.previous',
      'ui.submit',
      'menu.open',
      'menu.close',
      'shop.buy',
      'shop.sell',
      'teleport.confirm',
      'teleport.cancel',
      'settings.save',
      'button.click',
      'Custom...',
    ];

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Command', style: TextStyle(color: Colors.white70, fontSize: 12)),
              const SizedBox(width: 8),
              Tooltip(
                message: 'Select a common command or type a custom one',
                child: Icon(Icons.info_outline, size: 16, color: Colors.blue[300]),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Expanded(
                child: DropdownButton<String>(
                  value: commonCommands.contains(value) ? value : 'Custom...',
                  isExpanded: true,
                  dropdownColor: Colors.grey[800],
                  style: TextStyle(color: Colors.white),
                  items: commonCommands.map((cmd) {
                    return DropdownMenuItem<String>(
                      value: cmd,
                      child: Text(
                        cmd,
                        style: TextStyle(
                          color: cmd == 'Custom...' ? Colors.blue[300] : Colors.white,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    if (newValue != null && newValue != 'Custom...') {
                      onChanged(newValue);
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: TextEditingController(text: value)..selection = TextSelection.collapsed(offset: value.length),
            onChanged: onChanged,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[700],
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              hintText: 'Type custom command',
              hintStyle: TextStyle(color: Colors.white38),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageNavigationDropdown(
    BuildContext context,
    DesignerState state,
    String? selectedPageId,
    Function(String?) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Navigate To Page', style: TextStyle(color: Colors.white70, fontSize: 12)),
              const SizedBox(width: 8),
              Tooltip(
                message: 'Select which page this button navigates to',
                child: Icon(Icons.info_outline, size: 16, color: Colors.blue[300]),
              ),
            ],
          ),
          const SizedBox(height: 5),
          DropdownButton<String?>(
            value: selectedPageId,
            isExpanded: true,
            dropdownColor: Colors.grey[800],
            style: TextStyle(color: Colors.white),
            hint: Text('No navigation', style: TextStyle(color: Colors.white38)),
            items: [
              DropdownMenuItem<String?>(
                value: null,
                child: Text('No navigation', style: TextStyle(color: Colors.white38)),
              ),
              ...state.pages.map((page) {
                return DropdownMenuItem<String?>(
                  value: page.id,
                  child: Text(page.name, style: TextStyle(color: Colors.white)),
                );
              }),
            ],
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBox(String message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(33, 150, 243, 0.1),
          border: Border.all(color: const Color.fromRGBO(33, 150, 243, 0.3)),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: Colors.blue[200], fontSize: 11),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showColorPicker(BuildContext context, Color currentColor, Function(Color) onChanged) {
    showDialog(
      context: context,
      builder: (context) {
        Color pickedColor = currentColor;
        return AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: currentColor,
              onColorChanged: (color) {
                pickedColor = color;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                onChanged(pickedColor);
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
